r = Redis.new
Resque.redis = r
Resque.redis.namespace = "printatcu:resque"
Resque.inline = Rails.env.development?
$redis = Redis::Namespace.new("printatcu", :redis => r)