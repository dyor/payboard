require 'sinatra'
require 'sinatra/reloader'
require 'stripe'

get '/' do
  "Welcome to Payboard!"
end

get '/test/customers' do
  Stripe.api_key = 'sk_test_Nc9GpIjxcYSFf03SgMNWsf9z'
  cust_names = Stripe::Customer.all.map{|c| c.description}.join(',')
end