# jcapiv1

JCAPIv1 - the Ruby gem for the JumpCloud API

# Overview  JumpCloud's V1 API. This set of endpoints allows JumpCloud customers to manage commands, systems, and system users.  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/systemusers\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

This SDK is automatically generated by the [Swagger Codegen](https://github.com/swagger-api/swagger-codegen) project:

- API version: 1.0
- Package version: 5.0.0
- Build package: io.swagger.codegen.v3.generators.ruby.RubyClientCodegen
For more information, please visit [https://support.jumpcloud.com/support/s/](https://support.jumpcloud.com/support/s/)

## Installation

### Build a gem

To build the Ruby code into a gem:

```shell
gem build jcapiv1.gemspec
```

Then either install the gem locally:

```shell
gem install ./jcapiv1-5.0.0.gem
```
(for development, run `gem install --dev ./jcapiv1-5.0.0.gem` to install the development dependencies)

or publish the gem to a gem hosting service, e.g. [RubyGems](https://rubygems.org/).

Finally add this to the Gemfile:

    gem 'jcapiv1', '~> 5.0.0'

### Install from Git

If the Ruby gem is hosted at a git repository: https://github.com/GIT_USER_ID/GIT_REPO_ID, then add the following in the Gemfile:

    gem 'jcapiv1', :git => 'https://github.com/GIT_USER_ID/GIT_REPO_ID.git'

### Include the Ruby code directly

Include the Ruby code directly using `-I` as follows:

```shell
ruby -Ilib script.rb
```

## Getting Started

Please follow the [installation](#installation) procedure and then run the following code:
```ruby
# Load the gem
require 'jcapiv1'
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ApplicationTemplatesApi.new
id = 'id_example' # String | 
opts = { 
  fields: 'fields_example', # String | The space separated fields included in the returned records. If omitted the default list of fields will be returned.
  limit: 56, # Integer | The number of records to return at once.
  skip: 56, # Integer | The offset into the records to return.
  sort: 'sort_example', # String | The space separated fields used to sort the collection. Default sort is ascending, prefix with - to sort descending.
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Get an Application Template
  result = api_instance.application_templates_get(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ApplicationTemplatesApi->application_templates_get: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ApplicationTemplatesApi.new
opts = { 
  fields: 'fields_example', # String | The space separated fields included in the returned records. If omitted the default list of fields will be returned.
  limit: 56, # Integer | The number of records to return at once.
  skip: 56, # Integer | The offset into the records to return.
  sort: 'sort_example', # String | The space separated fields used to sort the collection. Default sort is ascending, prefix with - to sort descending.
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #List Application Templates
  result = api_instance.application_templates_list(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ApplicationTemplatesApi->application_templates_list: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ApplicationsApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Delete an Application
  result = api_instance.applications_delete(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ApplicationsApi->applications_delete: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ApplicationsApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Get an Application
  result = api_instance.applications_get(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ApplicationsApi->applications_get: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ApplicationsApi.new
opts = { 
  fields: 'fields_example', # String | The space separated fields included in the returned records. If omitted the default list of fields will be returned.
  limit: 56, # Integer | The number of records to return at once.
  skip: 56, # Integer | The offset into the records to return.
  sort: 'name', # String | The space separated fields used to sort the collection. Default sort is ascending, prefix with - to sort descending.
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Applications
  result = api_instance.applications_list(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ApplicationsApi->applications_list: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ApplicationsApi.new
opts = { 
  body: JCAPIv1::Application.new, # Application | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Create an Application
  result = api_instance.applications_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ApplicationsApi->applications_post: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ApplicationsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::Application.new, # Application | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Update an Application
  result = api_instance.applications_put(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ApplicationsApi->applications_put: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandResultsApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Delete a Command result
  result = api_instance.command_results_delete(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandResultsApi->command_results_delete: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandResultsApi.new
id = 'id_example' # String | 
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #List an individual Command result
  result = api_instance.command_results_get(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandResultsApi->command_results_get: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandResultsApi.new
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | 
  skip: 0, # Integer | The offset into the records to return.
  sort: 'sort_example' # String | Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with `-` to sort descending. 
}

begin
  #List all Command Results
  result = api_instance.command_results_list(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandResultsApi->command_results_list: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandTriggersApi.new
triggername = 'triggername_example' # String | 
opts = { 
  body: nil, # Object | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Launch a command via a Trigger
  result = api_instance.command_trigger_webhook_post(triggername, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandTriggersApi->command_trigger_webhook_post: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandsApi.new
id = 'id_example' # String | 
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | 
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Get a Command File
  result = api_instance.command_file_get(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandsApi->command_file_get: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandsApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Delete a Command
  result = api_instance.commands_delete(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandsApi->commands_delete: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandsApi.new
id = 'id_example' # String | 
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #List an individual Command
  result = api_instance.commands_get(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandsApi->commands_get: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandsApi.new
id = 'id_example' # String | 


begin
  #Get results for a specific command
  result = api_instance.commands_get_results(id)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandsApi->commands_get_results: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandsApi.new
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | 
  skip: 0, # Integer | The offset into the records to return.
  sort: 'sort_example' # String | Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with `-` to sort descending. 
}

begin
  #List All Commands
  result = api_instance.commands_list(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandsApi->commands_list: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandsApi.new
opts = { 
  body: JCAPIv1::Command.new, # Command | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Create A Command
  result = api_instance.commands_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandsApi->commands_post: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::CommandsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::Command.new, # Command | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Update a Command
  result = api_instance.commands_put(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling CommandsApi->commands_put: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ManagedServiceProviderApi.new
id = 'id_example' # String | 


begin
  #Administrator TOTP Reset Initiation
  api_instance.admin_totpreset_begin(id)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->admin_totpreset_begin: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ManagedServiceProviderApi.new
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  search: 'search_example', # String | A nested object containing a `searchTerm` string or array of strings and a list of `fields` to search on.
  skip: 0, # Integer | The offset into the records to return.
  sort: 'sort_example' # String | Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with `-` to sort descending. 
}

begin
  #Get Organization Details
  result = api_instance.organization_list(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->organization_list: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ManagedServiceProviderApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::Userput.new, # Userput | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Update a user
  result = api_instance.users_put(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->users_put: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::ManagedServiceProviderApi.new
id = 'id_example' # String | 


begin
  #Administrator Password Reset Initiation
  api_instance.users_reactivate_get(id)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->users_reactivate_get: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::OrganizationsApi.new
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  search: 'search_example', # String | A nested object containing a `searchTerm` string or array of strings and a list of `fields` to search on.
  skip: 0, # Integer | The offset into the records to return.
  sort: 'sort_example' # String | Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with `-` to sort descending. 
}

begin
  #Get Organization Details
  result = api_instance.organization_list(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling OrganizationsApi->organization_list: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::OrganizationsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::OrganizationsIdBody.new # OrganizationsIdBody | 
}

begin
  #Update an Organization
  result = api_instance.organization_put(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling OrganizationsApi->organization_put: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::OrganizationsApi.new
id = 'id_example' # String | 
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example' # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
}

begin
  #Get an Organization
  result = api_instance.organizations_get(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling OrganizationsApi->organizations_get: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::RadiusServersApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Delete Radius Server
  result = api_instance.radius_servers_delete(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling RadiusServersApi->radius_servers_delete: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::RadiusServersApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Get Radius Server
  result = api_instance.radius_servers_get(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling RadiusServersApi->radius_servers_get: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::RadiusServersApi.new
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: 'sort_example', # String | Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #List Radius Servers
  result = api_instance.radius_servers_list(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling RadiusServersApi->radius_servers_list: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::RadiusServersApi.new
opts = { 
  body: JCAPIv1::Radiusserverpost.new, # Radiusserverpost | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Create a Radius Server
  result = api_instance.radius_servers_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling RadiusServersApi->radius_servers_post: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::RadiusServersApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::RadiusserversIdBody.new, # RadiusserversIdBody | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Update Radius Servers
  result = api_instance.radius_servers_put(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling RadiusServersApi->radius_servers_put: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SearchApi.new
opts = { 
  body: JCAPIv1::Search.new, # Search | 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Search Commands Results
  result = api_instance.search_commandresults_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SearchApi->search_commandresults_post: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SearchApi.new
opts = { 
  body: JCAPIv1::Search.new, # Search | 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Search Commands
  result = api_instance.search_commands_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SearchApi->search_commands_post: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SearchApi.new
opts = { 
  body: JCAPIv1::Search.new, # Search | 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Search Organizations
  result = api_instance.search_organizations_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SearchApi->search_organizations_post: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SearchApi.new
opts = { 
  body: JCAPIv1::Search.new, # Search | 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | 
  skip: 0, # Integer | The offset into the records to return.
  filter: 'filter_example' # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
}

begin
  #Search Systems
  result = api_instance.search_systems_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SearchApi->search_systems_post: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SearchApi.new
opts = { 
  body: JCAPIv1::Search.new, # Search | 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Search System Users
  result = api_instance.search_systemusers_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SearchApi->search_systemusers_post: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemsApi.new
system_id = 'system_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Erase a System
  api_instance.systems_command_builtin_erase(system_id, opts)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemsApi->systems_command_builtin_erase: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemsApi.new
system_id = 'system_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Lock a System
  api_instance.systems_command_builtin_lock(system_id, opts)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemsApi->systems_command_builtin_lock: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemsApi.new
system_id = 'system_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Restart a System
  api_instance.systems_command_builtin_restart(system_id, opts)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemsApi->systems_command_builtin_restart: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemsApi.new
system_id = 'system_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Shutdown a System
  api_instance.systems_command_builtin_shutdown(system_id, opts)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemsApi->systems_command_builtin_shutdown: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemsApi.new
id = 'id_example' # String | 
opts = { 
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Delete a System
  result = api_instance.systems_delete(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemsApi->systems_delete: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemsApi.new
id = 'id_example' # String | 
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #List an individual system
  result = api_instance.systems_get(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemsApi->systems_get: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemsApi.new
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | 
  search: 'search_example', # String | A nested object containing a `searchTerm` string or array of strings and a list of `fields` to search on.
  skip: 0, # Integer | The offset into the records to return.
  sort: 'sort_example', # String | Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with `-` to sort descending. 
  filter: 'filter_example' # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
}

begin
  #List All Systems
  result = api_instance.systems_list(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemsApi->systems_list: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::Systemput.new, # Systemput | 
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Update a system
  result = api_instance.systems_put(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemsApi->systems_put: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
systemuser_id = 'systemuser_id_example' # String | 
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Delete a system user's Public SSH Keys
  result = api_instance.sshkey_delete(systemuser_id, id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->sshkey_delete: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #List a system user's public SSH keys
  result = api_instance.sshkey_list(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->sshkey_list: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::Sshkeypost.new, # Sshkeypost | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Create a system user's Public SSH Key
  result = api_instance.sshkey_post(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->sshkey_post: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example', # String | 
  cascade_manager: 'cascade_manager_example' # String | This is an optional flag that can be enabled on the DELETE call, DELETE /systemusers/{id}?cascade_manager=null. This parameter will clear the Manager attribute on all direct reports and then delete the account.
}

begin
  #Delete a system user
  result = api_instance.systemusers_delete(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_delete: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Expire a system user's password
  result = api_instance.systemusers_expire(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_expire: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
id = 'id_example' # String | 
opts = { 
  fields: 'fields_example', # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #List a system user
  result = api_instance.systemusers_get(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_get: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0, # Integer | The offset into the records to return.
  sort: 'sort_example', # String | The space separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  fields: 'fields_example', # String | The space separated fields included in the returned records. If omitted the default list of fields will be returned. 
  filter: 'filter_example', # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  x_org_id: 'x_org_id_example', # String | 
  search: 'search_example' # String | A nested object containing a `searchTerm` string or array of strings and a list of `fields` to search on.
}

begin
  #List all system users
  result = api_instance.systemusers_list(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_list: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
id = 'id_example' # String | 


begin
  #Sync a systemuser's mfa enrollment status
  api_instance.systemusers_mfasync(id)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_mfasync: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
opts = { 
  body: JCAPIv1::Systemuserputpost.new, # Systemuserputpost | 
  x_org_id: 'x_org_id_example', # String | 
  full_validation_details: 'full_validation_details_example' # String | Pass this query parameter when a client wants all validation errors to be returned with a detailed error response for the form field specified. The current form fields are allowed:  * `password`  #### Password validation flag Use the `password` validation flag to receive details on a possible bad request response ``` ?fullValidationDetails=password ``` Without the flag, default behavior will be a normal 400 with only a single validation string error #### Expected Behavior Clients can expect a list of validation error mappings for the validation query field in the details provided on the response: ``` {   \"code\": 400,   \"message\": \"Password validation fail\",   \"status\": \"INVALID_ARGUMENT\",   \"details\": [       {         \"fieldViolationsList\": [           {\"field\": \"password\", \"description\": \"specialCharacter\"}         ],         '@type': 'type.googleapis.com/google.rpc.BadRequest',       },   ], }, ```
}

begin
  #Create a system user
  result = api_instance.systemusers_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_post: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::Systemuserput.new, # Systemuserput | 
  x_org_id: 'x_org_id_example', # String | 
  full_validation_details: 'full_validation_details_example' # String | This endpoint can take in a query when a client wants all validation errors to be returned with error response for the form field specified, i.e. 'password' #### Password validation flag Use the \"password\" validation flag to receive details on a possible bad request response Without the `password` flag, default behavior will be a normal 400 with only a validation string message ``` ?fullValidationDetails=password ``` #### Expected Behavior Clients can expect a list of validation error mappings for the validation query field in the details provided on the response: ``` {   \"code\": 400,   \"message\": \"Password validation fail\",   \"status\": \"INVALID_ARGUMENT\",   \"details\": [       {         \"fieldViolationsList\": [{ \"field\": \"password\", \"description\": \"passwordHistory\" }],         '@type': 'type.googleapis.com/google.rpc.BadRequest',       },   ], }, ```
}

begin
  #Update a system user
  result = api_instance.systemusers_put(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_put: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::IdResetmfaBody.new, # IdResetmfaBody | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Reset a system user's MFA token
  result = api_instance.systemusers_resetmfa(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_resetmfa: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::StateActivateBody.new # StateActivateBody | 
}

begin
  #Activate System User
  result = api_instance.systemusers_state_activate(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_state_activate: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SystemusersApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Unlock a system user
  result = api_instance.systemusers_unlock(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_unlock: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::UsersApi.new
id = 'id_example' # String | 


begin
  #Administrator TOTP Reset Initiation
  api_instance.admin_totpreset_begin(id)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling UsersApi->admin_totpreset_begin: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::UsersApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv1::Userput.new, # Userput | 
  x_org_id: 'x_org_id_example' # String | 
}

begin
  #Update a user
  result = api_instance.users_put(id, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling UsersApi->users_put: #{e}"
end
# Setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::UsersApi.new
id = 'id_example' # String | 


begin
  #Administrator Password Reset Initiation
  api_instance.users_reactivate_get(id)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling UsersApi->users_reactivate_get: #{e}"
end
```

## Documentation for API Endpoints

All URIs are relative to *https://console.jumpcloud.com/api*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*JCAPIv1::ApplicationTemplatesApi* | [**application_templates_get**](docs/ApplicationTemplatesApi.md#application_templates_get) | **GET** /application-templates/{id} | Get an Application Template
*JCAPIv1::ApplicationTemplatesApi* | [**application_templates_list**](docs/ApplicationTemplatesApi.md#application_templates_list) | **GET** /application-templates | List Application Templates
*JCAPIv1::ApplicationsApi* | [**applications_delete**](docs/ApplicationsApi.md#applications_delete) | **DELETE** /applications/{id} | Delete an Application
*JCAPIv1::ApplicationsApi* | [**applications_get**](docs/ApplicationsApi.md#applications_get) | **GET** /applications/{id} | Get an Application
*JCAPIv1::ApplicationsApi* | [**applications_list**](docs/ApplicationsApi.md#applications_list) | **GET** /applications | Applications
*JCAPIv1::ApplicationsApi* | [**applications_post**](docs/ApplicationsApi.md#applications_post) | **POST** /applications | Create an Application
*JCAPIv1::ApplicationsApi* | [**applications_put**](docs/ApplicationsApi.md#applications_put) | **PUT** /applications/{id} | Update an Application
*JCAPIv1::CommandResultsApi* | [**command_results_delete**](docs/CommandResultsApi.md#command_results_delete) | **DELETE** /commandresults/{id} | Delete a Command result
*JCAPIv1::CommandResultsApi* | [**command_results_get**](docs/CommandResultsApi.md#command_results_get) | **GET** /commandresults/{id} | List an individual Command result
*JCAPIv1::CommandResultsApi* | [**command_results_list**](docs/CommandResultsApi.md#command_results_list) | **GET** /commandresults | List all Command Results
*JCAPIv1::CommandTriggersApi* | [**command_trigger_webhook_post**](docs/CommandTriggersApi.md#command_trigger_webhook_post) | **POST** /command/trigger/{triggername} | Launch a command via a Trigger
*JCAPIv1::CommandsApi* | [**command_file_get**](docs/CommandsApi.md#command_file_get) | **GET** /files/command/{id} | Get a Command File
*JCAPIv1::CommandsApi* | [**commands_delete**](docs/CommandsApi.md#commands_delete) | **DELETE** /commands/{id} | Delete a Command
*JCAPIv1::CommandsApi* | [**commands_get**](docs/CommandsApi.md#commands_get) | **GET** /commands/{id} | List an individual Command
*JCAPIv1::CommandsApi* | [**commands_get_results**](docs/CommandsApi.md#commands_get_results) | **GET** /commands/{id}/results | Get results for a specific command
*JCAPIv1::CommandsApi* | [**commands_list**](docs/CommandsApi.md#commands_list) | **GET** /commands | List All Commands
*JCAPIv1::CommandsApi* | [**commands_post**](docs/CommandsApi.md#commands_post) | **POST** /commands | Create A Command
*JCAPIv1::CommandsApi* | [**commands_put**](docs/CommandsApi.md#commands_put) | **PUT** /commands/{id} | Update a Command
*JCAPIv1::ManagedServiceProviderApi* | [**admin_totpreset_begin**](docs/ManagedServiceProviderApi.md#admin_totpreset_begin) | **POST** /users/resettotp/{id} | Administrator TOTP Reset Initiation
*JCAPIv1::ManagedServiceProviderApi* | [**organization_list**](docs/ManagedServiceProviderApi.md#organization_list) | **GET** /organizations | Get Organization Details
*JCAPIv1::ManagedServiceProviderApi* | [**users_put**](docs/ManagedServiceProviderApi.md#users_put) | **PUT** /users/{id} | Update a user
*JCAPIv1::ManagedServiceProviderApi* | [**users_reactivate_get**](docs/ManagedServiceProviderApi.md#users_reactivate_get) | **GET** /users/reactivate/{id} | Administrator Password Reset Initiation
*JCAPIv1::OrganizationsApi* | [**organization_list**](docs/OrganizationsApi.md#organization_list) | **GET** /organizations | Get Organization Details
*JCAPIv1::OrganizationsApi* | [**organization_put**](docs/OrganizationsApi.md#organization_put) | **PUT** /organizations/{id} | Update an Organization
*JCAPIv1::OrganizationsApi* | [**organizations_get**](docs/OrganizationsApi.md#organizations_get) | **GET** /organizations/{id} | Get an Organization
*JCAPIv1::RadiusServersApi* | [**radius_servers_delete**](docs/RadiusServersApi.md#radius_servers_delete) | **DELETE** /radiusservers/{id} | Delete Radius Server
*JCAPIv1::RadiusServersApi* | [**radius_servers_get**](docs/RadiusServersApi.md#radius_servers_get) | **GET** /radiusservers/{id} | Get Radius Server
*JCAPIv1::RadiusServersApi* | [**radius_servers_list**](docs/RadiusServersApi.md#radius_servers_list) | **GET** /radiusservers | List Radius Servers
*JCAPIv1::RadiusServersApi* | [**radius_servers_post**](docs/RadiusServersApi.md#radius_servers_post) | **POST** /radiusservers | Create a Radius Server
*JCAPIv1::RadiusServersApi* | [**radius_servers_put**](docs/RadiusServersApi.md#radius_servers_put) | **PUT** /radiusservers/{id} | Update Radius Servers
*JCAPIv1::SearchApi* | [**search_commandresults_post**](docs/SearchApi.md#search_commandresults_post) | **POST** /search/commandresults | Search Commands Results
*JCAPIv1::SearchApi* | [**search_commands_post**](docs/SearchApi.md#search_commands_post) | **POST** /search/commands | Search Commands
*JCAPIv1::SearchApi* | [**search_organizations_post**](docs/SearchApi.md#search_organizations_post) | **POST** /search/organizations | Search Organizations
*JCAPIv1::SearchApi* | [**search_systems_post**](docs/SearchApi.md#search_systems_post) | **POST** /search/systems | Search Systems
*JCAPIv1::SearchApi* | [**search_systemusers_post**](docs/SearchApi.md#search_systemusers_post) | **POST** /search/systemusers | Search System Users
*JCAPIv1::SystemsApi* | [**systems_command_builtin_erase**](docs/SystemsApi.md#systems_command_builtin_erase) | **POST** /systems/{system_id}/command/builtin/erase | Erase a System
*JCAPIv1::SystemsApi* | [**systems_command_builtin_lock**](docs/SystemsApi.md#systems_command_builtin_lock) | **POST** /systems/{system_id}/command/builtin/lock | Lock a System
*JCAPIv1::SystemsApi* | [**systems_command_builtin_restart**](docs/SystemsApi.md#systems_command_builtin_restart) | **POST** /systems/{system_id}/command/builtin/restart | Restart a System
*JCAPIv1::SystemsApi* | [**systems_command_builtin_shutdown**](docs/SystemsApi.md#systems_command_builtin_shutdown) | **POST** /systems/{system_id}/command/builtin/shutdown | Shutdown a System
*JCAPIv1::SystemsApi* | [**systems_delete**](docs/SystemsApi.md#systems_delete) | **DELETE** /systems/{id} | Delete a System
*JCAPIv1::SystemsApi* | [**systems_get**](docs/SystemsApi.md#systems_get) | **GET** /systems/{id} | List an individual system
*JCAPIv1::SystemsApi* | [**systems_list**](docs/SystemsApi.md#systems_list) | **GET** /systems | List All Systems
*JCAPIv1::SystemsApi* | [**systems_put**](docs/SystemsApi.md#systems_put) | **PUT** /systems/{id} | Update a system
*JCAPIv1::SystemusersApi* | [**sshkey_delete**](docs/SystemusersApi.md#sshkey_delete) | **DELETE** /systemusers/{systemuser_id}/sshkeys/{id} | Delete a system user's Public SSH Keys
*JCAPIv1::SystemusersApi* | [**sshkey_list**](docs/SystemusersApi.md#sshkey_list) | **GET** /systemusers/{id}/sshkeys | List a system user's public SSH keys
*JCAPIv1::SystemusersApi* | [**sshkey_post**](docs/SystemusersApi.md#sshkey_post) | **POST** /systemusers/{id}/sshkeys | Create a system user's Public SSH Key
*JCAPIv1::SystemusersApi* | [**systemusers_delete**](docs/SystemusersApi.md#systemusers_delete) | **DELETE** /systemusers/{id} | Delete a system user
*JCAPIv1::SystemusersApi* | [**systemusers_expire**](docs/SystemusersApi.md#systemusers_expire) | **POST** /systemusers/{id}/expire | Expire a system user's password
*JCAPIv1::SystemusersApi* | [**systemusers_get**](docs/SystemusersApi.md#systemusers_get) | **GET** /systemusers/{id} | List a system user
*JCAPIv1::SystemusersApi* | [**systemusers_list**](docs/SystemusersApi.md#systemusers_list) | **GET** /systemusers | List all system users
*JCAPIv1::SystemusersApi* | [**systemusers_mfasync**](docs/SystemusersApi.md#systemusers_mfasync) | **POST** /systemusers/{id}/mfasync | Sync a systemuser's mfa enrollment status
*JCAPIv1::SystemusersApi* | [**systemusers_post**](docs/SystemusersApi.md#systemusers_post) | **POST** /systemusers | Create a system user
*JCAPIv1::SystemusersApi* | [**systemusers_put**](docs/SystemusersApi.md#systemusers_put) | **PUT** /systemusers/{id} | Update a system user
*JCAPIv1::SystemusersApi* | [**systemusers_resetmfa**](docs/SystemusersApi.md#systemusers_resetmfa) | **POST** /systemusers/{id}/resetmfa | Reset a system user's MFA token
*JCAPIv1::SystemusersApi* | [**systemusers_state_activate**](docs/SystemusersApi.md#systemusers_state_activate) | **POST** /systemusers/{id}/state/activate | Activate System User
*JCAPIv1::SystemusersApi* | [**systemusers_unlock**](docs/SystemusersApi.md#systemusers_unlock) | **POST** /systemusers/{id}/unlock | Unlock a system user
*JCAPIv1::UsersApi* | [**admin_totpreset_begin**](docs/UsersApi.md#admin_totpreset_begin) | **POST** /users/resettotp/{id} | Administrator TOTP Reset Initiation
*JCAPIv1::UsersApi* | [**users_put**](docs/UsersApi.md#users_put) | **PUT** /users/{id} | Update a user
*JCAPIv1::UsersApi* | [**users_reactivate_get**](docs/UsersApi.md#users_reactivate_get) | **GET** /users/reactivate/{id} | Administrator Password Reset Initiation

## Documentation for Models

 - [JCAPIv1::Application](docs/Application.md)
 - [JCAPIv1::ApplicationConfig](docs/ApplicationConfig.md)
 - [JCAPIv1::ApplicationConfigAcsUrl](docs/ApplicationConfigAcsUrl.md)
 - [JCAPIv1::ApplicationConfigAcsUrlTooltip](docs/ApplicationConfigAcsUrlTooltip.md)
 - [JCAPIv1::ApplicationConfigAcsUrlTooltipVariables](docs/ApplicationConfigAcsUrlTooltipVariables.md)
 - [JCAPIv1::ApplicationConfigConstantAttributes](docs/ApplicationConfigConstantAttributes.md)
 - [JCAPIv1::ApplicationConfigConstantAttributesValue](docs/ApplicationConfigConstantAttributesValue.md)
 - [JCAPIv1::ApplicationConfigDatabaseAttributes](docs/ApplicationConfigDatabaseAttributes.md)
 - [JCAPIv1::ApplicationLogo](docs/ApplicationLogo.md)
 - [JCAPIv1::Applicationslist](docs/Applicationslist.md)
 - [JCAPIv1::Applicationtemplate](docs/Applicationtemplate.md)
 - [JCAPIv1::ApplicationtemplateJit](docs/ApplicationtemplateJit.md)
 - [JCAPIv1::ApplicationtemplateLogo](docs/ApplicationtemplateLogo.md)
 - [JCAPIv1::ApplicationtemplateOidc](docs/ApplicationtemplateOidc.md)
 - [JCAPIv1::ApplicationtemplateProvision](docs/ApplicationtemplateProvision.md)
 - [JCAPIv1::Applicationtemplateslist](docs/Applicationtemplateslist.md)
 - [JCAPIv1::Command](docs/Command.md)
 - [JCAPIv1::Commandfilereturn](docs/Commandfilereturn.md)
 - [JCAPIv1::CommandfilereturnResults](docs/CommandfilereturnResults.md)
 - [JCAPIv1::Commandresult](docs/Commandresult.md)
 - [JCAPIv1::CommandresultResponse](docs/CommandresultResponse.md)
 - [JCAPIv1::CommandresultResponseData](docs/CommandresultResponseData.md)
 - [JCAPIv1::Commandresultslist](docs/Commandresultslist.md)
 - [JCAPIv1::CommandresultslistResults](docs/CommandresultslistResults.md)
 - [JCAPIv1::Commandslist](docs/Commandslist.md)
 - [JCAPIv1::CommandslistResults](docs/CommandslistResults.md)
 - [JCAPIv1::Error](docs/Error.md)
 - [JCAPIv1::ErrorDetails](docs/ErrorDetails.md)
 - [JCAPIv1::Fde](docs/Fde.md)
 - [JCAPIv1::IdResetmfaBody](docs/IdResetmfaBody.md)
 - [JCAPIv1::Mfa](docs/Mfa.md)
 - [JCAPIv1::MfaEnrollment](docs/MfaEnrollment.md)
 - [JCAPIv1::MfaEnrollmentStatus](docs/MfaEnrollmentStatus.md)
 - [JCAPIv1::Organization](docs/Organization.md)
 - [JCAPIv1::Organizationentitlement](docs/Organizationentitlement.md)
 - [JCAPIv1::OrganizationentitlementEntitlementProducts](docs/OrganizationentitlementEntitlementProducts.md)
 - [JCAPIv1::OrganizationsIdBody](docs/OrganizationsIdBody.md)
 - [JCAPIv1::Organizationsettings](docs/Organizationsettings.md)
 - [JCAPIv1::OrganizationsettingsDisplayPreferences](docs/OrganizationsettingsDisplayPreferences.md)
 - [JCAPIv1::OrganizationsettingsDisplayPreferencesOrgInsights](docs/OrganizationsettingsDisplayPreferencesOrgInsights.md)
 - [JCAPIv1::OrganizationsettingsDisplayPreferencesOrgInsightsApplicationsUsage](docs/OrganizationsettingsDisplayPreferencesOrgInsightsApplicationsUsage.md)
 - [JCAPIv1::OrganizationsettingsDisplayPreferencesOrgInsightsConsoleStats](docs/OrganizationsettingsDisplayPreferencesOrgInsightsConsoleStats.md)
 - [JCAPIv1::OrganizationsettingsDisplayPreferencesOrgInsightsDeviceNotifications](docs/OrganizationsettingsDisplayPreferencesOrgInsightsDeviceNotifications.md)
 - [JCAPIv1::OrganizationsettingsDisplayPreferencesOrgInsightsUserNotifications](docs/OrganizationsettingsDisplayPreferencesOrgInsightsUserNotifications.md)
 - [JCAPIv1::OrganizationsettingsFeatures](docs/OrganizationsettingsFeatures.md)
 - [JCAPIv1::OrganizationsettingsFeaturesDirectoryInsights](docs/OrganizationsettingsFeaturesDirectoryInsights.md)
 - [JCAPIv1::OrganizationsettingsFeaturesDirectoryInsightsPremium](docs/OrganizationsettingsFeaturesDirectoryInsightsPremium.md)
 - [JCAPIv1::OrganizationsettingsFeaturesSystemInsights](docs/OrganizationsettingsFeaturesSystemInsights.md)
 - [JCAPIv1::OrganizationsettingsNewSystemUserStateDefaults](docs/OrganizationsettingsNewSystemUserStateDefaults.md)
 - [JCAPIv1::OrganizationsettingsPasswordPolicy](docs/OrganizationsettingsPasswordPolicy.md)
 - [JCAPIv1::OrganizationsettingsUserPortal](docs/OrganizationsettingsUserPortal.md)
 - [JCAPIv1::Organizationsettingsput](docs/Organizationsettingsput.md)
 - [JCAPIv1::OrganizationsettingsputNewSystemUserStateDefaults](docs/OrganizationsettingsputNewSystemUserStateDefaults.md)
 - [JCAPIv1::OrganizationsettingsputPasswordPolicy](docs/OrganizationsettingsputPasswordPolicy.md)
 - [JCAPIv1::Organizationslist](docs/Organizationslist.md)
 - [JCAPIv1::OrganizationslistResults](docs/OrganizationslistResults.md)
 - [JCAPIv1::Radiusserver](docs/Radiusserver.md)
 - [JCAPIv1::Radiusserverpost](docs/Radiusserverpost.md)
 - [JCAPIv1::Radiusserverput](docs/Radiusserverput.md)
 - [JCAPIv1::RadiusserversIdBody](docs/RadiusserversIdBody.md)
 - [JCAPIv1::Radiusserverslist](docs/Radiusserverslist.md)
 - [JCAPIv1::Search](docs/Search.md)
 - [JCAPIv1::Sshkeylist](docs/Sshkeylist.md)
 - [JCAPIv1::Sshkeypost](docs/Sshkeypost.md)
 - [JCAPIv1::Sso](docs/Sso.md)
 - [JCAPIv1::StateActivateBody](docs/StateActivateBody.md)
 - [JCAPIv1::System](docs/System.md)
 - [JCAPIv1::SystemBuiltInCommands](docs/SystemBuiltInCommands.md)
 - [JCAPIv1::SystemDomainInfo](docs/SystemDomainInfo.md)
 - [JCAPIv1::SystemMdm](docs/SystemMdm.md)
 - [JCAPIv1::SystemMdmInternal](docs/SystemMdmInternal.md)
 - [JCAPIv1::SystemNetworkInterfaces](docs/SystemNetworkInterfaces.md)
 - [JCAPIv1::SystemOsVersionDetail](docs/SystemOsVersionDetail.md)
 - [JCAPIv1::SystemProvisionMetadata](docs/SystemProvisionMetadata.md)
 - [JCAPIv1::SystemProvisionMetadataProvisioner](docs/SystemProvisionMetadataProvisioner.md)
 - [JCAPIv1::SystemServiceAccountState](docs/SystemServiceAccountState.md)
 - [JCAPIv1::SystemSshdParams](docs/SystemSshdParams.md)
 - [JCAPIv1::SystemSystemInsights](docs/SystemSystemInsights.md)
 - [JCAPIv1::SystemUserMetrics](docs/SystemUserMetrics.md)
 - [JCAPIv1::Systemput](docs/Systemput.md)
 - [JCAPIv1::SystemputAgentBoundMessages](docs/SystemputAgentBoundMessages.md)
 - [JCAPIv1::Systemslist](docs/Systemslist.md)
 - [JCAPIv1::Systemuserput](docs/Systemuserput.md)
 - [JCAPIv1::SystemuserputAddresses](docs/SystemuserputAddresses.md)
 - [JCAPIv1::SystemuserputAttributes](docs/SystemuserputAttributes.md)
 - [JCAPIv1::SystemuserputPhoneNumbers](docs/SystemuserputPhoneNumbers.md)
 - [JCAPIv1::SystemuserputRelationships](docs/SystemuserputRelationships.md)
 - [JCAPIv1::Systemuserputpost](docs/Systemuserputpost.md)
 - [JCAPIv1::SystemuserputpostAddresses](docs/SystemuserputpostAddresses.md)
 - [JCAPIv1::SystemuserputpostPhoneNumbers](docs/SystemuserputpostPhoneNumbers.md)
 - [JCAPIv1::SystemuserputpostRecoveryEmail](docs/SystemuserputpostRecoveryEmail.md)
 - [JCAPIv1::Systemuserreturn](docs/Systemuserreturn.md)
 - [JCAPIv1::SystemuserreturnAddresses](docs/SystemuserreturnAddresses.md)
 - [JCAPIv1::SystemuserreturnPhoneNumbers](docs/SystemuserreturnPhoneNumbers.md)
 - [JCAPIv1::SystemuserreturnRecoveryEmail](docs/SystemuserreturnRecoveryEmail.md)
 - [JCAPIv1::Systemuserslist](docs/Systemuserslist.md)
 - [JCAPIv1::Triggerreturn](docs/Triggerreturn.md)
 - [JCAPIv1::TrustedappConfigGet](docs/TrustedappConfigGet.md)
 - [JCAPIv1::TrustedappConfigGetTrustedApps](docs/TrustedappConfigGetTrustedApps.md)
 - [JCAPIv1::TrustedappConfigPut](docs/TrustedappConfigPut.md)
 - [JCAPIv1::Userput](docs/Userput.md)
 - [JCAPIv1::Userreturn](docs/Userreturn.md)
 - [JCAPIv1::UserreturnGrowthData](docs/UserreturnGrowthData.md)

## Documentation for Authorization


### x-api-key

- **Type**: API key
- **API key parameter name**: x-api-key
- **Location**: HTTP header

