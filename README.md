## JCAPI-Ruby

### Description ###

This repository contains the Ruby client code for the JumpCloud API v1 and v2.
It also provides the tools to generate the client code from the API yaml files, using swagger-codegen.
For detailed instructions on how to generate the code, see the [Contributing](CONTRIBUTING.md) section.

### Installing the Ruby Client

#### Installing from github with Bundler

Add the following line(s) to your Gemfile:

`gem 'jcapiv1', :git => 'https://github.com/TheJumpCloud/jcapi-ruby.git'`  for the jcapiv1 gem

`gem 'jcapiv2', :git => 'https://github.com/TheJumpCloud/jcapi-ruby.git'`  for the jcapiv2 gem

And run: `bundle install`

#### Manual install

Change to the appropriate directory (jcapiv1 or jcapiv2) and then run the following
commands to build/install the Ruby Client API package:

To build the Ruby code into a gem:
```shell
gem build jcapiv1.gemspec
```
Then either install the gem locally:
```shell
gem install --user-install ./jcapiv1-1.0.0.gem
```
Or for all users:
```shell
$ sudo gem install ./jcapiv1-1.0.0.gem
```

### Authentication and Authorization

All endpoints support authentication via API key: see the [Authentication and Authorization](https://docs.jumpcloud.com/2.0/authentication-and-authorization/authentication-and-authorization-overview)
section in our API docs.

Some Systems endpoints (in both API v1 and v2) also support the [System Context authorization](https://docs.jumpcloud.com/2.0/authentication-and-authorization/system-context)
which allows an individual system to manage its information and resource associations.


### Usage Examples

For more detailed instructions, refer to each API's respective README file
([README for API v1](jcapiv1/README.md) and [README for API v2](jcapiv2/README.md))
and the generated docs under each folder.

#### API v1 example:
```ruby
#!/usr/bin/env ruby

# Load the gem
require 'jcapiv1'

# Setup API key:
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = '<YOUR_JUMPCLOUD_API_KEY>'
end

# instantiate the Systemusers API object:
api_instance = JCAPIv1::SystemusersApi.new

content_type = 'application/json'
accept = 'application/json'


# Example 1: print all users:

opts = {
  limit: 100, # The number of records to return at once.
  sort: 'username' # sort by username
}

begin
  res = api_instance.systemusers_list(content_type, accept, opts)
  puts res.total_count
  puts res.results
rescue JCAPIv1::ApiError => e
  puts 'Exception when calling SystemusersApi->systemusers_list: #{e}'
end


# Example 2: modify the lastname of a specific user:

# create a put request with the updated last name:
put_request = JCAPIv1::Systemuserputpost.new
put_request.lastname = 'updated last name'
# pass the request in the optional parameters:
opts = {
  body: put_request
}

begin
  res = api_instance.systemusers_put('<YOUR_USER_ID>', content_type, accept, opts)
  puts res
rescue JCAPIv1::ApiError => e
  puts 'Exception when calling SystemusersApi->systemusers_get: #{e}'
end

```


#### API v2 example:
```ruby
#!/usr/bin/env ruby

# Load the gem
require 'jcapiv2'

# Setup API key:
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = '<YOUR_JUMPCLOUD_API_KEY>'
end

# instantiate the UserGroups API object:
api_instance = JCAPIv2::UserGroupsApi.new

content_type = 'application/json'
accept = 'application/json'

# print all user groups:
begin
  res = api_instance.groups_user_list(content_type, accept)
  puts res
rescue JCAPIv2::ApiError => e
  puts 'Exception when calling UserGroupsApi->groups_user_list: #{e}'
end
```


#### System Context API example:
```ruby
#!/usr/bin/env ruby

# Load the gem
require 'jcapiv2'

# instantiate the Systems API object:
api_instance = JCAPIv2::SystemsApi.new

content_type = 'application/json'
accept = 'application/json'
system_id = '<YOUR_SYSTEM_ID>'
# set headers for the System Context Authorization:
# for detailed instructions on how to generate these headers,
# refer to: https://docs.jumpcloud.com/2.0/authentication-and-authorization/system-context
opts = {
  authorization: 'Signature keyId="system/<YOUR_SYSTEM_ID>",headers="request-line date",algorithm="rsa-sha256",signature="<YOUR_SYSTEM_SIGNATURE>"',
  date: 'Thu, 19 Oct 2017 17:27:57 GMT' # the current date on the system
}

begin
  # list the system groups this system is a member of:
  res = api_instance.graph_system_member_of(system_id, content_type, accept, opts)
  puts res
rescue JCAPIv2::ApiError => e
  puts 'Exception when calling systemsAPI->graph_system_member_of: #{e}'
end
```
