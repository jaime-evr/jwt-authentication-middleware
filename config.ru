require 'jwt'
require 'pry'
require 'json'
require 'thin'

app = -> (env) do
  request = Rack::Request.new(env)
  auth = Authentication.new(request)
  [ auth.status, auth.headers, [ auth.body ] ]
end

class Authentication
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def status
    200
  end

  def headers
    { 'Content-Type' => 'application/json', 'Content-Length' => body.size.to_s }
  end

  def body
    decoded_jwt.to_json
  end

private

  def rsa_public
    OpenSSL::PKey.read(Base64.urlsafe_decode64(ENV['RSA_PUBLIC']))
  end

  def jwt
    params["jwt"]
  end

  def decoded_jwt
    @decoded_jwt = JWT.decode(jwt, rsa_public, true, { algorithm: 'RS256' })
  end

  def params
    @params ||= JSON.parse(request.body.read)
  end
end

run app
