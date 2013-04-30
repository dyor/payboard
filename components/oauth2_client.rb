require 'rest-client'
require 'json'

class OAuth2Client

  attr_reader :authorize_url
  #attr_writer :logger

  def initialize(settings)    
    @state = settings.state
    @client_id = settings.client_id
    @my_api_key = settings.my_api_key
    #@authorize_url = "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{@client_id}&scope=read_only&state=#{@state}"
    @authorize_url = "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{@client_id}&scope=read_only&stripe_landing=login"
    @access_token_url = 'https://connect.stripe.com/oauth/token'
  end

  def logger=(logr)    
    @logger = logr
  end

  def authenticate(params)
    #raise 'We seem to be a victim of CSRF' unless params[:state] == @state
    if @auth_grant = params[:code]
      get_access_token
    elsif params[:error]
      false
    end
  end

  def get_access_token
    response_json = RestClient.post(@access_token_url, :client_secret => @my_api_key, :code => @auth_grant, :grant_type => 'authorization_code')
    @logger.info(response_json.inspect)
    response = JSON.parse(response_json)
    @logger.info(response.inspect)
    response['access_token'].strip
  end
end