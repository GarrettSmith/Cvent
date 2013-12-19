require 'singleton'
require 'yaml'

module Cvent
  class Client
    include Singleton

    WSDL_PATH = "https://api.cvent.com/soap/V200611.ASMX?WSDL"

    def load_config(file_path, environment)
      @@client_configuration = YAML::load(File.open(file_path))
      @@environment = environment
    end

    def connect
      raise MissingCredentialsError.new("You must provide a config file by calling 'load_config' before connecting.") if @@client_configuration.nil?
      @@client = Savon.client(wsdl: Cvent::Client::WSDL_PATH)
      response = @@client.call(:login, message: { 
        "AccountNumber" => @@client_configuration[@@environment][:account],
        "UserName" => @@client_configuration[@@environment][:username], 
        "Password" => @@client_configuration[@@environment][:password]})
      raise response
    end

  end

  class MissingCredentialsError < StandardError; end
end
