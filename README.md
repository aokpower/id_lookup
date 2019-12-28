# ID Lookup
This app is a read only webapi that looks up corresponding the corresponding ids
of bigcommerce skus for your store, and some related rake tasks that take care
of managing your redis instance and getting the product sku -> id information
from BigCommerce's API

It is developed using ruby 2.6.5

run redis and puma and your good.
The expected environment variables (which can be put into a .env file) are:
- BC_STORE_HASH (found during api key creation, should be around 10 characters)
- BC_CLIENT_ID
- BC_ACCESS_TOKEN
- IDL_REDIS_HOST [OPTIONAL] (Redis.new host: <this value here>)

there's only one uri: /check/<sku_to_check>
it just returns either the key value, or an empty page. just text.

## Deployment
open 2 tmux tabs, run ```puma``` in one and ```redis-server``` in the other.

## TODO:
- [x] better logging
- [x] Handle errors
- [ ] What if multiple products with same sku?
- [ ] sku that has variants?
- [ ] Better deployment section in README
