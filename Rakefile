file 'dump.rdb.bak': 'dump.rdb' do |t|
  bname = t.prerequisites[0]
  sh 'cp', bname, (bname + '.bak')
end

namespace 'redis' do
  desc 'prereq task for connecting to redis database DON\'T USE'
  task :connect do |t|
    require 'redis'
    begin
      $redis = Redis.new(host: 'localhost')
      $redis.ping
      puts 'connected to redis'
    rescue StandardError => err
      abort("#{t.name} task failed with: #{err.full_message}")
    end
  end

  desc 'Backs up redis and deletes all keys'
  task clear: %w[redis:connect dump.rdb.bak] do |t|
    $redis.keys.each { |key| $redis.del(key) }
    puts 'deleted all redis keys'
  end
end

namespace 'bc' do
  desc 'prereq task for connecting to bigcommerce. DON\'T USE'
  task :connect do |t|
    # make connection to bigcommerce
    require 'bigcommerce'
    require 'dotenv'
    begin
      Bigcommerce.configure do |c|
        c.store_hash   = ENV['BIGCOMMERCE_STORE_HASH']
        c.client_id    = ENV['BIGCOMMERCE_CLIENT_ID']
        c.access_token = ENV['BIGCOMMERCE_ACCESS_TOKEN']
      end
      Bigcommerce::System.time # ping BigCommerce system to check connection
      # TODO: Check api gem source to try to make sense of following error:
      # Doesn't work, fails with 404 (?!)
    rescue StandardError => err
      abort("#{t.name} task failed with: #{err.full_message}")
    end
    puts 'connected to bigcommerce'
  end

  # TODO: Should only clear redis IF getting products goes well
  desc <<~HEREDOC
  Updates product -> id info in redis.
  Doesn't delete first manually, see reset task.
  HEREDOC
  multitask load_products: %w[redis:connect bc:connect] do
    products = Bigcommerce::Product.all
    puts products.size
    # maps = zip products.map(&:id), products.map(&:sku)
    # maps.each { |(id, sku)| $redis.set(id, sku) }
    # puts t.name + ' done.'
  end
end

desc 'clears redis database and reloads it with fresh product -> id information'
task reset: %w[redis:clear bc:load_products]

task :default do
  puts <<~HEREDOC
  Because most of the operations of this Rakefile are destructive mutations of
  redis, there is no default task. Please be sure what you are doing before you
  run any of these. If something isn't working, try looking at the .env file.
  HEREDOC
end
