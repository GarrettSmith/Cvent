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
          last_name: user_fields[:last_name]
        }
      }
    end
  end
end
