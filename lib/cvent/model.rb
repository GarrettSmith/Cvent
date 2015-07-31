module Cvent
  class Model
    # Override if your model name is not the same as the related Cvent object
    def self.type
      self.name.split('::').last
    end

    def self.find_by_ids(*ids)
      response = Cvent::Api.retrieve(type, ids)
      os = extract :retrieve, response, additional_key: :cv_object
      wrap os if os
    end

    def self.find!(id)
      result = self.find_by_ids(id)
      result = result.first if result
      raise 'No Object Found' if result.nil?
      result
    end

    def self.search(opts = {})
      response = Cvent::Api.search(type, 'AndSearch', opts)
      response = extract :search, response
      response[:id]
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

    private

    def self.wrap(os)
      os = os.respond_to?(:to_ary) ? os : [os]
      os.map { |o| self.new(o) }
    end

    def self.extract(action, response, additional_key: nil)
      response_key = "#{action}_response".to_sym
      request_key = "#{action}_result".to_sym
      os = response.body[response_key][request_key]
      os = os[additional_key] if additional_key
      os
    end
  end
end
