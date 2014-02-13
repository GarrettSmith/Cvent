require "#{File.dirname(__FILE__)}/lib/cvent.rb"

Cvent::Client.instance.load_config("#{File.dirname(__FILE__)}/cvent_credentials.yml", 'development')

ids = Cvent::Event.get_updated_ids((DateTime.now - 14))
@response = Cvent::Event.fetch_from_ids(ids)

