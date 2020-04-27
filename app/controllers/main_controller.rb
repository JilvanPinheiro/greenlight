class MainController < ApplicationController
  include Registrar
  require "net/http"
  require "uri"
  require 'json'
  
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


    uri = URI.parse("https://arsoluti.acsoluti.com.br/site/idn-psbio-verify")
    header = {'Content-Type': 'text/json'}
    
    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    body = {cpf: @cpf[:number] }
    request.body = body.to_json
    
    # Send the request
    response = http.request(request)
    result = JSON.parse(response.body)

    if result["idnValid"]
      flash[:success] = "O CPF #{@cpf[:number]} pode ser atendido por videoconferência!"
    else
      flash[:alert] = "O CPF #{@cpf[:number]} não pode ser atendido por videoconferência!"
    end
    
    return redirect_to "/"
  end

  private
  def main_params
    params.require(:cpf).permit(:number)
  end
end
