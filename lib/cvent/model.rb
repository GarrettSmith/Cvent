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
      hash.each { |k, v| define_accessor k, v }
    end

    protected

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

    def self.model_wrap(val)
      if val.is_a? Array
        val.map { |v| model_wrap v }
      elsif val.is_a? Hash
        Model.new val
      elsif val =~ /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/
        Time.parse "#{val} GMT"
      else
        val
      end
    end

    def define_accessor(key, val = nil)
      key = var_name key
      instance_var key, val
      reader key
      writer key
    end

    def define_reader(key, val = nil)
      key = var_name key
      instance_var key, val
      reader key
    end

    def define_writer(key, val = nil)
      key = var_name key
      instance_var key, val
      writer key
    end

    def define_instance_var(key, val = nil)
      key = var_name key
      instance_var key, val
    end

    def var_name(s)
        s.to_s
         .strip
         .downcase
         .gsub(/\s/, '_') # replace spaces with underscores
         .gsub(/[\W]/, '') # remove odd characters
    end

    private

    def reader(key)
      self.class.send :define_method,
        key,
        proc { self.instance_variable_get(instance_var_name(key)) }
    end

    def writer(key)
      self.class.send :define_method,
        "#{key}=",
        proc { |v| self.instance_variable_set(instance_var_name(key), v) }
    end

    def instance_var(key, val)
      instance_variable_set(instance_var_name(key), self.class.model_wrap(val))
    end

    def instance_var_name(key)
      "@#{key}"
    end

  end
end
