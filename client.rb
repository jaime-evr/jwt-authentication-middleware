require 'rest-client'
require 'jwt'
require 'pry'

class Client
  def self.send_request
    rsa_private = OpenSSL::PKey.read(Base64.urlsafe_decode64(ENV['RSA_PRIVATE']))
    payload = { name: 'Jaime' }
    jwt = JWT.encode payload, rsa_private, 'RS256'
    response = RestClient.post "localhost:9292", { 'jwt' => jwt }.to_json, { content_type: :json, accept: :json }
    puts JSON.parse(response.body).inspect
  end
end

Client.send_request
