require 'rest-client'
require 'jwt'
require 'pry'

class Client
  attr_reader :payload

  def initialize(payload = {})
    @payload = payload
  end

  def send_request
    response = RestClient.post "localhost:9292", nil, { content_type: :json, accept: :json, Authorization: "Bearer #{jwt}" }
    puts JSON.parse(response.body).inspect
  end

  private

  def jwt
    JWT.encode(payload, rsa_private, 'RS256')
  end

  def rsa_private
    OpenSSL::PKey.read(Base64.urlsafe_decode64(ENV['RSA_PRIVATE']))
  end
end

Client.new(age: '27').send_request
