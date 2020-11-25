# Helper for shopify:load. Don't want to do this as a proc for perf reasons
def load_variants(shopify_products, redis)
  shopify_products.map(&:variants).flatten.each do |variant|
    sku = variant.sku.to_s
    id  = variant.id.to_s

    redis.set(sku, id)
  end
end

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

namespace 'shopify' do
   desc 'prereq task for connecting to shopify. Don\'t use this on command line'
   task :connect do |t|
     require 'dotenv'
     Dotenv.load
     ["SHOPIFY_API_VERSION",
      "SHOPIFY_API_KEY",
      "SHOPIFY_PASSWORD",
      "SHOPIFY_STORE_NAME"].each do |var_name|
       raise("Missing environment var is required: #{var_name}") if ENV[var_name].nil?
     end

     require 'shopify_api'
     shop_url = "https://#{ENV['SHOPIFY_API_KEY']}:#{ENV['SHOPIFY_PASSWORD']}@#{ENV['SHOPIFY_STORE_NAME']}.myshopify.com"
     ShopifyAPI::Base.site        = shop_url
     ShopifyAPI::Base.api_version = ENV['SHOPIFY_API_VERSION']
   end

   desc 'load sku -> id product information into redis'
   multitask load: %w[redis:connect shopify:connect dump.rdb.bak] do |t|
     begin
       puts "Loading product info into redis..."
       count = 0

       products = ShopifyAPI::Product.find(:all, params: { limit: 50 })
       count += products.count
       load_variants(products, $redis)

       while products.next_page?
         products.fetch_next_page
         count += products.count
         load_variants(products, $redis)
       end

       puts "Successfully loaded #{count} products"
    rescue StandardError => err
      abort("#{t.name} task failed with: #{err.full_message}")
    end
   end
end

task :default do
  puts <<~HEREDOC
  Because most of the operations of this Rakefile are destructive mutations of
  redis, there is no default task. Please be sure what you are doing before you
  run any of these. If something isn't working, try looking at the .env file.
  HEREDOC
end
