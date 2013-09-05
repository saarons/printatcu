class Filepicker
  attr_reader :api_key

  def initialize(api_key, secret)
    @api_key = api_key
    @secret = secret
  end

  def policy(call, options = {})
    policy = {expiry: Time.now.to_i + (60*60*24), call: call}
    policy.merge!(options)
    Base64.urlsafe_encode64(JSON.dumps(policy))
  end

  def sign(policy)
    OpenSSL::HMAC.hexdigest("SHA256", @secret, policy)
  end
end

$filepicker = Filepicker.new("Ac88GjthXQdqNsr9JvJJHz", ENV["FILEPICKER_SECRET"])