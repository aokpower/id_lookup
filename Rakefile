# TODO: add catch blocks with aborts to connect tasks

file 'dump.rdb.bak': 'dump.rdb' do |t|
  bname = t.prerequisites[0]
  sh 'cp', bname, (bname + '.bak')
end

namespace 'redis' do
  desc 'prereq task for connecting to redis database DON\'T USE'
  task :connect do
    require 'redis'
    begin
      $redis = Redis.new(host: 'localhost')
      $redis.ping
      puts 'connected to redis'
    rescue StandardError => msg
      puts 'redis:connect task failed with: '
      puts msg
    end
  end

  desc 'Backs up redis and deletes all keys'
  task clear: %w[redis:connect dump.rdb.bak] do
    puts "clear_redis"
  end
end

namespace 'bigcommerce' do
  desc 'prereq task for connecting to bigcommerce. DON\'T USE'
  task :connect do
    # make connection to bigcommerce
    require 'bigcommerce'
    require 'dotenv'
    Bigcommerce.configure do |c| # TODO:
      c.store_hash   = ENV['BIGCOMMERCE_STORE_HASH']
      c.client_id    = ENV['BIGCOMMERCE_CLIENT_ID']
      c.access_token = ENV['BIGCOMMERCE_ACCESS_TOKEN']
    end
    begin
      rescue StandardError => msg
      puts 'bigcommerce:connect failed with:'
      puts msg
    end
    puts 'connect_bc'
  end

  # TODO: Should only clear redis IF getting products goes well
  desc <<~HEREDOC
  Updates product -> id info in redis.
  Doesn't delete first manually, see reset task.
  HEREDOC
  multitask load_products: %w[redis:connect bigcommerce:connect] do
    puts 'bigcommerce:load_products WIP'
  end
end

desc 'clears redis database and reloads it with fresh product -> id information'
task reset: %w[redis:clear bigcommerce:load_products]

task :default do
  puts <<~HEREDOC
  Because most of the operations of this Rakefile are destructive mutations of
  redis, there is no default task. Please be sure what you are doing before you
  run any of these. If something isn't working, try looking at the .env file.
  HEREDOC
end
