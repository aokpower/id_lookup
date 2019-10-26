require 'roda'
require 'redis'
require 'logger'

$logger = Logger.new(STDOUT)
# $logger.level = Logger::INFO

ENV['IDL_REDIS_HOST'].then do |redis_host|
  $redis = redis_host.nil? ? Redis.new : Redis.new(host: redis_host)
end

begin
  $redis.ping
  rescue StandardErr => err
    abort("Failed to connect to redis; #{err.full_message}")
end

class App < Roda
  route do |r|
    r.get 'check', String do |sku|
      begin
        $redis.get(sku)
      rescue => err
        $logger.error('Caught redis error:')
        $logger.error(err)
      end
    end
  end
end

run App.freeze.app
