module Coinfloor
  class Orders < Coinfloor::Collection
    def all(options = {})
      Coinfloor::Helper.parse_objects! Coinfloor::Net::post('/open_orders').to_str, self.model
    end

    def create(options = {})
      path = (options[:type] == Coinfloor::Order::SELL ? "/sell" : "/buy")
      Coinfloor::Helper.parse_object! Coinfloor::Net::post(path, options).to_str, self.model
    end

    def sell(options = {})
      options.merge!({type: Coinfloor::Order::SELL})
      self.create options
    end

    def buy(options = {})
      options.merge!({type: Coinfloor::Order::BUY})
      self.create options
    end

    def find(order_id)
      all = self.all
      index = all.index {|order| order.id.to_i == order_id}

      return all[index] if index
    end
  end

  class Order < Coinfloor::Model
    BUY  = 0
    SELL = 1

    attr_accessor :type, :amount, :price, :id, :datetime
    attr_accessor :error, :message

    def cancel!
      Coinfloor::Net::post('/cancel_order', {id: self.id}).to_str
    end
  end
end
