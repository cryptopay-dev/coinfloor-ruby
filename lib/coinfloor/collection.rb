module Coinfloor
  class Collection
    attr_accessor :access_token, :module, :name, :model, :path

    def initialize(api_prefix="/api")
      self.access_token = Coinfloor.key

      self.module = self.class.to_s.singularize.underscore
      self.name   = self.module.split('/').last
      self.model  = self.module.camelize.constantize
      self.path   = "#{api_prefix}/#{self.name.pluralize}"
    end

    def all(options = {})
      Coinfloor::Helper.parse_objects! Coinfloor::Net::get(self.path).to_str, self.model
    end

    def create(options = {})
      Coinfloor::Helper.parse_object! Coinfloor::Net::post(self.path, options).to_str, self.model
    end

    def find(id, options = {})
      Coinfloor::Helper.parse_object! Coinfloor::Net::get("#{self.path}/#{id}").to_str, self.model
    end

    def update(id, options = {})
      Coinfloor::Helper.parse_object! Coinfloor::Net::patch("#{self.path}/#{id}", options).to_str, self.model
    end
  end
end
