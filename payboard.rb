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
end

get '/' do
  logger.info("Inside root. rack.logger = #{ENV['rack.logger']}. logger.class = #{logger.class}")
  authorize_url = OAuth2Client.new(settings).authorize_url
  session[:api_key] = settings.my_api_key
  html = <<-HTML
    <html>
      <body>
        <h1>Welcome to Payboard!</h1>
        <a href="#{authorize_url}">
          Connect to Stripe
        </a><br/>
        <a href="/customers">
          Get customers
        </a>
      </body>
    </html>
  HTML
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

