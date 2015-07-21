module Cvent
  class Model
    def self.type
      fail 'IMPLEMENT ME!'
    end

    def self.where(*ids)
      response = Cvent::Api.retrieve(type, ids)
      os = response.body[:retrieve_response][:retrieve_result][:cv_object]
      os = os.respond_to?(:to_ary) ? os : [os]
      os.map { |o| self.new(o) }
    end

    def self.find!(id)
      result = self.where(id).first
      raise 'No Object Found' if result.nil?
      result
    end

    #def self.create
    #end

    #def destroy
    #end

    #def update
    #end

    #def upsert
    #end

    def initialize(hash)
      hash.each do |key, val|
        # Clean up attribute names
        key = key.to_s.gsub(/[\W]/, '')
        # Recursively wrap hashes
        self.instance_variable_set("@#{key}",
          val.is_a?(Hash) ? Model.new(val) : val)
        # Create reader
        self.class.send(:define_method,
          key,
          proc{self.instance_variable_get("@#{key}")})
        # Create Setter
        self.class.send(:define_method,
          "#{key}=",
          proc{|v| self.instance_variable_set("@#{key}", v)})
      end
    end
  end
end
