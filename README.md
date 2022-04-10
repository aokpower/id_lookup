# ID Lookup
Load sku -> shopify id info into redis and run a webserver exposing that info through /check/<sku>, where it returns empty for key not found and a string with a shopify id if it exists. Intended to be used with the shopify-partsmart client side integration.

## Setup
requires the ruby version specified in `.ruby-version`, currently `2.7.4`

just use `bundle install`, and everything except redis should be ready.

### Redis & Puma

*Redis is automatically started (and restarted) by systemd* in the background, see /etc/systemd/system/redis.service

to check the status of the redis service use `sudo systemctl list-units | grep redis`

Currently run through a NGINX 'sites-enabled' configuration, see `/etc/nginx/sites-enabled`
SSL is automatically handled through lets-encrypt and cert-bot, see `id_lookup.conf`

To start the server, run `puma & disown`, which starts the puma server and puts it in a background process.
To stop the server, you'll have to find the process id through `ps aux | grep -v grep | grep -i puma`, and it should be the second number.
Something like `21356`, and once you have that number you can run `kill`, for example: `kill 21356`

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
