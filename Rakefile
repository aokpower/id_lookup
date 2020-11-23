file 'dump.rdb.bak': %w[dump.rdb redis:connect] do |t|
  $redis.save
  bname = t.prerequisites[0]
  sh 'cp', bname, (bname + '.bak')
  puts "backed up redis to disk at #{t.name}"
end

namespace 'redis' do
  desc 'prereq task for connecting to redis database DON\'T USE'
  task :connect do |t|
    require 'redis'
    begin
      ENV['IDL_REDIS_HOST'].then do |redis_host|
        $redis = redis_host.nil? ? Redis.new : Redis.new(host: redis_host)
      end
      $redis.ping # throws if not connected to a running redis instance
      puts 'connected to redis'
    rescue StandardError => err
      abort("#{t.name} task failed with: #{err.full_message}")
    end
  end

  desc 'Backs up redis and deletes all keys'
  task clear: %w[redis:connect dump.rdb.bak] do |t|
    $redis.flushdb
    puts 'deleted all redis keys'
  end
end

# namespace 'bc' do
#   desc 'prereq task for connecting to bigcommerce. DON\'T USE'
#   task :connect do |t|
#     # make connection to bigcommerce
#     require 'bigcommerce'
#     require 'dotenv'
#     begin
#       Dotenv.load
#       %w[BC_STORE_HASH BC_CLIENT_ID BC_ACCESS_TOKEN].each do |var_name|
#         raise("missing environment var: #{var_name}") if ENV[var_name].nil?
#       end
#       Bigcommerce.configure do |c|
#         c.store_hash   = ENV['BC_STORE_HASH']
#         c.client_id    = ENV['BC_CLIENT_ID']
#         c.access_token = ENV['BC_ACCESS_TOKEN']
#       end
#       Bigcommerce::System.time # raises error if invalid connection
#     rescue StandardError => err
#       abort("#{t.name} task failed with: #{err.full_message}")
#     end
#     puts 'connected to bigcommerce'
#   end

#   desc <<~HEREDOC
#   Updates product -> id info in redis.
#   Doesn't delete first manually, see reset task.
#   HEREDOC
#   multitask load_products: %w[redis:connect bc:connect dump.rdb.bak] do |t|
    
#     puts('product count' + Bigcommerce::Product.count.to_s + '.')

#     loaded_products = 0
#     page_index = 1

#     while true
#       page = Bigcommerce::Product.all(page: page_index)
#       page_index += 1

#       break if page.empty?

#       page.each do |product|
#         sku, id = product.fetch_values(:sku, :id)
#         $redis.set(sku, id.to_s)
#         loaded_products += 1
#       end
#     end
#     puts "Added #{loaded_products.to_s} products to redis database."
#   end
# end

# desc 'clears redis database and reloads it with fresh product -> id information'
# task reset: %w[redis:clear bc:load_products]

task :default do
  puts <<~HEREDOC
  Because most of the operations of this Rakefile are destructive mutations of
  redis, there is no default task. Please be sure what you are doing before you
  run any of these. If something isn't working, try looking at the .env file.
  HEREDOC
end
