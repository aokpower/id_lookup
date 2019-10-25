# ID Lookup
This app is basically a read only webapi that looks up corresponding the
corresponding ids of bigcommerce skus for your store, and some related rake
tasks that take care of managing your redis instance and getting the
product sku -> id information from BigCommerce's API

It was developed against ruby 2.6.5

run redis and puma and your good.
The expected environment variables (which can be put into a .env file) are:
- BC_STORE_HASH (found during api key creation, should be around 10 characters)
- BC_CLIENT_ID
- BC_ACCESS_TOKEN

there's only one uri: /check/<sku_to_check>
it just returns either the key value, or an empty page. just text.

Very KISS 

TODO:
- Don't assume only one redis-server process running, or that it's on localhost
- shell script that runs redis and puma
- better logging
- What if multiple products with same sku?
- sku that has variants?
- Loading skus from PartSmart
