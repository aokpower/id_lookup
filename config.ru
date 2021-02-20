require 'roda'
require 'redis'
require 'logger'

LOG_FILE_LIMIT = 5
LOG_BYTE_LIMIT = 1_024_000
$logger = Logger.new('logs/id_lookup.log', LOG_FILE_LIMIT, LOG_BYTE_LIMIT)

ENV['IDL_REDIS_HOST'].then do |redis_host|
  $redis = redis_host.nil? ? Redis.new : Redis.new(host: redis_host)
end

begin
  $redis.ping
rescue StandardError => e
  $logger.fatal('Failed to connect to redis')
  abort("Failed to connect to redis; #{e.full_message}")
end

class App < Roda
  plugin :route_csrf

  plugin :error_handler
  error do |err|
    err.message
  end

  route do |r|
    r.get 'check', String do |sku|
      # Redis#get can return nil which is an error return val for roda
      # but not having a record is a valid state, not an error state.
      # so: #to_s
      $redis.get(sku).to_s
    rescue => e
      $logger.error('Caught redis error:')
      $logger.error(e)
      raise err
    end
  end
end

run App.freeze.app
