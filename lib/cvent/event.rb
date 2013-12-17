module Cvent
  class Event
    include HTTParty

    def initialize(event_code)
      @ecode = event_code
    end

    def authenticate(user_fields = {})
      self.class.post(Cvent::AUTHENTICATION_URL, authentication_options(user_fields))
    end

    private

    def authentication_options(user_fields)
      options = { 
        body: { 
          ecode: @ecode,
          first_name: user_fields[:first_name],
          last_name: user_fields[:last_name],
          email_address: user_fields[:email_address],
          source_id: user_fields[:source_id],
          target: user_fields[:target] || ""
        }
      }
    end
  end
end
