require 'roda'
require 'redis'

$redis = Redis.new(host: 'localhost')

class App < Roda
  route do |r|
    r.get 'check', String do |sku|
      $redis.get(sku)
    end
  end
end

run App.freeze.app
