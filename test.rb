require '/Users/mikeburkle/Projects/cvent/lib/cvent.rb'

Cvent::Client.instance.load_config('/Users/mikeburkle/Projects/cvent/cvent_credentials.yml', 'development')

ids = Cvent::Event.get_updated_ids((DateTime.now - 14))
@@response = Cvent::Event.fetch_from_ids(ids)

