We will create a middleware that intercepts and blocks any host which tries to overload our servers by firing too many requests within a short timespan. We will be using Redis to store the count of requests from each IP address.

step- 1

To initialize redis in your app, add the following file inside the config/initializers:

# config/initializers/redis.rb
require 'redis'

REDIS = Redis.new(url: ENV.fetch('REDIS_URL'))

The Redis#set method will set the record in the redis store. We will pass it the following arguments:

key - a unique identifier, which in this case will be the user's IP address
value - sets the value against the given key
ex - sets the expiry time in seconds
nx - sets the key only if it doesn't already exist

On every request, we increment the count using Redis#incr. If the count exceeds the predefined limit, we return false.



step-2
Let's start by writing the most basic middlewareli
lib/custom_rate_limit.rb



step-3
Add the following line inside your application.rb:

# For Rails version > 5
config.middleware.use CustomRateLimit

Run the bin/rails middleware command and verify that our custom middleware is present in the middleware stack.
In case you run into an error saying uninitialized constant ::CustomRateLimit, add the below line at the top of your application.rb:

require_relative '../lib/middlewares/custom_rate_limit'








