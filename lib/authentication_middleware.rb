class AuthenticationMiddleware
  attr_reader :request

  def initialize(app)
    @app = app
  end

  def call(env)
    @request = env
    env["JWT_DATA"] = JWT.decode(jwt, rsa_public, true, { algorithm: 'RS256' })
    @app.call(env)
  rescue => e
    unauthorized(e.message)
  end

private

  def jwt
    request["HTTP_AUTHORIZATION"].gsub('Bearer ', '')
  end

  def rsa_public
    OpenSSL::PKey.read(Base64.urlsafe_decode64(ENV['RSA_PUBLIC']))
  end

  def unauthorized(message)
    [ 422, { 'Content-Type' => 'application/json' }, [ { message: message }.to_json ] ]
  end
end
