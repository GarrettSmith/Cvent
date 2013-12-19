module Cvent
  class Event
    OBJECT_TYPE = "Event"

    def self.get_updated_ids(start_date, end_date = DateTime.now)
      message = {
        "ObjectType" => self::OBJECT_TYPE,
        "StartDate" => start_date.strftime("%Y-%m-%dT%H:%M:%S"),
        "EndDate" => end_date.strftime("%Y-%m-%dT%H:%M:%S")
      }
      response = Cvent::Client.instance.call(:get_updated, message)
    end
  end
end
