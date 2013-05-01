$: << File.expand_path(File.dirname(__FILE__) + "/components")

require 'sinatra'
require 'sinatra/reloader'
require 'stripe'
require 'oauth2_client'

enable :sessions

configure do
  set :client_id, ENV['STRIPE_CLIENT_ID']
  set :my_api_key, ENV['STRIPE_API_KEY']
  set :state, Digest::SHA2.hexdigest(rand.to_s)

  set :bind, '192.168.106.128'
end

get '/' do
  @authorize_url = OAuth2Client.new(settings).authorize_url
  session[:api_key] = settings.my_api_key
  @categories = ['Jun-12', 'Jul-12', 'Aug-12', 'Sep-12', 'Oct-12', 'Nov-12', 'Dec-12', 'Jan-13', 'Feb-13', 'Mar-13']
  @silver = [2, 3, 2, 4, 8, 10, 6, 6, 7, 6]
  @meetup = [1, 3, 1, 1, 3, 6, 6, 12, 26, 28]
  @bronze = [4, 9, 11, 17, 20, 21, 26, 27, 21, 22]  
  erb :placeholder
end

get '/testlog' do
  oclient = OAuth2Client.new(settings)
  oclient.logger = logger
  logger.info("Inside /testlog. Set the logger in oclient.")
  oclient.test_log
end

get '/authdone' do
  oclient = OAuth2Client.new(settings)
  oclient.logger = logger
  if api_key = oclient.authenticate(params)
    session[:api_key] = api_key
    redirect to('/customers')
  else
    html = <<-HTML
      <html>
        <body>
          <h1>Welcome to Payboard!</h1>
          <p>User denied permission.</p>
        </body>
      </html>
    HTML
  end
  html
end

get '/customers' do
  Stripe.api_key = session[:api_key]
  cust_names = Stripe::Customer.all.map{|c| c.description}.join(',')
end

