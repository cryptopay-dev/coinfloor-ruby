module Coinfloor
  module Net
    def self.to_uri(path)
      return "https://webapi.coinfloor.co.uk:8090/bist/XBT/GBP#{path}/"
    end

    def self.get(path, options={})
      RestClient::Request.execute method: :get,
                                  url: self.to_uri(path),
                                  user: "#{Coinfloor.client_id}/#{Coinfloor.key}",
                                  password: Coinfloor.secret
    end

    def self.post(path, options={})
      RestClient::Request.execute method: :post,
                                  payload: options,
                                  url: self.to_uri(path),
                                  user: "#{Coinfloor.client_id}/#{Coinfloor.key}",
                                  password: Coinfloor.secret
    end

    def self.patch(path, options={})
      RestClient.put(self.to_uri(path), self.coinfloor_options(options))
    end

    def self.delete(path, options={})
      RestClient.delete(self.to_uri(path), self.coinfloor_options(options))
    end

    def self.coinfloor_options(options={})
      # if Coinfloor.configured?
      #   options[:user] = "#{Coinfloor.client_id}/#{Coinfloor.key}"
      #   options[:password] = Coinfloor.secret
      # end
      options
    end
  end
end
