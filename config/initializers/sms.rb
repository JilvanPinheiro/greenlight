require 'aws-sdk-sns' 

module Sms
    SNS = Aws::SNS::Client.new()
    def send_sms_message(phone, url, code)
        begin
            SNS.publish({
                phone_number: "+55#{phone}",
                message: "Doccloud: Link de validação do certificado digital: https://videoconferencia.doccloud.com.br/#{url}" 
                })
            SNS.publish({
                phone_number: "+55#{phone}",
                message: "Doccloud: Código de acesso para validação do certificado digital: #{code}." 
                })            
        rescue => exception
            flash[:alert] = I18n.t(I18n.t("delivery_error"))
        end
    end
end

