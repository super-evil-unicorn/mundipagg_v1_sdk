module MundipaggV1Sdk

  require "base64"
  require 'rest-client'
  require 'json'

  @@end_point = "https://api.mundipagg.com/core/v1"

  @@SERVICE_HEADERS = {
    :Authorization  => "Basic #{::Base64.encode64("sk_test_WMdm1KYsYXuQVj1n:")}".strip,
    :Accept         => 'application/json',
    :"Content-Type" => 'application/json'
  }

  # funcao de post generica
  def postRequest(payload, url)
    begin
      response = RestClient.post("#{@@end_point}#{url}", payload, headers=@@SERVICE_HEADERS)
    rescue RestClient::ExceptionWithResponse => err
      handle_error_response(err)
      response = err.response
    end

    JSON.load response
  rescue JSON::ParserError => err
    response
  end

  # funcao patch generica
  def patchRequest(payload, url)
    begin
      response = RestClient.patch("#{@@end_point}#{url}", payload, headers=@@SERVICE_HEADERS)
    rescue RestClient::ExceptionWithResponse => err
      handle_error_response(err)
      response = err.response
    end

    JSON.load response
  rescue JSON::ParserError => err
    response
  end

  # funcao de delete generica
  def deleteRequest(url)
    begin
      response = RestClient.delete("#{@@end_point}#{url}", headers=@@SERVICE_HEADERS)
    rescue RestClient::ExceptionWithResponse => err
      handle_error_response(err)
      response = err.response
    end

    JSON.load response
  rescue JSON::ParserError => err
    response
  end

  # funcao get generica
  def getRequest(url)
    begin
      response = RestClient.get("#{@@end_point}#{url}", headers=@@SERVICE_HEADERS)
    rescue RestClient::ExceptionWithResponse => err
      handle_error_response(err)
      response = err.response
    end

    v = JSON.load response
    return v["data"] if v["data"] != nil
    return v
  rescue JSON::ParserError => err
    response
  end

  def handle_error_response(err)
    # MundipaggV1Sdk::AuthenticationError.new
    err_response = JSON.load(err.response)
    puts err_response["message"]
    puts JSON.pretty_generate(err_response["errors"])
    raise(::Exception.new( err_response["message"] ))
  end

end

class MundipaggV1Sdk::Customer

  extend MundipaggV1Sdk

  def self.create(customer)
    customer = {} if customer == nil
    postRequest(customer.to_json, "/customers")
  end

  def self.retrieve(customer_id)
    ArgumentError.new("Customer id should be a String") if customer_id == nil
    getRequest("/customers/#{customer_id}")
  end

  def self.list
    getRequest("/customers")
  end

  def self.edit(customer_id, customer)
    # PUT
  end

end

class MundipaggV1Sdk::AccessToken

  extend MundipaggV1Sdk

  def self.create(customer_id)
    ArgumentError.new("Customer id should be a String") if customer_id == nil
    body = {}
    postRequest(body.to_json, "/customers/#{customer_id}/access-tokens")
  end

  def self.retrieve(customer_id, access_token_id)
    ArgumentError.new("Customer id should be a String") if customer_id == nil
    ArgumentError.new("Access Token id should be a String") if access_token_id == nil
    getRequest("/customers/#{customer_id}/access-tokens/#{access_token_id}")
  end

  def self.list(customer_id)
    ArgumentError.new("Customer id should be a String") if customer_id == nil
    getRequest("/customers/#{customer_id}/access-tokens")
  end

  def self.delete(customer_id, access_token_id)
    ArgumentError.new("Customer id should be a String") if customer_id == nil
    ArgumentError.new("Access Token id should be a String") if access_token_id == nil
    deleteRequest("/customers/#{customer_id}/access-tokens/#{access_token_id}")
  end

end

class MundipaggV1Sdk::Card

  extend MundipaggV1Sdk

  def self.create(customer_id, card)
    card = {} if card == nil
    postRequest(card.to_json, "/customers/#{customer_id}/cards")
  end

  def self.retrieve(customer_id, card_id)
    ArgumentError.new("Customer id should be a String") if customer_id == nil
    ArgumentError.new("Card can't be nil") if card_id == nil
    getRequest("/customers/#{customer_id}/cards/#{card_id}")
  end

  def self.list(customer_id)
    ArgumentError.new("Customer id should be a String") if customer_id == nil
    getRequest("/customers/#{customer_id}/cards")
  end

  def self.delete(customer_id, card_id)
    ArgumentError.new("Customer id should be a String") if customer_id == nil
    ArgumentError.new("Card id should be a String") if card_id == nil
    deleteRequest("/customers/#{customer_id}/cards/#{card_id}")
  end

end

class MundipaggV1Sdk::Charge

  extend MundipaggV1Sdk

  def self.create(charge)
    charge = {} if charge == nil
    postRequest(charge.to_json, "/charges")
  end

  def self.retrieve(charge_id)
    ArgumentError.new("Charge id should be a String") if charge_id == nil
    getRequest("/charges/#{charge_id}")
  end

  def self.list(order_id = nil, customer_id = nil, page = nil, size = nil)
    query = []
    query << "order_id=#{order_id}" if !order_id.nil?
    query << "customer_id=#{customer_id}" if !customer_id.nil?
    query << "page=#{page}" if !page.nil?
    query << "size=#{size}" if !size.nil?
    query.first.prepend("?") if !query.empty?
    getRequest("/charges#{query.join("&")}")
  end

  def self.capture(charge_id, capture)
    ArgumentError.new("Charge id should be a String") if charge_id == nil
    capture = {} if capture == nil
    postRequest(capture.to_json, "/charges/#{charge_id}/capture")
  end

  def self.delete(charge_id, params)
    ArgumentError.new("Charge id should be a String") if charge_id == nil
    params = {} if params == nil
    deleteRequest(params.to_json, "/charges/#{charge_id}")
  end

  def self.edit_credit_card()
    # PATCH
  end

  def self.edit_due_date()
    # PATCH
  end

  def self.edit_payment_method()
    # PATCH
  end

  def self.retry()
    # POST
  end

end

class MundipaggV1Sdk::Plan

  extend MundipaggV1Sdk

  def self.create(plan)
    plan = {} if plan == nil
    postRequest(plan.to_json, "/plans")
  end

  def self.retrieve(plan_id)
    ArgumentError.new("Plan id should be a String") if plan_id == nil
    getRequest("/plans/#{plan_id}")
  end

  def self.list
    # GET
  end

  def self.list_subscriptions
    # GET
  end

  def self.edit
    # PUT
  end

  def self.delete
    # DELETE
  end

end

class MundipaggV1Sdk::PlanItem

  extend MundipaggV1Sdk

  def self.include_in_plan
    # POST
  end

  def self.edit
    # PUT
  end

  def self.remove_from_plan
    # DELETE
  end

end

class MundipaggV1Sdk::Order

  extend MundipaggV1Sdk

  def self.create(order)
    order = {} if order == nil
    postRequest(order.to_json, "/orders")
  end

  def self.retrieve(charge_id)
    # ArgumentError.new("Charge id should be a String") if charge_id == nil
    # getRequest("/charges/#{charge_id}")
  end

  def self.list(order_id = nil, customer_id = nil, page = nil, size = nil)
    # query = []
    # query << "order_id=#{order_id}" if !order_id.nil?
    # query << "customer_id=#{customer_id}" if !customer_id.nil?
    # query << "page=#{page}" if !page.nil?
    # query << "size=#{size}" if !size.nil?
    # query.first.prepend("?") if !query.empty?
    # getRequest("/charges#{query.join("&")}")
  end

  def self.include_charge()
    # POST
  end

end

class MundipaggV1Sdk::OrderItem

  extend MundipaggV1Sdk

  def self.include_in_order(order_id, order_item)
    ArgumentError.new("Order id should be a String") if order_id == nil
    order_item = {} if order_item == nil
    postRequest(order_item.to_json, "/orders/#{order_id}/items")
  end

  def self.edit(order_id, order_item_id, order_item)
    ArgumentError.new("Order id should be a String") if order_id == nil
    ArgumentError.new("Order Item id should be a String") if order_item_id == nil
    order_item = {} if order_item == nil
    patchRequest(order_item.to_json, "/orders/#{order_id}/items/#{order_item}")
  end

  def self.delete(order_id, order_item_id)
    ArgumentError.new("Order id should be a String") if order_id == nil
    ArgumentError.new("Order Item id should be a String") if order_item_id == nil
    deleteRequest("/orders/#{order_id}/items/#{order_item}")
  end

  def self.delete_all_from_order(order_id)
    ArgumentError.new("Order id should be a String") if order_id == nil
    deleteRequest("/orders/#{order_id}/items/")
  end

end

class MundipaggV1Sdk::Address

  extend MundipaggV1Sdk

  def self.create(address)
    address = {} if address == nil
    postRequest(address.to_json, "/addresses")
  end

  def self.retrieve(customer_id, address_id)
    ArgumentError.new("Customer id should be a String") if customer == nil
    ArgumentError.new("Address id should be a String") if address_id == nil
    getRequest("/customers/#{customer_id}/addresses/#{address_id}")
  end

  def self.edit(customer_id, address_id, address)
    ArgumentError.new("Customer id should be a String") if customer == nil
    ArgumentError.new("Address id should be a String") if address_id == nil
    address = {} if address == nil
    putRequest(address.to_json, "/customers/#{customer_id}/addresses/#{address_id}")
  end

  def self.delete(customer_id, address_id, address)
    ArgumentError.new("Customer id should be a String") if customer == nil
    ArgumentError.new("Address id should be a String") if address_id == nil
    deleteRequest("/customers/#{customer_id}/addresses/#{address_id}")
  end

  def self.list(customer_id = nil, page = nil, size = nil)
    query = []
    query << "page=#{page}" if !page.nil?
    query << "size=#{size}" if !size.nil?
    query.first.prepend("?") if !query.empty?
    getRequest("/customers/#{customer_id}/addresses#{query.join("&")}")
  end

end

class MundipaggV1Sdk::Subscription

  extend MundipaggV1Sdk

  def self.create(subscription)
    subscription = {} if subscription nil
    postRequest(subscription.to_json, "/subscriptions")
  end

  def self.create_from_plan
    # POST
  end

  def self.retrieve
    # GET
  end

  def self.cancel
    # DELETE
  end

  def self.list
    # GET
  end

  def self.edit_credit_card
    # PATCH
  end

  def self.edit_payment_method
    # PATCH
  end

  def edit_billing_date
    # PATCH
  end

end

class MundipaggV1Sdk::SubscriptionItem

  extend MundipaggV1Sdk

  def self.include
    # POST
  end

  def self.edit
    # PUT
  end

  def self.remove
    # DELETE
  end

end

class MundipaggV1Sdk::SubscriptionItemUsage

  extend MundipaggV1Sdk

  def self.include
    # POST
  end

  def self.remove
    # DELETE
  end

  def self.list
    # GET
  end

end

class MundipaggV1Sdk::SubscriptionDiscount

  extend MundipaggV1Sdk

  def self.include_in_subscription
    # POST
  end

  def self.remove_from_subscription
    # DELETE
  end

end

class MundipaggV1Sdk::Invoice

  extend MundipaggV1Sdk

  def self.create(subscription_id, cycle_id)
    ArgumentError.new("Subscription id should be a String") if subscription_id == nil
    ArgumentError.new("Cycle id should be a String") if cycle_id == nil
    invoice = {}
    postRequest(invoice.to_json, "/subscriptions/#{subscription_id}/cycles/#{cycle_id}/pay")
  end

  def self.cancel
    # DELETE
  end

  def self.list
    # GET
  end

  def self.retrieve
    # GET
  end

end

class MundipaggV1Sdk::Token

  extend MundipaggV1Sdk

  def self.create(token)
    token = {} if token nil
    postRequest(token.to_json, "/tokens")
  end

end

class MundipaggV1Sdk::Webhook

  extend MundipaggV1Sdk

  def self.create(hook_id)
    ArgumentError.new("Webhook id should be a String") if hook_id == nil
    hook = {}
    postRequest(hook.to_json, "/tokens")
  end

  def self.retrieve
    # GET
  end

  def self.list
    # GET
  end

end

class MundipaggV1Sdk::AuthenticationError
end
