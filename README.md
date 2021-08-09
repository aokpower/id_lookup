# ID Lookup
Load sku -> shopify id info into redis and run a webserver exposing that info through /check/<sku>, where it returns empty for key not found and a string with a shopify id if it exists. Intended to be used with the shopify-partsmart client side integration.

## Setup
requires the ruby version specified in `.ruby-version`, currently `2.7.4`

just use `bundle install`, and everything except redis should be ready.

Make sure your redis process is running somewhere (I've just been using a tmux session) with `redis-server` and you can run the api with the `puma` command.

## Secrets, config vars
The expected environment variables (which can be put into a .env file) are:
- SHOPIFY_API_KEY
- SHOPIFY_PASSWORD
- SHOPIFY_STORE_NAME
- IDL_REDIS_HOST [OPTIONAL] (Redis.new host: <this value here>)

there's only one uri: /check/<sku_to_check>
it just returns either the key value, or an empty page. just text.

## Deployment
```bash
redis-server &
puma
```

There's a docker-compose setup I had working at some point but not sure if it's working now

## Commands / rake tasks
The redis database is managed primarily through 2 commands, `redis:clear` and `shopify:load`.

`redis:clear` makes a database backup to 'dump.rdb.bak' and then clears all keys.

`shopify:load` connects to shopify and populates the database with sku -> shopify id values for all products.

## Development
The 2 main files are `Rakefile` and `config.ru`.

`Rakefile` defines the commands for managing redis and loading shopify info into redis.

`config.ru` defines the api and logs to logs/id_lookup.log.
