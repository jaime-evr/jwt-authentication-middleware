require 'jwt'
require 'pry'
require 'json'
require 'thin'

require_relative 'lib/jwt_authentication'

app = -> (env) do
  request = Rack::Request.new(env)
  auth = Authentication.new(request)
  [ auth.status, auth.headers, [ auth.body ] ]
end

run app
