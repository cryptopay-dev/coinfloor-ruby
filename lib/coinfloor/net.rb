module Coinfloor
  module Net
    def self.to_uri(path)
      return "https://webapi.coinfloor.co.uk:8090/bist/XBT/#{Coinfloor.currency.upcase}#{path}/"
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
      RestClient::Request.execute method: :put,
                                  payload: options,
                                  url: self.to_uri(path),
                                  user: "#{Coinfloor.client_id}/#{Coinfloor.key}",
                                  password: Coinfloor.secret
    end

    def self.delete(path, options={})
      RestClient::Request.execute method: :delete,
                                  payload: options,
                                  url: self.to_uri(path),
                                  user: "#{Coinfloor.client_id}/#{Coinfloor.key}",
                                  password: Coinfloor.secret
    end

  end
end
