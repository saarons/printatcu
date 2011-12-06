r = Redis.new
Resque.redis = r
Resque.redis.namespace = "printatcu:resque"
$redis = Redis::Namespace.new("printatcu", :redis => r)