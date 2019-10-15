desc 'prereq task for connecting to redis database DON\'T USE'
task :connect_redis do
  # make connection to redis
  require 'redis'
  $redis = Redis.new(host: 'localhost')
  puts 'connected to redis'
end

desc 'prereq task for connecting to bigcommerce. DON\'T USE'
task :connect_bc do
  # make connection to bigcommerce
  require 'bigcommerce'
  require 'dotenv'
  Bigcommerce.configure do |c| # TODO:
    c.store_hash   = ENV[''] # ???
    c.client_id    = ENV['BIGCOMMERCE_CLIENT_ID']
    c.access_token = ENV['BIGCOMMERCE_ACCESS_TOKEN']
  end
  puts 'connect_bc'
end

desc 'Clears redis database.'
task clear_redis: %w[connect_redis] do
  puts "clear_redis"
end

desc <<~HEREDOC
  Updates product -> id info in redis.
  Doesn't delete first manually, see reset task.
HEREDOC
multitask load_products: %w[connect_redis, connect_bc] do
  puts "load_products"
end

desc 'clears redis database and reloads it with fresh product -> id information'
task reset: %w[clear_redis load_products]

task :default do
  puts <<~HEREDOC
  Because most of the operations of this Rakefile are destructive mutations of
  redis, there is no default task. Please be sure what you are doing before you
  run any of these. If something isn't working, try looking at the .env file.
  HEREDOC
end
