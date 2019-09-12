require 'roda'
require 'redis'
require 'logger'

$logger = Logger.new(STDOUT)
# $logger.level = Logger::INFO

$redis = Redis.new(host: 'localhost')

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
