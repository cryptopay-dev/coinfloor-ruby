module Coinfloor
  class Ticker < Coinfloor::Model
    attr_accessor :last, :high, :low, :volume, :bid, :ask, :timestamp, :vwap

    def self.from_api
      Coinfloor::Helper.parse_object!(Coinfloor::Net.get('/ticker').to_str, self)
    end

    def self.method_missing method, *args
      ticker = self.from_api
      return ticker.send(method) if ticker.respond_to? method

      super
    end
  end
end
