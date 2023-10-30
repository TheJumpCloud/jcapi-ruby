## JCAPI-Ruby

# Status: Archived
This repository has been archived and is no longer maintained. JumpCloud API documentation can be found [here](https://docs.jumpcloud.com/api/index.html). 

![status: inactive](https://img.shields.io/badge/status-inactive-red.svg)

### Description

This repository contains the Ruby client code for the JumpCloud API v1 and
v2. It also provides the tools to generate the client code from the API YAML
files, using Swagger Codegen. For detailed instructions on how to generate the
code, see the [Contributing](CONTRIBUTING.md) section.

### Installing the Ruby Client

#### Installing from GitHub with Bundler

Add the following line(s) to your Gemfile:

`gem 'jcapiv1', :git => 'https://github.com/TheJumpCloud/jcapi-ruby.git'` for the jcapiv1 gem.

`gem 'jcapiv2', :git => 'https://github.com/TheJumpCloud/jcapi-ruby.git'` for the jcapiv2 gem.

And run: `bundle install`.

#### Manual Install

Change to the appropriate directory (jcapiv1 or jcapiv2) and then run the following
commands to build/install the Ruby client API package:

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
sudo gem install ./jcapiv1-1.0.0.gem
```

### Authentication and Authorization

All endpoints support authentication via API key: see the
[Authentication & Authorization](https://docs.jumpcloud.com/2.0/authentication-and-authorization/authentication-and-authorization-overview)
section in our API documentation.

Some systems endpoints (in both API v1 and v2) also support
[System Context Authorization](https://docs.jumpcloud.com/2.0/authentication-and-authorization/system-context)
which allows an individual system to manage its information and resource
associations.

### Usage Examples

For more detailed instructions, refer to each API version's respective README
file ([README for API v1](jcapiv1/README.md) and
[README for API v2](jcapiv2/README.md)) and the generated documentation under
each folder.

#### API v1 Example

```ruby
#!/usr/bin/env ruby

require 'jcapiv1'

api_key = 'YOUR_API_KEY'
system_user_id = 'YOUR_SYSTEM_USER_ID'

content_type = 'application/json'
accept = 'application/json'

# Set up the configuration object with your API key for authorization.
JCAPIv1.configure do |config|
  config.api_key['x-api-key'] = api_key
end

# Instantiate the API object for the group of endpoints you need to use,
# for instance the system users API.
system_users_api = JCAPIv1::SystemusersApi.new

# Example 1: Make an API call to retrieve system users.

opts = {
  limit: 100, # The number of records to return at once.
  sort: 'username'
}

begin
  response = system_users_api.systemusers_list(content_type, accept, opts)
  puts response
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_list: #{e}"
end

# Example 2: Make an API call to update a system user.

put_request = JCAPIv1::Systemuserput.new
put_request.lastname = 'Updated Last Name'
opts = { body: put_request }

begin
  response = system_users_api.systemusers_put(
    system_user_id, content_type, accept, opts
  )
  puts response
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_put: #{e}"
end

```


#### API v2 Example

```ruby
#!/usr/bin/env ruby

require 'jcapiv2'

api_key = 'YOUR_API_KEY'

content_type = 'application/json'
accept = 'application/json'

# Set up the configuration object with your API key for authorization
JCAPIv2.configure do |config|
  config.api_key['x-api-key'] = api_key
end

# Instantiate the API object for the group of endpoints you need to use,
# for instance the user groups API.
user_groups_api = JCAPIv2::UserGroupsApi.new

# Make an API call to retrieve user groups.

begin
  response = user_groups_api.groups_user_list(content_type, accept)
  puts response
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->groups_user_list: #{e}"
end

```


#### System Context Authorization Example

```ruby
#!/usr/bin/env ruby

require 'jcapiv2'

# Set headers for System Context Authorization. For detailed instructions on
# how to generate these headers, refer to:
# https://docs.jumpcloud.com/2.0/authentication-and-authorization/system-context
system_id = 'YOUR_SYSTEM_ID'
# The current date on the system, e.g. 'Fri, 16 Jan 1998 12:13:05 GMT'
system_date = 'YOUR_SYSTEM_DATE'
system_signature = 'YOUR_SYSTEM_SIGNATURE'
system_context_auth = \
  "Signature keyId=\"system/#{system_id}\","\
  'headers="request-line date",'\
  'algorithm="rsa-sha256",'\
  "signature=\"#{system_signature}\""

content_type = 'application/json'
accept = 'application/json'

# Instantiate the API object for the group of endpoints you need to use,
# for instance the user groups API.
systems_api = JCAPIv2::SystemsApi.new

# Make an API call to retrieve all system groups this system is a member of.

opts = { authorization: system_context_auth, date: system_date }

begin
  response = systems_api.graph_system_member_of(
    system_id, content_type, accept, opts
  )
  puts response
rescue JCAPIv2::ApiError => e
  puts "Exception when calling systemsAPI->graph_system_member_of: #{e}"
end

```
