require 'yaml'
<<<<<<< HEAD
require 'erb'

=======
>>>>>>> 5427116df52ba2ac3199ff0588fbc65fcdcad8ff
module Cvent
  WSDL_PATH = "https://api.cvent.com/soap/V200611.ASMX?WSDL"
  SANDBOX_WSDL_PATH = "https://sandbox-api.cvent.com/soap/V200611.ASMX?WSDL"

  class << self
    @@config = nil
    def self.config
      fail raise Cvent::MissingCredentialsError.new if @@config.nil?
      @@config
    end
    def config
      fail raise Cvent::MissingCredentialsError.new if @@config.nil?
      @@config
    end
  end

  def self.load_config(file_path, environment=:default)
    template = ERB.new File.new(file_path).read
    client_configuration = YAML.load template.result(binding)
    environment = environment.to_s
    @@config = client_configuration[environment]
    self.config['wsdl'] = self.config['sandbox'] ? Cvent::SANDBOX_WSDL_PATH : Cvent::WSDL_PATH
    config
  end
end
