class MainController < ApplicationController
  include Registrar
  require "net/http"
  require "uri"
  require 'json'
  require 'nokogiri'


  
  # GET /
  def index
    # Store invite token
    session[:invite_token] = params[:invite_token] if params[:invite_token] && invite_registration
  end
  
  # POST /validate
  def validate
    @cpf = Cpf.new(number: main_params[:number])
    
    @cpf[:number].gsub(".", "")
    @cpf[:number].gsub("-", "")
    
    
    uri = URI('https://validacao-interna.validcertificadora.com.br/')
    res = Net::HTTP.post_form(uri, 'cpf' => @cpf[:number], 'gg' => 'Verificar')
    document = Nokogiri::HTML(res.body)
    resultado = document.at('#resultcpf').text

    if resultado.include? "disponível"
      flash[:success] = "O CPF #{@cpf[:number]} pode ser atendido por videoconferência!"
    end
    if resultado.include? "indisponível"
        flash[:alert] = "O CPF #{@cpf[:number]} não pode ser atendido por videoconferência!"
    end
    
    return redirect_to "/"
  end

  private
  def main_params
    params.require(:cpf).permit(:number)
  end
end
