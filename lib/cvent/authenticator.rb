module Cvent
  class Authenticator
    extend Savon::Model

    def self.client
      super wsdl: Cvent.config['wsdl'], ssl_version: :TLSv1
    end

    operations :login

    def self.login(account, username, password)
      super message: {
        'AccountNumber' => account,
        'UserName' => username,
        'Password' => password
      }
    end
  end
end
