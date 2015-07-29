module Cvent
  class Authenticator
    extend Savon::Model

    def self.client
      super convert_request_keys_to: :camelcase,
        soap_version: 2,
        ssl_version: :TLSv1,
        wsdl: Cvent.config['wsdl']
    end

    operations :login

    def self.login(account, username, password)
      super message: {
        account_number: account,
        user_name: username,
        password: password
      }
    end
  end
end
