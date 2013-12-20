module Cvent
  class Event
    OBJECT_TYPE = "Event"

    attr_accessor :title

    def self.get_updated_ids(start_date, end_date = DateTime.now)
      message = {
        "ObjectType" => self::OBJECT_TYPE,
        "StartDate" => start_date.strftime("%Y-%m-%dT%H:%M:%S"),
        "EndDate" => end_date.strftime("%Y-%m-%dT%H:%M:%S")
      }
      begin
        response = Cvent::Client.instance.call(:get_updated, message)
        if response && response.body[:get_updated_response] && response.body[:get_updated_response][:get_updated_result]
          return response.body[:get_updated_response][:get_updated_result][:id]
        else
          return []
        end
      rescue
        return []
      end
    end

    def self.fetch_from_ids(event_ids=[])
      message = {
        "ObjectType" => self::OBJECT_TYPE,
        "ins0:Ids" => { "ins0:Id" => event_ids }
      }

      return [] if event_ids.empty?

      begin
        response = Cvent::Client.instance.call(:retrieve, message)

        if response.body && response.body[:retrieve_response] && response.body[:retrieve_response][:retrieve_result] && response.body[:retrieve_response][:retrieve_result][:cv_object]
          cvent_events = response.body[:retrieve_response][:retrieve_result][:cv_object]
          cvent_events = [cvent_events] if cvent_events.is_a? Hash

          cvent_events.collect { |e| self.transform_to_event_object(e) }
        end
      rescue => e
        return []
      end
    end

    private

    def self.transform_to_event_object(cvent_event)
      #TODO: Transform into a proper event object
      e = Cvent::Event.new
      e.title = cvent_event[:title]

      return cvent_event
    end
  end
end
