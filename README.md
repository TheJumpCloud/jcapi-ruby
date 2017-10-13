## JCAPI-Python

### Description ###

This repository contains the Ruby client code for the JumpCloud API v1 and v2.
It also provides the tools to generate the client code from the API yaml files, using swagger-codegen.
For detailed instructions on how to generate the code, see the [Contributing](CONTRIBUTING.md) section.

#### Installing the Ruby Client

Change to the appropriate directory (jcapiv1 or jcapiv2) and then run the following commands to build/install the Python Client API package:

To build the Ruby code into a gem:

```shell
gem build swagger_client.gemspec
```

Then either install the gem locally:
```shell
gem install --user-install ./swagger_client-1.0.0.gem
```

Or for all users:
```shell
$ sudo gem install ./swagger_client-1.0.0.gem
```

#### Usage Examples

For more detailed instructions, refer to each API's respective README file ([README for API v1](jcapiv1/README.md) and [README for API v2](jcapiv2/README.md)) and the generated docs under each folder.

API v1 example:
```ruby
#!/usr/bin/env ruby

# Load the gem
require 'swagger_client'

# Setup API key:
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = '<YOUR_JUMPCLOUD_API_KEY>'
end

# instantiate the Systemusers API object:
api_instance = SwaggerClient::SystemusersApi.new

content_type = 'application/json'
accept = 'application/json'


# Example 1: print all users:

opts = {
  limit: 100, # The number of records to return at once.
  sort: 'username' # sort by username
}

begin
  res = api_instance.systemusers_list(content_type, accept)
  puts res.total_count
  puts res.results
rescue SwaggerClient::ApiError => e
  puts 'Exception when calling SystemusersApi->systemusers_list: #{e}'
end


# Example 2: modify the lastname of a specific user:

# create a put request with the updated last name:
put_request = SwaggerClient::Systemuserputpost.new
put_request.lastname = 'updated last name'
# pass the request in the optional parameters:
opts = {
  body: put_request
}

begin
  res = api_instance.systemusers_put('<YOUR_USER_ID>', content_type, accept, opts)
  puts res
rescue SwaggerClient::ApiError => e
  puts 'Exception when calling SystemusersApi->systemusers_get: #{e}'
end

```


API v2 example:
```ruby
#!/usr/bin/env ruby

# Load the gem
require 'swagger_client'

# Setup API key:
SwaggerClient.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = '<YOUR_JUMPCLOUD_API_KEY>'
end

# instantiate the UserGroups API object:
api_instance = SwaggerClient::UserGroupsApi.new

content_type = 'application/json'
accept = 'application/json'

opts = {
  limit: 100, # The number of records to return at once.
  sort: 'name' # sort by group name
}

# print all user groups:
begin
  res = api_instance.groups_user_list(content_type, accept)
  puts res
rescue SwaggerClient::ApiError => e
  puts 'Exception when calling UserGroupsApi->groups_user_list: #{e}'
end
```
