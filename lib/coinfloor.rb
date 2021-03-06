require 'active_support/core_ext'
require 'active_support/inflector'
require 'active_model'
require 'rest_client'
require 'hmac-sha2'

require 'coinfloor/net'
require 'coinfloor/helper'
require 'coinfloor/collection'
require 'coinfloor/model'

require 'coinfloor/orders'
require 'coinfloor/transactions'
require 'coinfloor/ticker'

String.send(:include, ActiveSupport::Inflector)

module Coinfloor
  # API Key
  mattr_accessor :key

  # Coinfloor secret
  mattr_accessor :secret

  # Coinfloor client ID
  mattr_accessor :client_id

  # Currency
  mattr_accessor :currency
  @@currency = :gbp

  def self.orders
    self.sanity_check!

    @@orders ||= Coinfloor::Orders.new
  end

  def self.user_transactions
    self.sanity_check!

    @@transactions ||= Coinfloor::UserTransactions.new
  end

  def self.transactions
    return Coinfloor::Transactions.from_api
  end

  def self.balance
    self.sanity_check!

    JSON.parse Coinfloor::Net.post('/balance').to_str
  end

  def self.withdraw_bitcoins(options = {})
    self.sanity_check!
    if options[:amount].nil? || options[:address].nil?
      raise MissingConfigExeception.new("Required parameters not supplied, :amount, :address")
    end
    response_body = Coinfloor::Net.post('/bitcoin_withdrawal',options).body_str
    if response_body != 'true'
      return JSON.parse response_body
    else
      return response_body
    end
  end

  def self.bitcoin_deposit_address
    # returns the deposit address
    self.sanity_check!
    return Coinfloor::Net.post('/bitcoin_deposit_address').body_str
  end

  def self.unconfirmed_user_deposits
    self.sanity_check!
    return JSON.parse Coinfloor::Net::post("/unconfirmed_btc").body_str
  end

  def self.ticker
    return Coinfloor::Ticker.from_api
  end

  def self.order_book
    return JSON.parse Coinfloor::Net.get('/order_book').to_str
  end

  def self.setup
    yield self
  end

  def self.configured?
    self.key && self.secret && self.client_id
  end

  def self.sanity_check!
    unless configured?
      raise MissingConfigExeception.new("Coinfloor Gem not properly configured")
    end
  end

  class MissingConfigExeception<Exception;end;
end
