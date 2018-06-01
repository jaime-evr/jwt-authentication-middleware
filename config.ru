require 'jwt'
require 'pry'
require 'json'
require 'thin'
require_relative 'lib/authentication_middleware'

app = -> (env) do
  binding.pry
  [ 200, { 'Content-Type' => 'application/json' }, [ env["JWT_DATA"].to_json ] ]
end

use AuthenticationMiddleware
run app
