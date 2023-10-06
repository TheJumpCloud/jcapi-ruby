# jcapiv2

JCAPIv2 - the Ruby gem for the JumpCloud API

# Overview  JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.  ## API Best Practices  Read the linked Help Article below for guidance on retrying failed requests to JumpCloud's REST API, as well as best practices for structuring subsequent retry requests. Customizing retry mechanisms based on these recommendations will increase the reliability and dependability of your API calls.  Covered topics include: 1. Important Considerations 2. Supported HTTP Request Methods 3. Response codes 4. API Key rotation 5. Paginating 6. Error handling 7. Retry rates  [JumpCloud Help Center - API Best Practices](https://support.jumpcloud.com/support/s/article/JumpCloud-API-Best-Practices)  # Directory Objects  This API offers the ability to interact with some of our core features; otherwise known as Directory Objects. The Directory Objects are:  * Commands * Policies * Policy Groups * Applications * Systems * Users * User Groups * System Groups * Radius Servers * Directories: Office 365, LDAP,G-Suite, Active Directory * Duo accounts and applications.  The Directory Object is an important concept to understand in order to successfully use JumpCloud API.  ## JumpCloud Graph  We've also introduced the concept of the JumpCloud Graph along with  Directory Objects. The Graph is a powerful aspect of our platform which will enable you to associate objects with each other, or establish membership for certain objects to become members of other objects.  Specific `GET` endpoints will allow you to traverse the JumpCloud Graph to return all indirect and directly bound objects in your organization.  | ![alt text](https://s3.amazonaws.com/jumpcloud-kb/Knowledge+Base+Photos/API+Docs/jumpcloud_graph.png \"JumpCloud Graph Model Example\") | |:--:| | **This diagram highlights our association and membership model as it relates to Directory Objects.** |  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/v2/systemgroups\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

This SDK is automatically generated by the [Swagger Codegen](https://github.com/swagger-api/swagger-codegen) project:

- API version: 2.0
- Package version: 4.0.0
- Build package: io.swagger.codegen.v3.generators.ruby.RubyClientCodegen
For more information, please visit [https://support.jumpcloud.com/support/s/](https://support.jumpcloud.com/support/s/)

## Installation

### Build a gem

To build the Ruby code into a gem:

```shell
gem build jcapiv2.gemspec
```

Then either install the gem locally:

```shell
gem install ./jcapiv2-4.0.0.gem
```
(for development, run `gem install --dev ./jcapiv2-4.0.0.gem` to install the development dependencies)

or publish the gem to a gem hosting service, e.g. [RubyGems](https://rubygems.org/).

Finally add this to the Gemfile:

    gem 'jcapiv2', '~> 4.0.0'

### Install from Git

If the Ruby gem is hosted at a git repository: https://github.com/GIT_USER_ID/GIT_REPO_ID, then add the following in the Gemfile:

    gem 'jcapiv2', :git => 'https://github.com/GIT_USER_ID/GIT_REPO_ID.git'

### Include the Ruby code directly

Include the Ruby code directly using `-I` as follows:

```shell
ruby -Ilib script.rb
```

## Getting Started

Please follow the [installation](#installation) procedure and then run the following code:
```ruby
# Load the gem
require 'jcapiv2'
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ActiveDirectoryApi.new
activedirectory_id = 'activedirectory_id_example' # String | 
agent_id = 'agent_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete Active Directory Agent
  api_instance.activedirectories_agents_delete(activedirectory_id, agent_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_agents_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ActiveDirectoryApi.new
activedirectory_id = 'activedirectory_id_example' # String | 
agent_id = 'agent_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get Active Directory Agent
  result = api_instance.activedirectories_agents_get(activedirectory_id, agent_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_agents_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ActiveDirectoryApi.new
activedirectory_id = 'activedirectory_id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Active Directory Agents
  result = api_instance.activedirectories_agents_list(activedirectory_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_agents_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ActiveDirectoryApi.new
activedirectory_id = 'activedirectory_id_example' # String | 
opts = { 
  body: JCAPIv2::ActiveDirectoryAgent.new, # ActiveDirectoryAgent | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create a new Active Directory Agent
  result = api_instance.activedirectories_agents_post(activedirectory_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_agents_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ActiveDirectoryApi.new
id = 'id_example' # String | ObjectID of this Active Directory instance.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete an Active Directory
  result = api_instance.activedirectories_delete(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ActiveDirectoryApi.new
id = 'id_example' # String | ObjectID of this Active Directory instance.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get an Active Directory
  result = api_instance.activedirectories_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ActiveDirectoryApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Active Directories
  result = api_instance.activedirectories_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ActiveDirectoryApi.new
opts = { 
  body: JCAPIv2::ActiveDirectory.new, # ActiveDirectory | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create a new Active Directory
  result = api_instance.activedirectories_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->activedirectories_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ActiveDirectoryApi.new
activedirectory_id = 'activedirectory_id_example' # String | 
targets = ['targets_example'] # Array<String> | Targets which a \"active_directory\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of an Active Directory instance
  result = api_instance.graph_active_directory_associations_list(activedirectory_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->graph_active_directory_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ActiveDirectoryApi.new
activedirectory_id = 'activedirectory_id_example' # String | 
opts = { 
  body: JCAPIv2::GraphOperationActiveDirectory.new, # GraphOperationActiveDirectory | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of an Active Directory instance
  api_instance.graph_active_directory_associations_post(activedirectory_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->graph_active_directory_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ActiveDirectoryApi.new
activedirectory_id = 'activedirectory_id_example' # String | ObjectID of the Active Directory instance.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Users bound to an Active Directory instance
  result = api_instance.graph_active_directory_traverse_user(activedirectory_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->graph_active_directory_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ActiveDirectoryApi.new
activedirectory_id = 'activedirectory_id_example' # String | ObjectID of the Active Directory instance.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to an Active Directory instance
  result = api_instance.graph_active_directory_traverse_user_group(activedirectory_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ActiveDirectoryApi->graph_active_directory_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AdministratorsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::AdministratorOrganizationLinkReq.new # AdministratorOrganizationLinkReq | 
}

begin
  #Allow Adminstrator access to an Organization.
  result = api_instance.administrator_organizations_create_by_administrator(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AdministratorsApi->administrator_organizations_create_by_administrator: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AdministratorsApi.new
id = 'id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the association links between an Administrator and Organizations.
  result = api_instance.administrator_organizations_list_by_administrator(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AdministratorsApi->administrator_organizations_list_by_administrator: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AdministratorsApi.new
id = 'id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the association links between an Organization and Administrators.
  result = api_instance.administrator_organizations_list_by_organization(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AdministratorsApi->administrator_organizations_list_by_organization: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AdministratorsApi.new
administrator_id = 'administrator_id_example' # String | 
id = 'id_example' # String | 


begin
  #Remove association between an Administrator and an Organization.
  api_instance.administrator_organizations_remove_by_administrator(administrator_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AdministratorsApi->administrator_organizations_remove_by_administrator: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get Apple MDM CSR Plist
  result = api_instance.applemdms_csrget(apple_mdm_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_csrget: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete an Apple MDM
  result = api_instance.applemdms_delete(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Remove an Apple MDM Device's Enrollment
  result = api_instance.applemdms_deletedevice(apple_mdm_id, device_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_deletedevice: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get Apple MDM DEP Public Key
  result = api_instance.applemdms_depkeyget(apple_mdm_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_depkeyget: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Clears the Activation Lock for a Device
  api_instance.applemdms_devices_clear_activation_lock(apple_mdm_id, device_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_devices_clear_activation_lock: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Request the status of an OS update for a device
  api_instance.applemdms_devices_os_update_status(apple_mdm_id, device_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_devices_os_update_status: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Refresh activation lock information for a device
  api_instance.applemdms_devices_refresh_activation_lock_information(apple_mdm_id, device_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_devices_refresh_activation_lock_information: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  body: JCAPIv2::ScheduleOSUpdate.new, # ScheduleOSUpdate | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Schedule an OS update for a device
  api_instance.applemdms_devices_schedule_os_update(apple_mdm_id, device_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_devices_schedule_os_update: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  body: JCAPIv2::DeviceIdEraseBody.new, # DeviceIdEraseBody | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Erase Device
  api_instance.applemdms_deviceserase(apple_mdm_id, device_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_deviceserase: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_total_count: 56 # Integer | 
}

begin
  #List AppleMDM Devices
  result = api_instance.applemdms_deviceslist(apple_mdm_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_deviceslist: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  body: JCAPIv2::DeviceIdLockBody.new, # DeviceIdLockBody | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Lock Device
  api_instance.applemdms_deviceslock(apple_mdm_id, device_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_deviceslock: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  body: JCAPIv2::DeviceIdRestartBody.new, # DeviceIdRestartBody | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Restart Device
  api_instance.applemdms_devicesrestart(apple_mdm_id, device_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_devicesrestart: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Shut Down Device
  api_instance.applemdms_devicesshutdown(apple_mdm_id, device_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_devicesshutdown: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get an Apple MDM Enrollment Profile
  result = api_instance.applemdms_enrollmentprofilesget(apple_mdm_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_enrollmentprofilesget: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Apple MDM Enrollment Profiles
  result = api_instance.applemdms_enrollmentprofileslist(apple_mdm_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_enrollmentprofileslist: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
device_id = 'device_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Details of an AppleMDM Device
  result = api_instance.applemdms_getdevice(apple_mdm_id, device_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_getdevice: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 1, # Integer | 
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List Apple MDMs
  result = api_instance.applemdms_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::AppleMdmPatch.new, # AppleMdmPatch | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update an Apple MDM
  result = api_instance.applemdms_put(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_put: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AppleMDMApi.new
apple_mdm_id = 'apple_mdm_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Refresh DEP Devices
  api_instance.applemdms_refreshdepdevices(apple_mdm_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AppleMDMApi->applemdms_refreshdepdevices: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete application image
  api_instance.applications_delete_logo(application_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->applications_delete_logo: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get an Application
  result = api_instance.applications_get(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->applications_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | 
opts = { 
  image: 'image_example', # String | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Save application logo
  api_instance.applications_post_logo(application_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->applications_post_logo: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
targets = ['targets_example'] # Array<String> | Targets which a \"application\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of an Application
  result = api_instance.graph_application_associations_list(application_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->graph_application_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  body: JCAPIv2::GraphOperationApplication.new, # GraphOperationApplication | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of an Application
  api_instance.graph_application_associations_post(application_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->graph_application_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to an Application
  result = api_instance.graph_application_traverse_user(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->graph_application_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to an Application
  result = api_instance.graph_application_traverse_user_group(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->graph_application_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  body: JCAPIv2::ImportUsersRequest.new, # ImportUsersRequest | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create an import job
  result = api_instance.import_create(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->import_create: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ApplicationsApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  filter: 'filter_example', # String | Filter users by a search term
  query: 'query_example', # String | URL query to merge with the service provider request
  sort: 'sort_example', # String | Sort users by supported fields
  sort_order: 'asc', # String | 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Get a list of users to import from an Application IdM service provider
  result = api_instance.import_users(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ApplicationsApi->import_users: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AuthenticationPoliciesApi.new
id = 'id_example' # String | Unique identifier of the authentication policy
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete Authentication Policy
  result = api_instance.authnpolicies_delete(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AuthenticationPoliciesApi->authnpolicies_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AuthenticationPoliciesApi.new
id = 'id_example' # String | Unique identifier of the authentication policy
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get an authentication policy
  result = api_instance.authnpolicies_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AuthenticationPoliciesApi->authnpolicies_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AuthenticationPoliciesApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  x_total_count: 56, # Integer | 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Authentication Policies
  result = api_instance.authnpolicies_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AuthenticationPoliciesApi->authnpolicies_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AuthenticationPoliciesApi.new
id = 'id_example' # String | Unique identifier of the authentication policy
opts = { 
  body: JCAPIv2::AuthnPolicy.new, # AuthnPolicy | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Patch Authentication Policy
  result = api_instance.authnpolicies_patch(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AuthenticationPoliciesApi->authnpolicies_patch: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::AuthenticationPoliciesApi.new
opts = { 
  body: JCAPIv2::AuthnPolicy.new, # AuthnPolicy | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create an Authentication Policy
  result = api_instance.authnpolicies_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling AuthenticationPoliciesApi->authnpolicies_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::BulkJobRequestsApi.new
opts = { 
  body: [JCAPIv2::BulkUserExpire.new], # Array<BulkUserExpire> | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Bulk Expire Users
  result = api_instance.bulk_user_expires(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_user_expires: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::BulkJobRequestsApi.new
opts = { 
  body: JCAPIv2::BulkScheduledStatechangeCreate.new, # BulkScheduledStatechangeCreate | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create Scheduled Userstate Job
  result = api_instance.bulk_user_states_create(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_user_states_create: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::BulkJobRequestsApi.new
id = 'id_example' # String | Unique identifier of the scheduled statechange job.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete Scheduled Userstate Job
  api_instance.bulk_user_states_delete(id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_user_states_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::BulkJobRequestsApi.new
users = ['users_example'] # Array<String> | A list of system user IDs, limited to 100 items.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Get the next scheduled state change for a list of users
  result = api_instance.bulk_user_states_get_next_scheduled(users, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_user_states_get_next_scheduled: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::BulkJobRequestsApi.new
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  userid: 'userid_example' # String | The systemuser id to filter by.
}

begin
  #List Scheduled Userstate Change Jobs
  result = api_instance.bulk_user_states_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_user_states_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::BulkJobRequestsApi.new
opts = { 
  body: [JCAPIv2::BulkUserUnlock.new], # Array<BulkUserUnlock> | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Bulk Unlock Users
  result = api_instance.bulk_user_unlocks(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_user_unlocks: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::BulkJobRequestsApi.new
opts = { 
  body: [JCAPIv2::BulkUserCreate.new], # Array<BulkUserCreate> | 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  creation_source: 'jumpcloud:bulk' # String | Defines the creation-source header for gapps, o365 and workdays requests. If the header isn't sent, the default value is `jumpcloud:bulk`, if you send the header with a malformed value you receive a 400 error. 
}

begin
  #Bulk Users Create
  result = api_instance.bulk_users_create(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_users_create: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::BulkJobRequestsApi.new
job_id = 'job_id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Bulk Users Results
  result = api_instance.bulk_users_create_results(job_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_users_create_results: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::BulkJobRequestsApi.new
opts = { 
  body: [JCAPIv2::BulkUserUpdate.new], # Array<BulkUserUpdate> | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Bulk Users Update
  result = api_instance.bulk_users_update(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling BulkJobRequestsApi->bulk_users_update: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::CommandResultsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10, # Integer | 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List all Command Results by Workflow
  result = api_instance.commands_list_results_by_workflow(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandResultsApi->commands_list_results_by_workflow: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::CommandsApi.new
workflow_instance_id = 'workflow_instance_id_example' # String | Workflow instance Id of the queued commands to cancel.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Cancel all queued commands for an organization by workflow instance Id
  api_instance.commands_cancel_queued_commands_by_workflow_instance_id(workflow_instance_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->commands_cancel_queued_commands_by_workflow_instance_id: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::CommandsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10, # Integer | 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  search: 'search_example' # String | The search string to query records
}

begin
  #Fetch the queued Commands for an Organization
  result = api_instance.commands_get_queued_commands_by_workflow(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->commands_get_queued_commands_by_workflow: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::CommandsApi.new
command_id = 'command_id_example' # String | ObjectID of the Command.
targets = ['targets_example'] # Array<String> | Targets which a \"command\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a Command
  result = api_instance.graph_command_associations_list(command_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->graph_command_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::CommandsApi.new
command_id = 'command_id_example' # String | ObjectID of the Command.
opts = { 
  body: JCAPIv2::GraphOperationCommand.new, # GraphOperationCommand | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a Command
  api_instance.graph_command_associations_post(command_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->graph_command_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::CommandsApi.new
command_id = 'command_id_example' # String | ObjectID of the Command.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a Command
  result = api_instance.graph_command_traverse_system(command_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->graph_command_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::CommandsApi.new
command_id = 'command_id_example' # String | ObjectID of the Command.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to a Command
  result = api_instance.graph_command_traverse_system_group(command_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CommandsApi->graph_command_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::CustomEmailsApi.new
opts = { 
  body: JCAPIv2::CustomEmail.new, # CustomEmail | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create custom email configuration
  result = api_instance.custom_emails_create(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CustomEmailsApi->custom_emails_create: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::CustomEmailsApi.new
custom_email_type = 'custom_email_type_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete custom email configuration
  api_instance.custom_emails_destroy(custom_email_type, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CustomEmailsApi->custom_emails_destroy: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::CustomEmailsApi.new

begin
  #List custom email templates
  result = api_instance.custom_emails_get_templates
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CustomEmailsApi->custom_emails_get_templates: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::CustomEmailsApi.new
custom_email_type = 'custom_email_type_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get custom email configuration
  result = api_instance.custom_emails_read(custom_email_type, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CustomEmailsApi->custom_emails_read: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::CustomEmailsApi.new
custom_email_type = 'custom_email_type_example' # String | 
opts = { 
  body: JCAPIv2::CustomEmail.new, # CustomEmail | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update custom email configuration
  result = api_instance.custom_emails_update(custom_email_type, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling CustomEmailsApi->custom_emails_update: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::DirectoriesApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List All Directories
  result = api_instance.directories_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DirectoriesApi->directories_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::DuoApi.new
id = 'id_example' # String | ObjectID of the Duo Account
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete a Duo Account
  result = api_instance.duo_account_delete(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_account_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::DuoApi.new
id = 'id_example' # String | ObjectID of the Duo Account
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get a Duo Acount
  result = api_instance.duo_account_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_account_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::DuoApi.new
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Duo Accounts
  result = api_instance.duo_account_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_account_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::DuoApi.new
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create Duo Account
  result = api_instance.duo_account_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_account_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::DuoApi.new
account_id = 'account_id_example' # String | 
application_id = 'application_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete a Duo Application
  result = api_instance.duo_application_delete(account_id, application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_application_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::DuoApi.new
account_id = 'account_id_example' # String | 
application_id = 'application_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get a Duo application
  result = api_instance.duo_application_get(account_id, application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_application_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::DuoApi.new
account_id = 'account_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Duo Applications
  result = api_instance.duo_application_list(account_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_application_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::DuoApi.new
account_id = 'account_id_example' # String | 
opts = { 
  body: JCAPIv2::DuoApplicationReq.new, # DuoApplicationReq | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create Duo Application
  result = api_instance.duo_application_post(account_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_application_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::DuoApi.new
account_id = 'account_id_example' # String | 
application_id = 'application_id_example' # String | 
opts = { 
  body: JCAPIv2::DuoApplicationUpdateReq.new, # DuoApplicationUpdateReq | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update Duo Application
  result = api_instance.duo_application_update(account_id, application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling DuoApi->duo_application_update: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::FdeApi.new
system_id = 'system_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get System FDE Key
  result = api_instance.systems_get_fde_key(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling FdeApi->systems_get_fde_key: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::FeatureTrialsApi.new
feature_code = 'feature_code_example' # String | 


begin
  #Check current feature trial usage for a specific feature
  result = api_instance.feature_trials_get_feature_trials(feature_code)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling FeatureTrialsApi->feature_trials_get_feature_trials: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'B' # String | Id for the specific Google Workspace directory sync integration instance.
domain_id = 'B' # String | Id for the domain.


begin
  #Delete a domain from a Google Workspace integration instance
  result = api_instance.gapps_domains_delete(gsuite_id, domain_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->gapps_domains_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'B' # String | Id for the specific Google Workspace directory sync integration instance.
opts = { 
  domain: 'domain_example' # String | 
}

begin
  #Add a domain to a Google Workspace integration instance
  result = api_instance.gapps_domains_insert(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->gapps_domains_insert: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'B' # String | Id for the specific Google Workspace directory sync integration instance..
opts = { 
  limit: '100', # String | The number of records to return at once. Limited to 100.
  skip: '0' # String | The offset into the records to return.
}

begin
  #List all domains configured for the Google Workspace integration instance
  result = api_instance.gapps_domains_list(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->gapps_domains_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | ObjectID of the G Suite instance.
targets = ['targets_example'] # Array<String> | Targets which a \"g_suite\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a G Suite instance
  result = api_instance.graph_g_suite_associations_list(gsuite_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->graph_g_suite_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | ObjectID of the G Suite instance.
opts = { 
  body: JCAPIv2::GraphOperationGSuite.new, # GraphOperationGSuite | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a G Suite instance
  api_instance.graph_g_suite_associations_post(gsuite_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->graph_g_suite_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | ObjectID of the G Suite instance.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a G Suite instance
  result = api_instance.graph_g_suite_traverse_user(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->graph_g_suite_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | ObjectID of the G Suite instance.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a G Suite instance
  result = api_instance.graph_g_suite_traverse_user_group(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->graph_g_suite_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
id = 'id_example' # String | Unique identifier of the GSuite.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get G Suite
  result = api_instance.gsuites_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->gsuites_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | 
opts = { 
  max_results: 56, # Integer | Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  order_by: 'order_by_example', # String | Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  page_token: 'page_token_example', # String | Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  query: 'query_example', # String | Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users.
  sort_order: 'sort_order_example' # String | Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
}

begin
  #Get a list of users in Jumpcloud format to import from a Google Workspace account.
  result = api_instance.gsuites_list_import_jumpcloud_users(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->gsuites_list_import_jumpcloud_users: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  max_results: 56, # Integer | Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  order_by: 'order_by_example', # String | Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  page_token: 'page_token_example', # String | Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  query: 'query_example', # String | Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users.
  sort_order: 'sort_order_example' # String | Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
}

begin
  #Get a list of users to import from a G Suite instance
  result = api_instance.gsuites_list_import_users(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->gsuites_list_import_users: #{e}"
end

api_instance = JCAPIv2::GSuiteApi.new
id = 'id_example' # String | Unique identifier of the GSuite.
opts = { 
  body: JCAPIv2::Gsuite.new, # Gsuite | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update existing G Suite
  result = api_instance.gsuites_patch(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->gsuites_patch: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | 
id = 'id_example' # String | 


begin
  #Deletes a G Suite translation rule
  api_instance.translation_rules_g_suite_delete(gsuite_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->translation_rules_g_suite_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | 
id = 'id_example' # String | 


begin
  #Gets a specific G Suite translation rule
  result = api_instance.translation_rules_g_suite_get(gsuite_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->translation_rules_g_suite_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List all the G Suite Translation Rules
  result = api_instance.translation_rules_g_suite_list(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->translation_rules_g_suite_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteApi.new
gsuite_id = 'gsuite_id_example' # String | 
opts = { 
  body: JCAPIv2::GSuiteTranslationRuleRequest.new # GSuiteTranslationRuleRequest | 
}

begin
  #Create a new G Suite Translation Rule
  result = api_instance.translation_rules_g_suite_post(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteApi->translation_rules_g_suite_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteImportApi.new
gsuite_id = 'gsuite_id_example' # String | 
opts = { 
  max_results: 56, # Integer | Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  order_by: 'order_by_example', # String | Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  page_token: 'page_token_example', # String | Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  query: 'query_example', # String | Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users.
  sort_order: 'sort_order_example' # String | Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
}

begin
  #Get a list of users in Jumpcloud format to import from a Google Workspace account.
  result = api_instance.gsuites_list_import_jumpcloud_users(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteImportApi->gsuites_list_import_jumpcloud_users: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GSuiteImportApi.new
gsuite_id = 'gsuite_id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  max_results: 56, # Integer | Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  order_by: 'order_by_example', # String | Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  page_token: 'page_token_example', # String | Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
  query: 'query_example', # String | Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users.
  sort_order: 'sort_order_example' # String | Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
}

begin
  #Get a list of users to import from a G Suite instance
  result = api_instance.gsuites_list_import_users(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GSuiteImportApi->gsuites_list_import_users: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
body = nil # Object | 
device_id = 'B' # String | 


begin
  #Erase the Android Device
  result = api_instance.devices_erase_device(body, device_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_erase_device: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
device_id = 'B' # String | 


begin
  #Get device
  result = api_instance.devices_get_device(device_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_get_device: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
device_id = 'B' # String | 


begin
  #Get the policy JSON of a device
  result = api_instance.devices_get_device_android_policy(device_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_get_device_android_policy: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
enterprise_object_id = 'B' # String | 
opts = { 
  limit: '100', # String | The number of records to return at once. Limited to 100.
  skip: '0', # String | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | 
}

begin
  #List devices
  result = api_instance.devices_list_devices(enterprise_object_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_list_devices: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
body = nil # Object | 
device_id = 'B' # String | 


begin
  #Lock device
  result = api_instance.devices_lock_device(body, device_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_lock_device: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
body = nil # Object | 
device_id = 'B' # String | 


begin
  #Reboot device
  result = api_instance.devices_reboot_device(body, device_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_reboot_device: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
body = JCAPIv2::DeviceIdResetpasswordBody.new # DeviceIdResetpasswordBody | 
device_id = 'B' # String | 


begin
  #Reset Password of a device
  result = api_instance.devices_reset_password(body, device_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->devices_reset_password: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
body = JCAPIv2::JumpcloudGoogleEmmCreateEnrollmentTokenRequest.new # JumpcloudGoogleEmmCreateEnrollmentTokenRequest | 


begin
  #Create an enrollment token
  result = api_instance.enrollment_tokens_create_enrollment_token(body)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->enrollment_tokens_create_enrollment_token: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
body = JCAPIv2::JumpcloudGoogleEmmCreateEnterpriseRequest.new # JumpcloudGoogleEmmCreateEnterpriseRequest | 


begin
  #Create a Google Enterprise
  result = api_instance.enterprises_create_enterprise(body)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->enterprises_create_enterprise: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
enterprise_id = 'B' # String | 


begin
  #Delete a Google Enterprise
  result = api_instance.enterprises_delete_enterprise(enterprise_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->enterprises_delete_enterprise: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
enterprise_id = 'B' # String | 


begin
  #Test connection with Google
  result = api_instance.enterprises_get_connection_status(enterprise_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->enterprises_get_connection_status: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
opts = { 
  limit: '100', # String | The number of records to return at once. Limited to 100.
  skip: '0' # String | The offset into the records to return.
}

begin
  #List Google Enterprises
  result = api_instance.enterprises_list_enterprises(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->enterprises_list_enterprises: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
body = JCAPIv2::EnterprisesEnterpriseIdBody.new # EnterprisesEnterpriseIdBody | 
enterprise_id = 'B' # String | 


begin
  #Update a Google Enterprise
  result = api_instance.enterprises_patch_enterprise(body, enterprise_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->enterprises_patch_enterprise: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new

begin
  #Get a Signup URL to enroll Google enterprise
  result = api_instance.signup_urls_create
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->signup_urls_create: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GoogleEMMApi.new
body = JCAPIv2::JumpcloudGoogleEmmCreateWebTokenRequest.new # JumpcloudGoogleEmmCreateWebTokenRequest | 


begin
  #Get a web token to render Google Play iFrame
  result = api_instance.web_tokens_create_web_token(body)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GoogleEMMApi->web_tokens_create_web_token: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
activedirectory_id = 'activedirectory_id_example' # String | 
targets = ['targets_example'] # Array<String> | Targets which a \"active_directory\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of an Active Directory instance
  result = api_instance.graph_active_directory_associations_list(activedirectory_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_active_directory_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
activedirectory_id = 'activedirectory_id_example' # String | 
opts = { 
  body: JCAPIv2::GraphOperationActiveDirectory.new, # GraphOperationActiveDirectory | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of an Active Directory instance
  api_instance.graph_active_directory_associations_post(activedirectory_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_active_directory_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
activedirectory_id = 'activedirectory_id_example' # String | ObjectID of the Active Directory instance.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Users bound to an Active Directory instance
  result = api_instance.graph_active_directory_traverse_user(activedirectory_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_active_directory_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
activedirectory_id = 'activedirectory_id_example' # String | ObjectID of the Active Directory instance.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to an Active Directory instance
  result = api_instance.graph_active_directory_traverse_user_group(activedirectory_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_active_directory_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
targets = ['targets_example'] # Array<String> | Targets which a \"application\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of an Application
  result = api_instance.graph_application_associations_list(application_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_application_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  body: JCAPIv2::GraphOperationApplication.new, # GraphOperationApplication | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of an Application
  api_instance.graph_application_associations_post(application_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_application_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to an Application
  result = api_instance.graph_application_traverse_user(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_application_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to an Application
  result = api_instance.graph_application_traverse_user_group(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_application_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
command_id = 'command_id_example' # String | ObjectID of the Command.
targets = ['targets_example'] # Array<String> | Targets which a \"command\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a Command
  result = api_instance.graph_command_associations_list(command_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_command_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
command_id = 'command_id_example' # String | ObjectID of the Command.
opts = { 
  body: JCAPIv2::GraphOperationCommand.new, # GraphOperationCommand | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a Command
  api_instance.graph_command_associations_post(command_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_command_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
command_id = 'command_id_example' # String | ObjectID of the Command.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a Command
  result = api_instance.graph_command_traverse_system(command_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_command_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
command_id = 'command_id_example' # String | ObjectID of the Command.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to a Command
  result = api_instance.graph_command_traverse_system_group(command_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_command_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
gsuite_id = 'gsuite_id_example' # String | ObjectID of the G Suite instance.
targets = ['targets_example'] # Array<String> | Targets which a \"g_suite\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a G Suite instance
  result = api_instance.graph_g_suite_associations_list(gsuite_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_g_suite_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
gsuite_id = 'gsuite_id_example' # String | ObjectID of the G Suite instance.
opts = { 
  body: JCAPIv2::GraphOperationGSuite.new, # GraphOperationGSuite | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a G Suite instance
  api_instance.graph_g_suite_associations_post(gsuite_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_g_suite_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
gsuite_id = 'gsuite_id_example' # String | ObjectID of the G Suite instance.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a G Suite instance
  result = api_instance.graph_g_suite_traverse_user(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_g_suite_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
gsuite_id = 'gsuite_id_example' # String | ObjectID of the G Suite instance.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a G Suite instance
  result = api_instance.graph_g_suite_traverse_user_group(gsuite_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_g_suite_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
ldapserver_id = 'ldapserver_id_example' # String | ObjectID of the LDAP Server.
targets = ['targets_example'] # Array<String> | Targets which a \"ldap_server\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a LDAP Server
  result = api_instance.graph_ldap_server_associations_list(ldapserver_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_ldap_server_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
ldapserver_id = 'ldapserver_id_example' # String | ObjectID of the LDAP Server.
opts = { 
  body: JCAPIv2::GraphOperationLdapServer.new, # GraphOperationLdapServer | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a LDAP Server
  api_instance.graph_ldap_server_associations_post(ldapserver_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_ldap_server_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
ldapserver_id = 'ldapserver_id_example' # String | ObjectID of the LDAP Server.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a LDAP Server
  result = api_instance.graph_ldap_server_traverse_user(ldapserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_ldap_server_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
ldapserver_id = 'ldapserver_id_example' # String | ObjectID of the LDAP Server.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a LDAP Server
  result = api_instance.graph_ldap_server_traverse_user_group(ldapserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_ldap_server_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 instance.
targets = ['targets_example'] # Array<String> | Targets which a \"office_365\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of an Office 365 instance
  result = api_instance.graph_office365_associations_list(office365_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_office365_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 instance.
opts = { 
  body: JCAPIv2::GraphOperationOffice365.new, # GraphOperationOffice365 | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of an Office 365 instance
  api_instance.graph_office365_associations_post(office365_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_office365_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 suite.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to an Office 365 instance
  result = api_instance.graph_office365_traverse_user(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_office365_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 suite.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to an Office 365 instance
  result = api_instance.graph_office365_traverse_user_group(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_office365_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
policy_id = 'policy_id_example' # String | ObjectID of the Policy.
targets = ['targets_example'] # Array<String> | Targets which a \"policy\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a Policy
  result = api_instance.graph_policy_associations_list(policy_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
policy_id = 'policy_id_example' # String | ObjectID of the Policy.
opts = { 
  body: JCAPIv2::GraphOperationPolicy.new, # GraphOperationPolicy | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a Policy
  api_instance.graph_policy_associations_post(policy_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
targets = ['targets_example'] # Array<String> | Targets which a \"policy_group\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a Policy Group.
  result = api_instance.graph_policy_group_associations_list(group_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_group_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  body: JCAPIv2::GraphOperationPolicyGroup.new, # GraphOperationPolicyGroup | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a Policy Group
  api_instance.graph_policy_group_associations_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_group_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the members of a Policy Group
  result = api_instance.graph_policy_group_members_list(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_group_members_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  body: JCAPIv2::GraphOperationPolicyGroupMember.new, # GraphOperationPolicyGroupMember | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the members of a Policy Group
  api_instance.graph_policy_group_members_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_group_members_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the Policy Group's membership
  result = api_instance.graph_policy_group_membership(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_group_membership: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a Policy Group
  result = api_instance.graph_policy_group_traverse_system(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_group_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to Policy Groups
  result = api_instance.graph_policy_group_traverse_system_group(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_group_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
policy_id = 'policy_id_example' # String | ObjectID of the Policy.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the parent Groups of a Policy
  result = api_instance.graph_policy_member_of(policy_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_member_of: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
policy_id = 'policy_id_example' # String | ObjectID of the Command.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a Policy
  result = api_instance.graph_policy_traverse_system(policy_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
policy_id = 'policy_id_example' # String | ObjectID of the Command.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to a Policy
  result = api_instance.graph_policy_traverse_system_group(policy_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_policy_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
radiusserver_id = 'radiusserver_id_example' # String | ObjectID of the Radius Server.
targets = ['targets_example'] # Array<String> | Targets which a \"radius_server\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a RADIUS  Server
  result = api_instance.graph_radius_server_associations_list(radiusserver_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_radius_server_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
radiusserver_id = 'radiusserver_id_example' # String | ObjectID of the Radius Server.
opts = { 
  body: JCAPIv2::GraphOperationRadiusServer.new, # GraphOperationRadiusServer | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a RADIUS Server
  api_instance.graph_radius_server_associations_post(radiusserver_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_radius_server_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
radiusserver_id = 'radiusserver_id_example' # String | ObjectID of the Radius Server.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a RADIUS  Server
  result = api_instance.graph_radius_server_traverse_user(radiusserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_radius_server_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
radiusserver_id = 'radiusserver_id_example' # String | ObjectID of the Radius Server.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a RADIUS  Server
  result = api_instance.graph_radius_server_traverse_user_group(radiusserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_radius_server_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
targets = ['targets_example'] # Array<String> | Targets which a \"software_app\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a Software Application
  result = api_instance.graph_softwareapps_associations_list(software_app_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_softwareapps_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
opts = { 
  body: JCAPIv2::GraphOperationSoftwareApp.new, # GraphOperationSoftwareApp | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a software application.
  api_instance.graph_softwareapps_associations_post(software_app_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_softwareapps_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a Software App.
  result = api_instance.graph_softwareapps_traverse_system(software_app_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_softwareapps_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to a Software App.
  result = api_instance.graph_softwareapps_traverse_system_group(software_app_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_softwareapps_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
targets = ['targets_example'] # Array<String> | Targets which a \"system\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a System
  result = api_instance.graph_system_associations_list(system_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  body: JCAPIv2::GraphOperationSystem.new, # GraphOperationSystem | 
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage associations of a System
  api_instance.graph_system_associations_post(system_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
targets = ['targets_example'] # Array<String> | Targets which a \"system_group\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a System Group
  result = api_instance.graph_system_group_associations_list(group_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  body: JCAPIv2::GraphOperationSystemGroup.new, # GraphOperationSystemGroup | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a System Group
  api_instance.graph_system_group_associations_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the members of a System Group
  result = api_instance.graph_system_group_members_list(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_members_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  body: JCAPIv2::GraphOperationSystemGroupMember.new, # GraphOperationSystemGroupMember | 
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the members of a System Group
  api_instance.graph_system_group_members_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_members_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the System Group's membership
  result = api_instance.graph_system_group_membership(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_membership: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  details: 'details_example' # String | This will provide detail descriptive response for the request.
}

begin
  #List the Commands bound to a System Group
  result = api_instance.graph_system_group_traverse_command(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_traverse_command: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Policies bound to a System Group
  result = api_instance.graph_system_group_traverse_policy(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_traverse_policy: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Policy Groups bound to a System Group
  result = api_instance.graph_system_group_traverse_policy_group(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_traverse_policy_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a System Group
  result = api_instance.graph_system_group_traverse_user(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a System Group
  result = api_instance.graph_system_group_traverse_user_group(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_group_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the parent Groups of a System
  result = api_instance.graph_system_member_of(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_member_of: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  details: 'details_example' # String | This will provide detail descriptive response for the request.
}

begin
  #List the Commands bound to a System
  result = api_instance.graph_system_traverse_command(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_traverse_command: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Policies bound to a System
  result = api_instance.graph_system_traverse_policy(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_traverse_policy: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Policy Groups bound to a System
  result = api_instance.graph_system_traverse_policy_group(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_traverse_policy_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a System
  result = api_instance.graph_system_traverse_user(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a System
  result = api_instance.graph_system_traverse_user_group(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_system_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
targets = ['targets_example'] # Array<String> | Targets which a \"user\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a User
  result = api_instance.graph_user_associations_list(user_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  body: JCAPIv2::GraphOperationUser.new, # GraphOperationUser | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a User
  api_instance.graph_user_associations_post(user_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
targets = ['targets_example'] # Array<String> | Targets which a \"user_group\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a User Group.
  result = api_instance.graph_user_group_associations_list(group_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  body: JCAPIv2::GraphOperationUserGroup.new, # GraphOperationUserGroup | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a User Group
  api_instance.graph_user_group_associations_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the members of a User Group
  result = api_instance.graph_user_group_members_list(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_members_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  body: JCAPIv2::GraphOperationUserGroupMember.new, # GraphOperationUserGroupMember | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the members of a User Group
  api_instance.graph_user_group_members_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_members_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the User Group's membership
  result = api_instance.graph_user_group_membership(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_membership: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Active Directories bound to a User Group
  result = api_instance.graph_user_group_traverse_active_directory(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_active_directory: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Applications bound to a User Group
  result = api_instance.graph_user_group_traverse_application(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_application: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Directories bound to a User Group
  result = api_instance.graph_user_group_traverse_directory(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_directory: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the G Suite instances bound to a User Group
  result = api_instance.graph_user_group_traverse_g_suite(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_g_suite: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the LDAP Servers bound to a User Group
  result = api_instance.graph_user_group_traverse_ldap_server(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_ldap_server: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Office 365 instances bound to a User Group
  result = api_instance.graph_user_group_traverse_office365(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_office365: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the RADIUS Servers bound to a User Group
  result = api_instance.graph_user_group_traverse_radius_server(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_radius_server: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a User Group
  result = api_instance.graph_user_group_traverse_system(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to User Groups
  result = api_instance.graph_user_group_traverse_system_group(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_group_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the parent Groups of a User
  result = api_instance.graph_user_member_of(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_member_of: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Active Directory instances bound to a User
  result = api_instance.graph_user_traverse_active_directory(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_active_directory: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Applications bound to a User
  result = api_instance.graph_user_traverse_application(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_application: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Directories bound to a User
  result = api_instance.graph_user_traverse_directory(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_directory: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the G Suite instances bound to a User
  result = api_instance.graph_user_traverse_g_suite(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_g_suite: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the LDAP servers bound to a User
  result = api_instance.graph_user_traverse_ldap_server(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_ldap_server: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Office 365 instances bound to a User
  result = api_instance.graph_user_traverse_office365(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_office365: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the RADIUS Servers bound to a User
  result = api_instance.graph_user_traverse_radius_server(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_radius_server: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a User
  result = api_instance.graph_user_traverse_system(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to a User
  result = api_instance.graph_user_traverse_system_group(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->graph_user_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GraphApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the policy statuses for a system
  result = api_instance.policystatuses_systems_list(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GraphApi->policystatuses_systems_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::GroupsApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  x_unfiltered_total_count: 56 # Integer | If provided in the request with any non-empty value, this header will be returned on the response populated with the total count of objects without filters taken into account
}

begin
  #List All Groups
  result = api_instance.groups_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling GroupsApi->groups_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::IPListsApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete an IP list
  result = api_instance.iplists_delete(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling IPListsApi->iplists_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::IPListsApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get an IP list
  result = api_instance.iplists_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling IPListsApi->iplists_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::IPListsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  x_total_count: 56, # Integer | 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List IP Lists
  result = api_instance.iplists_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling IPListsApi->iplists_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::IPListsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::IPListRequest.new, # IPListRequest | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update an IP list
  result = api_instance.iplists_patch(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling IPListsApi->iplists_patch: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::IPListsApi.new
opts = { 
  body: JCAPIv2::IPListRequest.new, # IPListRequest | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create IP List
  result = api_instance.iplists_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling IPListsApi->iplists_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::IPListsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::IPListRequest.new, # IPListRequest | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Replace an IP list
  result = api_instance.iplists_put(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling IPListsApi->iplists_put: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ImageApi.new
application_id = 'application_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete application image
  api_instance.applications_delete_logo(application_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ImageApi->applications_delete_logo: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::LDAPServersApi.new
ldapserver_id = 'ldapserver_id_example' # String | ObjectID of the LDAP Server.
targets = ['targets_example'] # Array<String> | Targets which a \"ldap_server\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a LDAP Server
  result = api_instance.graph_ldap_server_associations_list(ldapserver_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->graph_ldap_server_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::LDAPServersApi.new
ldapserver_id = 'ldapserver_id_example' # String | ObjectID of the LDAP Server.
opts = { 
  body: JCAPIv2::GraphOperationLdapServer.new, # GraphOperationLdapServer | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a LDAP Server
  api_instance.graph_ldap_server_associations_post(ldapserver_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->graph_ldap_server_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::LDAPServersApi.new
ldapserver_id = 'ldapserver_id_example' # String | ObjectID of the LDAP Server.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a LDAP Server
  result = api_instance.graph_ldap_server_traverse_user(ldapserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->graph_ldap_server_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::LDAPServersApi.new
ldapserver_id = 'ldapserver_id_example' # String | ObjectID of the LDAP Server.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a LDAP Server
  result = api_instance.graph_ldap_server_traverse_user_group(ldapserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->graph_ldap_server_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::LDAPServersApi.new
id = 'id_example' # String | Unique identifier of the LDAP server.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get LDAP Server
  result = api_instance.ldapservers_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->ldapservers_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::LDAPServersApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List LDAP Servers
  result = api_instance.ldapservers_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->ldapservers_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::LDAPServersApi.new
id = 'id_example' # String | Unique identifier of the LDAP server.
opts = { 
  body: JCAPIv2::LdapserversIdBody.new, # LdapserversIdBody | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update existing LDAP server
  result = api_instance.ldapservers_patch(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LDAPServersApi->ldapservers_patch: #{e}"
end

api_instance = JCAPIv2::LogosApi.new
id = 'id_example' # String | 


begin
  #Get the logo associated with the specified id
  result = api_instance.logos_get(id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling LogosApi->logos_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::AdministratorOrganizationLinkReq.new # AdministratorOrganizationLinkReq | 
}

begin
  #Allow Adminstrator access to an Organization.
  result = api_instance.administrator_organizations_create_by_administrator(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->administrator_organizations_create_by_administrator: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
id = 'id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the association links between an Administrator and Organizations.
  result = api_instance.administrator_organizations_list_by_administrator(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->administrator_organizations_list_by_administrator: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
id = 'id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the association links between an Organization and Administrators.
  result = api_instance.administrator_organizations_list_by_organization(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->administrator_organizations_list_by_organization: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
administrator_id = 'administrator_id_example' # String | 
id = 'id_example' # String | 


begin
  #Remove association between an Administrator and an Organization.
  api_instance.administrator_organizations_remove_by_administrator(administrator_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->administrator_organizations_remove_by_administrator: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Deletes policy group template.
  api_instance.policy_group_templates_delete(provider_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->policy_group_templates_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Gets a provider's policy group template.
  result = api_instance.policy_group_templates_get(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->policy_group_templates_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Retrieve a configured policy template by id.
  result = api_instance.policy_group_templates_get_configured_policy_template(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->policy_group_templates_get_configured_policy_template: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List a provider's policy group templates.
  result = api_instance.policy_group_templates_list(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->policy_group_templates_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List a provider's configured policy templates.
  result = api_instance.policy_group_templates_list_configured_policy_templates(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->policy_group_templates_list_configured_policy_templates: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #Gets the list of members from a policy group template.
  result = api_instance.policy_group_templates_list_members(provider_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->policy_group_templates_list_members: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  body: JCAPIv2::CreateOrganization.new # CreateOrganization | 
}

begin
  #Create Provider Organization
  result = api_instance.provider_organizations_create_org(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->provider_organizations_create_org: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::Organization.new # Organization | 
}

begin
  #Update Provider Organization
  result = api_instance.provider_organizations_update_org(provider_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->provider_organizations_update_org: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'] # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
}

begin
  #Retrieve Provider
  result = api_instance.providers_get_provider(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_get_provider: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  sort_ignore_case: ['sort_ignore_case_example'] # Array<String> | The comma separated fields used to sort the collection, ignoring case. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Provider Administrators
  result = api_instance.providers_list_administrators(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_list_administrators: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  sort_ignore_case: ['sort_ignore_case_example'] # Array<String> | The comma separated fields used to sort the collection, ignoring case. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Provider Organizations
  result = api_instance.providers_list_organizations(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_list_organizations: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  body: JCAPIv2::ProviderAdminReq.new # ProviderAdminReq | 
}

begin
  #Create a new Provider Administrator
  result = api_instance.providers_post_admins(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_post_admins: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #Get all cases (Support/Feature requests) for provider
  result = api_instance.providers_provider_list_case(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_provider_list_case: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Download a provider's invoice.
  result = api_instance.providers_retrieve_invoice(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_retrieve_invoice: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ManagedServiceProviderApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10 # Integer | The number of records to return at once. Limited to 100.
}

begin
  #List a provider's invoices.
  result = api_instance.providers_retrieve_invoices(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ManagedServiceProviderApi->providers_retrieve_invoices: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'B' # String | Id for the specific M365/Azure AD directory sync integration instance.
domain_id = 'B' # String | ObjectID of the domain to be deleted.


begin
  #Delete a domain from an Office 365 instance
  result = api_instance.domains_delete(office365_id, domain_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->domains_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
body = JCAPIv2::Office365IdDomainsBody.new # Office365IdDomainsBody | 
office365_id = 'B' # String | Id for the specific M365/Azure AD directory sync integration instance.


begin
  #Add a domain to an Office 365 instance
  result = api_instance.domains_insert(body, office365_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->domains_insert: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'B' # String | Id for the specific M365/Azure AD directory sync integration instance.
opts = { 
  limit: '100', # String | The number of records to return at once. Limited to 100.
  skip: '0' # String | The offset into the records to return.
}

begin
  #List all domains configured for an Office 365 instance
  result = api_instance.domains_list(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->domains_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 instance.
targets = ['targets_example'] # Array<String> | Targets which a \"office_365\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of an Office 365 instance
  result = api_instance.graph_office365_associations_list(office365_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->graph_office365_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 instance.
opts = { 
  body: JCAPIv2::GraphOperationOffice365.new, # GraphOperationOffice365 | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of an Office 365 instance
  api_instance.graph_office365_associations_post(office365_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->graph_office365_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 suite.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to an Office 365 instance
  result = api_instance.graph_office365_traverse_user(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->graph_office365_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 suite.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to an Office 365 instance
  result = api_instance.graph_office365_traverse_user_group(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->graph_office365_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 instance.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get Office 365 instance
  result = api_instance.office365s_get(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->office365s_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | 
opts = { 
  consistency_level: 'consistency_level_example', # String | Defines the consistency header for O365 requests. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#request-headers
  top: 56, # Integer | Office 365 API maximum number of results per page. See https://docs.microsoft.com/en-us/graph/paging.
  skip_token: 'skip_token_example', # String | Office 365 API token used to access the next page of results. See https://docs.microsoft.com/en-us/graph/paging.
  filter: 'filter_example', # String | Office 365 API filter parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
  search: 'search_example', # String | Office 365 API search parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
  orderby: 'orderby_example', # String | Office 365 API orderby parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
  count: true # BOOLEAN | Office 365 API count parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
}

begin
  #Get a list of users to import from an Office 365 instance
  result = api_instance.office365s_list_import_users(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->office365s_list_import_users: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | ObjectID of the Office 365 instance.
opts = { 
  body: JCAPIv2::Office365.new, # Office365 | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update existing Office 365 instance.
  result = api_instance.office365s_patch(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->office365s_patch: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | 
id = 'id_example' # String | 


begin
  #Deletes a Office 365 translation rule
  api_instance.translation_rules_office365_delete(office365_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->translation_rules_office365_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | 
id = 'id_example' # String | 


begin
  #Gets a specific Office 365 translation rule
  result = api_instance.translation_rules_office365_get(office365_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->translation_rules_office365_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List all the Office 365 Translation Rules
  result = api_instance.translation_rules_office365_list(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->translation_rules_office365_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365Api.new
office365_id = 'office365_id_example' # String | 
opts = { 
  body: JCAPIv2::Office365TranslationRuleRequest.new # Office365TranslationRuleRequest | 
}

begin
  #Create a new Office 365 Translation Rule
  result = api_instance.translation_rules_office365_post(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365Api->translation_rules_office365_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::Office365ImportApi.new
office365_id = 'office365_id_example' # String | 
opts = { 
  consistency_level: 'consistency_level_example', # String | Defines the consistency header for O365 requests. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#request-headers
  top: 56, # Integer | Office 365 API maximum number of results per page. See https://docs.microsoft.com/en-us/graph/paging.
  skip_token: 'skip_token_example', # String | Office 365 API token used to access the next page of results. See https://docs.microsoft.com/en-us/graph/paging.
  filter: 'filter_example', # String | Office 365 API filter parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
  search: 'search_example', # String | Office 365 API search parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
  orderby: 'orderby_example', # String | Office 365 API orderby parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
  count: true # BOOLEAN | Office 365 API count parameter. See https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http#optional-query-parameters.
}

begin
  #Get a list of users to import from an Office 365 instance
  result = api_instance.office365s_list_import_users(office365_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling Office365ImportApi->office365s_list_import_users: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::OrganizationsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::AdministratorOrganizationLinkReq.new # AdministratorOrganizationLinkReq | 
}

begin
  #Allow Adminstrator access to an Organization.
  result = api_instance.administrator_organizations_create_by_administrator(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling OrganizationsApi->administrator_organizations_create_by_administrator: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::OrganizationsApi.new
id = 'id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the association links between an Administrator and Organizations.
  result = api_instance.administrator_organizations_list_by_administrator(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling OrganizationsApi->administrator_organizations_list_by_administrator: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::OrganizationsApi.new
id = 'id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the association links between an Organization and Administrators.
  result = api_instance.administrator_organizations_list_by_organization(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling OrganizationsApi->administrator_organizations_list_by_organization: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::OrganizationsApi.new
administrator_id = 'administrator_id_example' # String | 
id = 'id_example' # String | 


begin
  #Remove association between an Administrator and an Organization.
  api_instance.administrator_organizations_remove_by_administrator(administrator_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling OrganizationsApi->administrator_organizations_remove_by_administrator: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::OrganizationsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #Get all cases (Support/Feature requests) for organization
  result = api_instance.organizations_org_list_cases(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling OrganizationsApi->organizations_org_list_cases: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PasswordManagerApi.new
uuid = 'uuid_example' # String | 


begin
  result = api_instance.device_service_get_device(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PasswordManagerApi->device_service_get_device: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PasswordManagerApi.new
opts = { 
  limit: 56, # Integer | 
  skip: 56, # Integer | 
  sort: 'sort_example', # String | 
  fields: ['fields_example'], # Array<String> | 
  filter: ['filter_example'] # Array<String> | 
}

begin
  result = api_instance.device_service_list_devices(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PasswordManagerApi->device_service_list_devices: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
policy_id = 'policy_id_example' # String | ObjectID of the Policy.
targets = ['targets_example'] # Array<String> | Targets which a \"policy\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a Policy
  result = api_instance.graph_policy_associations_list(policy_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->graph_policy_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
policy_id = 'policy_id_example' # String | ObjectID of the Policy.
opts = { 
  body: JCAPIv2::GraphOperationPolicy.new, # GraphOperationPolicy | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a Policy
  api_instance.graph_policy_associations_post(policy_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->graph_policy_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
policy_id = 'policy_id_example' # String | ObjectID of the Policy.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the parent Groups of a Policy
  result = api_instance.graph_policy_member_of(policy_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->graph_policy_member_of: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
policy_id = 'policy_id_example' # String | ObjectID of the Command.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a Policy
  result = api_instance.graph_policy_traverse_system(policy_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->graph_policy_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
policy_id = 'policy_id_example' # String | ObjectID of the Command.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to a Policy
  result = api_instance.graph_policy_traverse_system_group(policy_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->graph_policy_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
id = 'id_example' # String | ObjectID of the Policy object.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Deletes a Policy
  api_instance.policies_delete(id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policies_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
id = 'id_example' # String | ObjectID of the Policy object.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Gets a specific Policy.
  result = api_instance.policies_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policies_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Lists all the Policies
  result = api_instance.policies_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policies_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
opts = { 
  body: JCAPIv2::PolicyRequest.new, # PolicyRequest | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create a new Policy
  result = api_instance.policies_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policies_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
id = 'id_example' # String | ObjectID of the Policy object.
opts = { 
  body: JCAPIv2::PolicyRequest.new, # PolicyRequest | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update an existing Policy
  result = api_instance.policies_put(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policies_put: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
id = 'id_example' # String | ObjectID of the Policy Result.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get a specific Policy Result.
  result = api_instance.policyresults_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policyresults_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
policy_id = 'policy_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Lists all the policy results of a policy.
  result = api_instance.policyresults_list(policy_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policyresults_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Lists all of the policy results for an organization.
  result = api_instance.policyresults_org_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policyresults_org_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
policy_id = 'policy_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Lists the latest policy results of a policy.
  result = api_instance.policystatuses_policies_list(policy_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policystatuses_policies_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the policy statuses for a system
  result = api_instance.policystatuses_systems_list(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policystatuses_systems_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
id = 'id_example' # String | ObjectID of the Policy Template.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get a specific Policy Template
  result = api_instance.policytemplates_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policytemplates_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PoliciesApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Lists all of the Policy Templates
  result = api_instance.policytemplates_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PoliciesApi->policytemplates_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
targets = ['targets_example'] # Array<String> | Targets which a \"policy_group\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a Policy Group.
  result = api_instance.graph_policy_group_associations_list(group_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupAssociationsApi->graph_policy_group_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  body: JCAPIv2::GraphOperationPolicyGroup.new, # GraphOperationPolicyGroup | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a Policy Group
  api_instance.graph_policy_group_associations_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupAssociationsApi->graph_policy_group_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a Policy Group
  result = api_instance.graph_policy_group_traverse_system(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupAssociationsApi->graph_policy_group_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to Policy Groups
  result = api_instance.graph_policy_group_traverse_system_group(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupAssociationsApi->graph_policy_group_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupMembersMembershipApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the members of a Policy Group
  result = api_instance.graph_policy_group_members_list(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupMembersMembershipApi->graph_policy_group_members_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupMembersMembershipApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  body: JCAPIv2::GraphOperationPolicyGroupMember.new, # GraphOperationPolicyGroupMember | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the members of a Policy Group
  api_instance.graph_policy_group_members_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupMembersMembershipApi->graph_policy_group_members_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupMembersMembershipApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the Policy Group's membership
  result = api_instance.graph_policy_group_membership(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupMembersMembershipApi->graph_policy_group_membership: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupTemplatesApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Deletes policy group template.
  api_instance.policy_group_templates_delete(provider_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupTemplatesApi->policy_group_templates_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupTemplatesApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Gets a provider's policy group template.
  result = api_instance.policy_group_templates_get(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupTemplatesApi->policy_group_templates_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupTemplatesApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Retrieve a configured policy template by id.
  result = api_instance.policy_group_templates_get_configured_policy_template(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupTemplatesApi->policy_group_templates_get_configured_policy_template: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupTemplatesApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List a provider's policy group templates.
  result = api_instance.policy_group_templates_list(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupTemplatesApi->policy_group_templates_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupTemplatesApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List a provider's configured policy templates.
  result = api_instance.policy_group_templates_list_configured_policy_templates(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupTemplatesApi->policy_group_templates_list_configured_policy_templates: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupTemplatesApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #Gets the list of members from a policy group template.
  result = api_instance.policy_group_templates_list_members(provider_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupTemplatesApi->policy_group_templates_list_members: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
targets = ['targets_example'] # Array<String> | Targets which a \"policy_group\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a Policy Group.
  result = api_instance.graph_policy_group_associations_list(group_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupsApi->graph_policy_group_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  body: JCAPIv2::GraphOperationPolicyGroup.new, # GraphOperationPolicyGroup | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a Policy Group
  api_instance.graph_policy_group_associations_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupsApi->graph_policy_group_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the members of a Policy Group
  result = api_instance.graph_policy_group_members_list(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupsApi->graph_policy_group_members_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  body: JCAPIv2::GraphOperationPolicyGroupMember.new, # GraphOperationPolicyGroupMember | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the members of a Policy Group
  api_instance.graph_policy_group_members_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupsApi->graph_policy_group_members_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the Policy Group's membership
  result = api_instance.graph_policy_group_membership(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupsApi->graph_policy_group_membership: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a Policy Group
  result = api_instance.graph_policy_group_traverse_system(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupsApi->graph_policy_group_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to Policy Groups
  result = api_instance.graph_policy_group_traverse_system_group(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupsApi->graph_policy_group_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupsApi.new
id = 'id_example' # String | ObjectID of the Policy Group.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete a Policy Group
  result = api_instance.groups_policy_delete(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupsApi->groups_policy_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupsApi.new
id = 'id_example' # String | ObjectID of the Policy Group.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #View an individual Policy Group details
  result = api_instance.groups_policy_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupsApi->groups_policy_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupsApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List all Policy Groups
  result = api_instance.groups_policy_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupsApi->groups_policy_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupsApi.new
opts = { 
  body: JCAPIv2::PolicyGroupData.new, # PolicyGroupData | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create a new Policy Group
  result = api_instance.groups_policy_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupsApi->groups_policy_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupsApi.new
id = 'id_example' # String | ObjectID of the Policy Group.
opts = { 
  body: JCAPIv2::PolicyGroupData.new, # PolicyGroupData | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update a Policy Group
  result = api_instance.groups_policy_put(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupsApi->groups_policy_put: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicytemplatesApi.new
id = 'id_example' # String | ObjectID of the Policy Template.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get a specific Policy Template
  result = api_instance.policytemplates_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicytemplatesApi->policytemplates_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicytemplatesApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Lists all of the Policy Templates
  result = api_instance.policytemplates_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicytemplatesApi->policytemplates_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  body: JCAPIv2::AutotaskIntegrationReq.new # AutotaskIntegrationReq | 
}

begin
  #Creates a new Autotask integration for the provider
  result = api_instance.autotask_create_configuration(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_create_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Delete Autotask Integration
  api_instance.autotask_delete_configuration(uuid)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_delete_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve Autotask Integration Configuration
  result = api_instance.autotask_get_configuration(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_get_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::AutotaskMappingRequest.new # AutotaskMappingRequest | 
}

begin
  #Create, edit, and/or delete Autotask Mappings
  result = api_instance.autotask_patch_mappings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_patch_mappings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::AutotaskSettingsPatchReq.new # AutotaskSettingsPatchReq | 
}

begin
  #Create, edit, and/or delete Autotask Integration settings
  result = api_instance.autotask_patch_settings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_patch_settings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 


begin
  #Get all Autotask ticketing alert configuration options for a provider
  result = api_instance.autotask_retrieve_all_alert_configuration_options(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_all_alert_configuration_options: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 


begin
  #Get all Autotask ticketing alert configurations for a provider
  result = api_instance.autotask_retrieve_all_alert_configurations(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_all_alert_configurations: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Autotask Companies
  result = api_instance.autotask_retrieve_companies(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_companies: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve Autotask Company Types
  result = api_instance.autotask_retrieve_company_types(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_company_types: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Autotask Contracts
  result = api_instance.autotask_retrieve_contracts(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_contracts: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve Autotask Contract Fields
  result = api_instance.autotask_retrieve_contracts_fields(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_contracts_fields: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Autotask mappings
  result = api_instance.autotask_retrieve_mappings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_mappings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Autotask Contract Services
  result = api_instance.autotask_retrieve_services(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_services: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve Autotask Integration settings
  result = api_instance.autotask_retrieve_settings(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_retrieve_settings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
alert_uuid = 'alert_uuid_example' # String | 
opts = { 
  body: JCAPIv2::AutotaskTicketingAlertConfigurationRequest.new # AutotaskTicketingAlertConfigurationRequest | 
}

begin
  #Update an Autotask ticketing alert's configuration
  result = api_instance.autotask_update_alert_configuration(provider_id, alert_uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_update_alert_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::AutotaskIntegrationPatchReq.new # AutotaskIntegrationPatchReq | 
}

begin
  #Update Autotask Integration configuration
  result = api_instance.autotask_update_configuration(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->autotask_update_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'B' # String | 


begin
  #Retrieve contract for a Provider
  result = api_instance.billing_get_contract(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->billing_get_contract: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'B' # String | 


begin
  #Retrieve billing details for a Provider
  result = api_instance.billing_get_details(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->billing_get_details: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  body: JCAPIv2::ConnectwiseIntegrationReq.new # ConnectwiseIntegrationReq | 
}

begin
  #Creates a new ConnectWise integration for the provider
  result = api_instance.connectwise_create_configuration(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_create_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Delete ConnectWise Integration
  api_instance.connectwise_delete_configuration(uuid)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_delete_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve ConnectWise Integration Configuration
  result = api_instance.connectwise_get_configuration(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_get_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::ConnectWiseMappingRequest.new # ConnectWiseMappingRequest | 
}

begin
  #Create, edit, and/or delete ConnectWise Mappings
  result = api_instance.connectwise_patch_mappings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_patch_mappings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::ConnectWiseSettingsPatchReq.new # ConnectWiseSettingsPatchReq | 
}

begin
  #Create, edit, and/or delete ConnectWise Integration settings
  result = api_instance.connectwise_patch_settings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_patch_settings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
agreement_id = 'agreement_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve ConnectWise Additions
  result = api_instance.connectwise_retrieve_additions(uuid, agreement_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_additions: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve ConnectWise Agreements
  result = api_instance.connectwise_retrieve_agreements(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_agreements: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 


begin
  #Get all ConnectWise ticketing alert configuration options for a provider
  result = api_instance.connectwise_retrieve_all_alert_configuration_options(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_all_alert_configuration_options: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 


begin
  #Get all ConnectWise ticketing alert configurations for a provider
  result = api_instance.connectwise_retrieve_all_alert_configurations(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_all_alert_configurations: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve ConnectWise Companies
  result = api_instance.connectwise_retrieve_companies(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_companies: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve ConnectWise Company Types
  result = api_instance.connectwise_retrieve_company_types(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_company_types: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve ConnectWise mappings
  result = api_instance.connectwise_retrieve_mappings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_mappings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve ConnectWise Integration settings
  result = api_instance.connectwise_retrieve_settings(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_retrieve_settings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
alert_uuid = 'alert_uuid_example' # String | 
opts = { 
  body: JCAPIv2::ConnectWiseTicketingAlertConfigurationRequest.new # ConnectWiseTicketingAlertConfigurationRequest | 
}

begin
  #Update a ConnectWise ticketing alert's configuration
  result = api_instance.connectwise_update_alert_configuration(provider_id, alert_uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_update_alert_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::ConnectwiseIntegrationPatchReq.new # ConnectwiseIntegrationPatchReq | 
}

begin
  #Update ConnectWise Integration configuration
  result = api_instance.connectwise_update_configuration(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->connectwise_update_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 


begin
  #Get all ticketing alerts available for a provider's ticketing integration.
  result = api_instance.mtp_integration_retrieve_alerts(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->mtp_integration_retrieve_alerts: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
integration_type = 'integration_type_example' # String | 


begin
  #Retrieve Recent Integration Sync Errors
  result = api_instance.mtp_integration_retrieve_sync_errors(uuid, integration_type)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->mtp_integration_retrieve_sync_errors: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Deletes policy group template.
  api_instance.policy_group_templates_delete(provider_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->policy_group_templates_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Gets a provider's policy group template.
  result = api_instance.policy_group_templates_get(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->policy_group_templates_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Retrieve a configured policy template by id.
  result = api_instance.policy_group_templates_get_configured_policy_template(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->policy_group_templates_get_configured_policy_template: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List a provider's policy group templates.
  result = api_instance.policy_group_templates_list(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->policy_group_templates_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List a provider's configured policy templates.
  result = api_instance.policy_group_templates_list_configured_policy_templates(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->policy_group_templates_list_configured_policy_templates: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #Gets the list of members from a policy group template.
  result = api_instance.policy_group_templates_list_members(provider_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->policy_group_templates_list_members: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  body: JCAPIv2::CreateOrganization.new # CreateOrganization | 
}

begin
  #Create Provider Organization
  result = api_instance.provider_organizations_create_org(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->provider_organizations_create_org: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::Organization.new # Organization | 
}

begin
  #Update Provider Organization
  result = api_instance.provider_organizations_update_org(provider_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->provider_organizations_update_org: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'] # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
}

begin
  #Retrieve Provider
  result = api_instance.providers_get_provider(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_get_provider: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  sort_ignore_case: ['sort_ignore_case_example'] # Array<String> | The comma separated fields used to sort the collection, ignoring case. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Provider Administrators
  result = api_instance.providers_list_administrators(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_list_administrators: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  sort_ignore_case: ['sort_ignore_case_example'] # Array<String> | The comma separated fields used to sort the collection, ignoring case. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List Provider Organizations
  result = api_instance.providers_list_organizations(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_list_organizations: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  body: JCAPIv2::ProviderAdminReq.new # ProviderAdminReq | 
}

begin
  #Create a new Provider Administrator
  result = api_instance.providers_post_admins(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_post_admins: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #Get all cases (Support/Feature requests) for provider
  result = api_instance.providers_provider_list_case(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_provider_list_case: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Delete Provider Administrator
  api_instance.providers_remove_administrator(provider_id, id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_remove_administrator: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Integrations for Provider
  result = api_instance.providers_retrieve_integrations(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_retrieve_integrations: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
id = 'id_example' # String | 


begin
  #Download a provider's invoice.
  result = api_instance.providers_retrieve_invoice(provider_id, id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_retrieve_invoice: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  limit: 10 # Integer | The number of records to return at once. Limited to 100.
}

begin
  #List a provider's invoices.
  result = api_instance.providers_retrieve_invoices(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->providers_retrieve_invoices: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
opts = { 
  body: JCAPIv2::SyncroIntegrationReq.new # SyncroIntegrationReq | 
}

begin
  #Creates a new Syncro integration for the provider
  result = api_instance.syncro_create_configuration(provider_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_create_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Delete Syncro Integration
  api_instance.syncro_delete_configuration(uuid)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_delete_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve Syncro Integration Configuration
  result = api_instance.syncro_get_configuration(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_get_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::SyncroMappingRequest.new # SyncroMappingRequest | 
}

begin
  #Create, edit, and/or delete Syncro Mappings
  result = api_instance.syncro_patch_mappings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_patch_mappings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::SyncroSettingsPatchReq.new # SyncroSettingsPatchReq | 
}

begin
  #Create, edit, and/or delete Syncro Integration settings
  result = api_instance.syncro_patch_settings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_patch_settings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 


begin
  #Get all Syncro ticketing alert configuration options for a provider
  result = api_instance.syncro_retrieve_all_alert_configuration_options(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_retrieve_all_alert_configuration_options: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 


begin
  #Get all Syncro ticketing alert configurations for a provider
  result = api_instance.syncro_retrieve_all_alert_configurations(provider_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_retrieve_all_alert_configurations: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Syncro billing mappings dependencies
  result = api_instance.syncro_retrieve_billing_mapping_configuration_options(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_retrieve_billing_mapping_configuration_options: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Syncro Companies
  result = api_instance.syncro_retrieve_companies(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_retrieve_companies: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Retrieve Syncro mappings
  result = api_instance.syncro_retrieve_mappings(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_retrieve_mappings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 


begin
  #Retrieve Syncro Integration settings
  result = api_instance.syncro_retrieve_settings(uuid)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_retrieve_settings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
provider_id = 'provider_id_example' # String | 
alert_uuid = 'alert_uuid_example' # String | 
opts = { 
  body: JCAPIv2::SyncroTicketingAlertConfigurationRequest.new # SyncroTicketingAlertConfigurationRequest | 
}

begin
  #Update a Syncro ticketing alert's configuration
  result = api_instance.syncro_update_alert_configuration(provider_id, alert_uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_update_alert_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::ProvidersApi.new
uuid = 'uuid_example' # String | 
opts = { 
  body: JCAPIv2::SyncroIntegrationPatchReq.new # SyncroIntegrationPatchReq | 
}

begin
  #Update Syncro Integration configuration
  result = api_instance.syncro_update_configuration(uuid, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling ProvidersApi->syncro_update_configuration: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::RADIUSServersApi.new
radiusserver_id = 'radiusserver_id_example' # String | ObjectID of the Radius Server.
targets = ['targets_example'] # Array<String> | Targets which a \"radius_server\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a RADIUS  Server
  result = api_instance.graph_radius_server_associations_list(radiusserver_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling RADIUSServersApi->graph_radius_server_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::RADIUSServersApi.new
radiusserver_id = 'radiusserver_id_example' # String | ObjectID of the Radius Server.
opts = { 
  body: JCAPIv2::GraphOperationRadiusServer.new, # GraphOperationRadiusServer | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a RADIUS Server
  api_instance.graph_radius_server_associations_post(radiusserver_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling RADIUSServersApi->graph_radius_server_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::RADIUSServersApi.new
radiusserver_id = 'radiusserver_id_example' # String | ObjectID of the Radius Server.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a RADIUS  Server
  result = api_instance.graph_radius_server_traverse_user(radiusserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling RADIUSServersApi->graph_radius_server_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::RADIUSServersApi.new
radiusserver_id = 'radiusserver_id_example' # String | ObjectID of the Radius Server.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a RADIUS  Server
  result = api_instance.graph_radius_server_traverse_user_group(radiusserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling RADIUSServersApi->graph_radius_server_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SCIMImportApi.new
application_id = 'application_id_example' # String | ObjectID of the Application.
opts = { 
  filter: 'filter_example', # String | Filter users by a search term
  query: 'query_example', # String | URL query to merge with the service provider request
  sort: 'sort_example', # String | Sort users by supported fields
  sort_order: 'asc', # String | 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Get a list of users to import from an Application IdM service provider
  result = api_instance.import_users(application_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SCIMImportApi->import_users: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SambaDomainsApi.new
ldapserver_id = 'ldapserver_id_example' # String | Unique identifier of the LDAP server.
id = 'id_example' # String | Unique identifier of the samba domain.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete Samba Domain
  result = api_instance.ldapservers_samba_domains_delete(ldapserver_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SambaDomainsApi.new
ldapserver_id = 'ldapserver_id_example' # String | Unique identifier of the LDAP server.
id = 'id_example' # String | Unique identifier of the samba domain.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get Samba Domain
  result = api_instance.ldapservers_samba_domains_get(ldapserver_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SambaDomainsApi.new
ldapserver_id = 'ldapserver_id_example' # String | Unique identifier of the LDAP server.
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Samba Domains
  result = api_instance.ldapservers_samba_domains_list(ldapserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SambaDomainsApi.new
ldapserver_id = 'ldapserver_id_example' # String | Unique identifier of the LDAP server.
opts = { 
  body: JCAPIv2::SambaDomain.new, # SambaDomain | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create Samba Domain
  result = api_instance.ldapservers_samba_domains_post(ldapserver_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SambaDomainsApi.new
ldapserver_id = 'ldapserver_id_example' # String | Unique identifier of the LDAP server.
id = 'id_example' # String | Unique identifier of the samba domain.
opts = { 
  body: JCAPIv2::SambaDomain.new # SambaDomain | 
}

begin
  #Update Samba Domain
  result = api_instance.ldapservers_samba_domains_put(ldapserver_id, id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SambaDomainsApi->ldapservers_samba_domains_put: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
targets = ['targets_example'] # Array<String> | Targets which a \"software_app\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a Software Application
  result = api_instance.graph_softwareapps_associations_list(software_app_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->graph_softwareapps_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
opts = { 
  body: JCAPIv2::GraphOperationSoftwareApp.new, # GraphOperationSoftwareApp | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a software application.
  api_instance.graph_softwareapps_associations_post(software_app_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->graph_softwareapps_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a Software App.
  result = api_instance.graph_softwareapps_traverse_system(software_app_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->graph_softwareapps_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to a Software App.
  result = api_instance.graph_softwareapps_traverse_system_group(software_app_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->graph_softwareapps_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
software_app_id = 'software_app_id_example' # String | ObjectID of the Software App.
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Get the status of the provided Software Application
  result = api_instance.software_app_statuses_list(software_app_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_app_statuses_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete a configured Software Application
  api_instance.software_apps_delete(id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Retrieve a configured Software Application.
  result = api_instance.software_apps_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #Get all configured Software Applications.
  result = api_instance.software_apps_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
opts = { 
  body: JCAPIv2::SoftwareApp.new, # SoftwareApp | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create a Software Application that will be managed by JumpCloud.
  result = api_instance.software_apps_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
software_app_id = 'software_app_id_example' # String | 


begin
  #Reclaim Licenses for a Software Application.
  result = api_instance.software_apps_reclaim_licenses(software_app_id)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_reclaim_licenses: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
body = JCAPIv2::SoftwareAppsRetryInstallationRequest.new # SoftwareAppsRetryInstallationRequest | 
software_app_id = 'software_app_id_example' # String | 


begin
  #Retry Installation for a Software Application
  api_instance.software_apps_retry_installation(body, software_app_id)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_retry_installation: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::SoftwareApp.new, # SoftwareApp | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update a Software Application Configuration.
  result = api_instance.software_apps_update(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->software_apps_update: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SoftwareAppsApi.new
body = JCAPIv2::JumpcloudPackageValidatorValidateApplicationInstallPackageRequest.new # JumpcloudPackageValidatorValidateApplicationInstallPackageRequest | 


begin
  #Validate Installation Packages
  result = api_instance.validator_validate_application_install_package(body)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SoftwareAppsApi->validator_validate_application_install_package: #{e}"
end

api_instance = JCAPIv2::SubscriptionsApi.new

begin
  #Lists all the Pricing & Packaging Subscriptions
  result = api_instance.subscriptions_get
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SubscriptionsApi->subscriptions_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
targets = ['targets_example'] # Array<String> | Targets which a \"system_group\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a System Group
  result = api_instance.graph_system_group_associations_list(group_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupAssociationsApi->graph_system_group_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  body: JCAPIv2::GraphOperationSystemGroup.new, # GraphOperationSystemGroup | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a System Group
  api_instance.graph_system_group_associations_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupAssociationsApi->graph_system_group_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  details: 'details_example' # String | This will provide detail descriptive response for the request.
}

begin
  #List the Commands bound to a System Group
  result = api_instance.graph_system_group_traverse_command(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupAssociationsApi->graph_system_group_traverse_command: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Policies bound to a System Group
  result = api_instance.graph_system_group_traverse_policy(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupAssociationsApi->graph_system_group_traverse_policy: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Policy Groups bound to a System Group
  result = api_instance.graph_system_group_traverse_policy_group(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupAssociationsApi->graph_system_group_traverse_policy_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a System Group
  result = api_instance.graph_system_group_traverse_user(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupAssociationsApi->graph_system_group_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a System Group
  result = api_instance.graph_system_group_traverse_user_group(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupAssociationsApi->graph_system_group_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupMembersMembershipApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the members of a System Group
  result = api_instance.graph_system_group_members_list(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupMembersMembershipApi->graph_system_group_members_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupMembersMembershipApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  body: JCAPIv2::GraphOperationSystemGroupMember.new, # GraphOperationSystemGroupMember | 
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the members of a System Group
  api_instance.graph_system_group_members_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupMembersMembershipApi->graph_system_group_members_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupMembersMembershipApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the System Group's membership
  result = api_instance.graph_system_group_membership(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupMembersMembershipApi->graph_system_group_membership: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
targets = ['targets_example'] # Array<String> | Targets which a \"system_group\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a System Group
  result = api_instance.graph_system_group_associations_list(group_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  body: JCAPIv2::GraphOperationSystemGroup.new, # GraphOperationSystemGroup | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a System Group
  api_instance.graph_system_group_associations_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the members of a System Group
  result = api_instance.graph_system_group_members_list(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_members_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  body: JCAPIv2::GraphOperationSystemGroupMember.new, # GraphOperationSystemGroupMember | 
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the members of a System Group
  api_instance.graph_system_group_members_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_members_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the System Group's membership
  result = api_instance.graph_system_group_membership(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_membership: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Policies bound to a System Group
  result = api_instance.graph_system_group_traverse_policy(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_traverse_policy: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Policy Groups bound to a System Group
  result = api_instance.graph_system_group_traverse_policy_group(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_traverse_policy_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a System Group
  result = api_instance.graph_system_group_traverse_user(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the System Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a System Group
  result = api_instance.graph_system_group_traverse_user_group(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->graph_system_group_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
id = 'id_example' # String | ObjectID of the System Group.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete a System Group
  result = api_instance.groups_system_delete(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
id = 'id_example' # String | ObjectID of the System Group.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #View an individual System Group details
  result = api_instance.groups_system_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List all System Groups
  result = api_instance.groups_system_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
opts = { 
  body: JCAPIv2::SystemGroupPost.new, # SystemGroupPost | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create a new System Group
  result = api_instance.groups_system_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
id = 'id_example' # String | ObjectID of the System Group.
opts = { 
  body: JCAPIv2::SystemGroupPut.new, # SystemGroupPut | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update a System Group
  result = api_instance.groups_system_put(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_put: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
group_id = 'group_id_example' # String | ID of the group
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List Suggestions for a System Group
  result = api_instance.groups_system_suggestions_get(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_suggestions_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemGroupsApi.new
body = JCAPIv2::GroupIdSuggestionsBody.new # GroupIdSuggestionsBody | 
group_id = 'group_id_example' # String | ID of the group
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Apply Suggestions for a System Group
  result = api_instance.groups_system_suggestions_post(body, group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemGroupsApi->groups_system_suggestions_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights ALF
  result = api_instance.systeminsights_list_alf(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_alf: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights ALF Exceptions
  result = api_instance.systeminsights_list_alf_exceptions(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_alf_exceptions: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights ALF Explicit Authentications
  result = api_instance.systeminsights_list_alf_explicit_auths(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_alf_explicit_auths: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Application Compatibility Shims
  result = api_instance.systeminsights_list_appcompat_shims(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_appcompat_shims: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Apps
  result = api_instance.systeminsights_list_apps(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_apps: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Authorized Keys
  result = api_instance.systeminsights_list_authorized_keys(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_authorized_keys: #{e}"
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Azure Instance Metadata
  result = api_instance.systeminsights_list_azure_instance_metadata(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_azure_instance_metadata: #{e}"
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Azure Instance Tags
  result = api_instance.systeminsights_list_azure_instance_tags(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_azure_instance_tags: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Battery
  result = api_instance.systeminsights_list_battery(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_battery: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Bitlocker Info
  result = api_instance.systeminsights_list_bitlocker_info(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_bitlocker_info: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Browser Plugins
  result = api_instance.systeminsights_list_browser_plugins(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_browser_plugins: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` Note: You can only filter by `system_id` and `common_name` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Certificates
  result = api_instance.systeminsights_list_certificates(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_certificates: #{e}"
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Chassis Info
  result = api_instance.systeminsights_list_chassis_info(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_chassis_info: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Chrome Extensions
  result = api_instance.systeminsights_list_chrome_extensions(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_chrome_extensions: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Connectivity
  result = api_instance.systeminsights_list_connectivity(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_connectivity: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Crashes
  result = api_instance.systeminsights_list_crashes(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_crashes: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights CUPS Destinations
  result = api_instance.systeminsights_list_cups_destinations(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_cups_destinations: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Disk Encryption
  result = api_instance.systeminsights_list_disk_encryption(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_disk_encryption: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Disk Info
  result = api_instance.systeminsights_list_disk_info(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_disk_info: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights DNS Resolvers
  result = api_instance.systeminsights_list_dns_resolvers(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_dns_resolvers: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Etc Hosts
  result = api_instance.systeminsights_list_etc_hosts(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_etc_hosts: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Firefox Addons
  result = api_instance.systeminsights_list_firefox_addons(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_firefox_addons: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Groups
  result = api_instance.systeminsights_list_groups(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_groups: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights IE Extensions
  result = api_instance.systeminsights_list_ie_extensions(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_ie_extensions: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Interface Addresses
  result = api_instance.systeminsights_list_interface_addresses(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_interface_addresses: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Interface Details
  result = api_instance.systeminsights_list_interface_details(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_interface_details: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Kernel Info
  result = api_instance.systeminsights_list_kernel_info(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_kernel_info: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Launchd
  result = api_instance.systeminsights_list_launchd(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_launchd: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Linux Packages
  result = api_instance.systeminsights_list_linux_packages(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_linux_packages: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Logged-In Users
  result = api_instance.systeminsights_list_logged_in_users(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_logged_in_users: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Logical Drives
  result = api_instance.systeminsights_list_logical_drives(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_logical_drives: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Managed Policies
  result = api_instance.systeminsights_list_managed_policies(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_managed_policies: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Mounts
  result = api_instance.systeminsights_list_mounts(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_mounts: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights OS Version
  result = api_instance.systeminsights_list_os_version(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_os_version: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Patches
  result = api_instance.systeminsights_list_patches(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_patches: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Programs
  result = api_instance.systeminsights_list_programs(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_programs: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Python Packages
  result = api_instance.systeminsights_list_python_packages(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_python_packages: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Safari Extensions
  result = api_instance.systeminsights_list_safari_extensions(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_safari_extensions: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Scheduled Tasks
  result = api_instance.systeminsights_list_scheduled_tasks(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_scheduled_tasks: #{e}"
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Secure Boot
  result = api_instance.systeminsights_list_secureboot(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_secureboot: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Services
  result = api_instance.systeminsights_list_services(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_services: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #LIst System Insights Shadow
  result = api_instance.systeminsights_list_shadow(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_shadow: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Shared Folders
  result = api_instance.systeminsights_list_shared_folders(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_shared_folders: #{e}"
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Shared Resources
  result = api_instance.systeminsights_list_shared_resources(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_shared_resources: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights Sharing Preferences
  result = api_instance.systeminsights_list_sharing_preferences(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_sharing_preferences: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights SIP Config
  result = api_instance.systeminsights_list_sip_config(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_sip_config: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Startup Items
  result = api_instance.systeminsights_list_startup_items(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_startup_items: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` Note: You can only filter by `system_id` and `name` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights System Control
  result = api_instance.systeminsights_list_system_controls(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_system_controls: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights System Info
  result = api_instance.systeminsights_list_system_info(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_system_info: #{e}"
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights TPM Info
  result = api_instance.systeminsights_list_tpm_info(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_tpm_info: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, gte, in. e.g: Filter for single value: `filter=field:gte:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Uptime
  result = api_instance.systeminsights_list_uptime(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_uptime: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights USB Devices
  result = api_instance.systeminsights_list_usb_devices(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_usb_devices: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights User Groups
  result = api_instance.systeminsights_list_user_groups(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_user_groups: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  limit: 10 # Integer | 
}

begin
  #List System Insights User SSH Keys
  result = api_instance.systeminsights_list_user_ssh_keys(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_user_ssh_keys: #{e}"
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights User Assist
  result = api_instance.systeminsights_list_userassist(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_userassist: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Users
  result = api_instance.systeminsights_list_users(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_users: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights WiFi Networks
  result = api_instance.systeminsights_list_wifi_networks(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_wifi_networks: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights WiFi Status
  result = api_instance.systeminsights_list_wifi_status(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_wifi_status: #{e}"
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Windows Security Center
  result = api_instance.systeminsights_list_windows_security_center(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_windows_security_center: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemInsightsApi.new
opts = { 
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. e.g: Sort by single field: `sort=field` Sort descending by single field: `sort=-field` Sort by multiple fields: `sort=field1,-field2,field3` 
  filter: ['filter_example'], # Array<String> | Supported operators are: eq, in. e.g: Filter for single value: `filter=field:eq:value` Filter for any value in a list: (note \"pipe\" character: `|` separating values) `filter=field:in:value1|value2|value3` 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10 # Integer | 
}

begin
  #List System Insights Windows Security Products
  result = api_instance.systeminsights_list_windows_security_products(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemInsightsApi->systeminsights_list_windows_security_products: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemsApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
targets = ['targets_example'] # Array<String> | Targets which a \"system\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a System
  result = api_instance.graph_system_associations_list(system_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsApi->graph_system_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemsApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  body: JCAPIv2::GraphOperationSystem.new, # GraphOperationSystem | 
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage associations of a System
  api_instance.graph_system_associations_post(system_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsApi->graph_system_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemsApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the parent Groups of a System
  result = api_instance.graph_system_member_of(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsApi->graph_system_member_of: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemsApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  details: 'details_example' # String | This will provide detail descriptive response for the request.
}

begin
  #List the Commands bound to a System
  result = api_instance.graph_system_traverse_command(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsApi->graph_system_traverse_command: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemsApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Policies bound to a System
  result = api_instance.graph_system_traverse_policy(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsApi->graph_system_traverse_policy: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemsApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Policy Groups bound to a System
  result = api_instance.graph_system_traverse_policy_group(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsApi->graph_system_traverse_policy_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemsApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Users bound to a System
  result = api_instance.graph_system_traverse_user(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsApi->graph_system_traverse_user: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemsApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  date: 'date_example', # String | Current date header for the System Context API
  authorization: 'authorization_example', # String | Authorization header for the System Context API
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the User Groups bound to a System
  result = api_instance.graph_system_traverse_user_group(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsApi->graph_system_traverse_user_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemsApi.new
system_id = 'system_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get System FDE Key
  result = api_instance.systems_get_fde_key(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsApi->systems_get_fde_key: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemsApi.new
system_id = 'system_id_example' # String | ObjectID of the System.
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'] # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
}

begin
  #List the associated Software Application Statuses of a System
  result = api_instance.systems_list_software_apps_with_statuses(system_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsApi->systems_list_software_apps_with_statuses: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemsOrganizationSettingsApi.new
opts = { 
  organization_object_id: 'B' # String | 
}

begin
  #Get the Sign In with JumpCloud Settings
  result = api_instance.systems_org_settings_get_sign_in_with_jump_cloud_settings(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsOrganizationSettingsApi->systems_org_settings_get_sign_in_with_jump_cloud_settings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::SystemsOrganizationSettingsApi.new
body = JCAPIv2::DevicesSetSignInWithJumpCloudSettingsRequest.new # DevicesSetSignInWithJumpCloudSettingsRequest | 


begin
  #Set the Sign In with JumpCloud Settings
  result = api_instance.systems_org_settings_set_sign_in_with_jump_cloud_settings(body)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling SystemsOrganizationSettingsApi->systems_org_settings_set_sign_in_with_jump_cloud_settings: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
targets = ['targets_example'] # Array<String> | Targets which a \"user_group\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a User Group.
  result = api_instance.graph_user_group_associations_list(group_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  body: JCAPIv2::GraphOperationUserGroup.new, # GraphOperationUserGroup | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a User Group
  api_instance.graph_user_group_associations_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Active Directories bound to a User Group
  result = api_instance.graph_user_group_traverse_active_directory(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_active_directory: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Applications bound to a User Group
  result = api_instance.graph_user_group_traverse_application(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_application: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Directories bound to a User Group
  result = api_instance.graph_user_group_traverse_directory(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_directory: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the G Suite instances bound to a User Group
  result = api_instance.graph_user_group_traverse_g_suite(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_g_suite: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the LDAP Servers bound to a User Group
  result = api_instance.graph_user_group_traverse_ldap_server(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_ldap_server: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Office 365 instances bound to a User Group
  result = api_instance.graph_user_group_traverse_office365(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_office365: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the RADIUS Servers bound to a User Group
  result = api_instance.graph_user_group_traverse_radius_server(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_radius_server: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a User Group
  result = api_instance.graph_user_group_traverse_system(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupAssociationsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to User Groups
  result = api_instance.graph_user_group_traverse_system_group(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupAssociationsApi->graph_user_group_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupMembersMembershipApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the members of a User Group
  result = api_instance.graph_user_group_members_list(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupMembersMembershipApi->graph_user_group_members_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupMembersMembershipApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  body: JCAPIv2::GraphOperationUserGroupMember.new, # GraphOperationUserGroupMember | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the members of a User Group
  api_instance.graph_user_group_members_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupMembersMembershipApi->graph_user_group_members_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupMembersMembershipApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the User Group's membership
  result = api_instance.graph_user_group_membership(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupMembersMembershipApi->graph_user_group_membership: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
targets = ['targets_example'] # Array<String> | Targets which a \"user_group\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a User Group.
  result = api_instance.graph_user_group_associations_list(group_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  body: JCAPIv2::GraphOperationUserGroup.new, # GraphOperationUserGroup | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a User Group
  api_instance.graph_user_group_associations_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the members of a User Group
  result = api_instance.graph_user_group_members_list(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_members_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  body: JCAPIv2::GraphOperationUserGroupMember.new, # GraphOperationUserGroupMember | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the members of a User Group
  api_instance.graph_user_group_members_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_members_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the User Group's membership
  result = api_instance.graph_user_group_membership(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_membership: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Active Directories bound to a User Group
  result = api_instance.graph_user_group_traverse_active_directory(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_traverse_active_directory: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Applications bound to a User Group
  result = api_instance.graph_user_group_traverse_application(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_traverse_application: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Directories bound to a User Group
  result = api_instance.graph_user_group_traverse_directory(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_traverse_directory: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the G Suite instances bound to a User Group
  result = api_instance.graph_user_group_traverse_g_suite(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_traverse_g_suite: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the LDAP Servers bound to a User Group
  result = api_instance.graph_user_group_traverse_ldap_server(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_traverse_ldap_server: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Office 365 instances bound to a User Group
  result = api_instance.graph_user_group_traverse_office365(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_traverse_office365: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the RADIUS Servers bound to a User Group
  result = api_instance.graph_user_group_traverse_radius_server(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_traverse_radius_server: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a User Group
  result = api_instance.graph_user_group_traverse_system(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ObjectID of the User Group.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to User Groups
  result = api_instance.graph_user_group_traverse_system_group(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->graph_user_group_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
id = 'id_example' # String | ObjectID of the User Group.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete a User Group
  result = api_instance.groups_user_delete(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->groups_user_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
id = 'id_example' # String | ObjectID of the User Group.
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #View an individual User Group details
  result = api_instance.groups_user_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->groups_user_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List all User Groups
  result = api_instance.groups_user_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->groups_user_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
opts = { 
  body: JCAPIv2::UserGroupPost.new, # UserGroupPost | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create a new User Group
  result = api_instance.groups_user_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->groups_user_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
id = 'id_example' # String | ObjectID of the User Group.
opts = { 
  body: JCAPIv2::UserGroupPut.new, # UserGroupPut | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update a User Group
  result = api_instance.groups_user_put(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->groups_user_put: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
group_id = 'group_id_example' # String | ID of the group
opts = { 
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List Suggestions for a User Group
  result = api_instance.groups_user_suggestions_get(group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->groups_user_suggestions_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UserGroupsApi.new
body = JCAPIv2::GroupIdSuggestionsBody1.new # GroupIdSuggestionsBody1 | 
group_id = 'group_id_example' # String | ID of the group
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Apply Suggestions for a User Group
  result = api_instance.groups_user_suggestions_post(body, group_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UserGroupsApi->groups_user_suggestions_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
targets = ['targets_example'] # Array<String> | Targets which a \"user\" can be associated to.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the associations of a User
  result = api_instance.graph_user_associations_list(user_id, targets, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_associations_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  body: JCAPIv2::GraphOperationUser.new, # GraphOperationUser | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the associations of a User
  api_instance.graph_user_associations_post(user_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_associations_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List the parent Groups of a User
  result = api_instance.graph_user_member_of(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_member_of: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #List the Active Directory instances bound to a User
  result = api_instance.graph_user_traverse_active_directory(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_active_directory: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Applications bound to a User
  result = api_instance.graph_user_traverse_application(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_application: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Directories bound to a User
  result = api_instance.graph_user_traverse_directory(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_directory: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the G Suite instances bound to a User
  result = api_instance.graph_user_traverse_g_suite(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_g_suite: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the LDAP servers bound to a User
  result = api_instance.graph_user_traverse_ldap_server(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_ldap_server: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Office 365 instances bound to a User
  result = api_instance.graph_user_traverse_office365(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_office365: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the RADIUS Servers bound to a User
  result = api_instance.graph_user_traverse_radius_server(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_radius_server: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the Systems bound to a User
  result = api_instance.graph_user_traverse_system(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_system: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | ObjectID of the User.
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  x_org_id: 'x_org_id_example', # String | Organization identifier that can be obtained from console settings.
  skip: 0, # Integer | The offset into the records to return.
  filter: ['filter_example'] # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
}

begin
  #List the System Groups bound to a User
  result = api_instance.graph_user_traverse_system_group(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->graph_user_traverse_system_group: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | 
push_endpoint_id = 'push_endpoint_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Delete a Push Endpoint associated with a User
  result = api_instance.push_endpoints_delete(user_id, push_endpoint_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->push_endpoints_delete: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | 
push_endpoint_id = 'push_endpoint_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get a push endpoint associated with a User
  result = api_instance.push_endpoints_get(user_id, push_endpoint_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->push_endpoints_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Push Endpoints associated with a User
  result = api_instance.push_endpoints_list(user_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->push_endpoints_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::UsersApi.new
user_id = 'user_id_example' # String | 
push_endpoint_id = 'push_endpoint_id_example' # String | 
opts = { 
  body: JCAPIv2::PushendpointsPushEndpointIdBody.new, # PushendpointsPushEndpointIdBody | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update a push endpoint associated with a User
  result = api_instance.push_endpoints_patch(user_id, push_endpoint_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling UsersApi->push_endpoints_patch: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::WorkdayImportApi.new
workday_id = 'workday_id_example' # String | 
opts = { 
  body: JCAPIv2::AuthInputObject.new, # AuthInputObject | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Authorize Workday
  api_instance.workdays_authorize(workday_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_authorize: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::WorkdayImportApi.new
workday_id = 'workday_id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Deauthorize Workday
  api_instance.workdays_deauthorize(workday_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_deauthorize: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::WorkdayImportApi.new
id = 'id_example' # String | 
opts = { 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Get Workday
  result = api_instance.workdays_get(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_get: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::WorkdayImportApi.new
workday_id = 'workday_id_example' # String | 
opts = { 
  body: [JCAPIv2::BulkUserCreate.new], # Array<BulkUserCreate> | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Workday Import
  result = api_instance.workdays_import(workday_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_import: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::WorkdayImportApi.new
id = 'id_example' # String | 
job_id = 'job_id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Import Results
  result = api_instance.workdays_importresults(id, job_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_importresults: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::WorkdayImportApi.new
opts = { 
  fields: ['fields_example'], # Array<String> | The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  filter: ['filter_example'], # Array<String> | A filter to apply to the query.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** =  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** = Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** `GET /api/v2/groups?filter=name:eq:Test+Group`
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Workdays
  result = api_instance.workdays_list(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_list: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::WorkdayImportApi.new
opts = { 
  body: JCAPIv2::WorkdayInput.new, # WorkdayInput | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Create new Workday
  result = api_instance.workdays_post(opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_post: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::WorkdayImportApi.new
id = 'id_example' # String | 
opts = { 
  body: JCAPIv2::WorkdayFields.new, # WorkdayFields | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Update Workday
  result = api_instance.workdays_put(id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_put: #{e}"
end
# Setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::WorkdayImportApi.new
workday_id = 'workday_id_example' # String | 
opts = { 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: ['sort_example'], # Array<String> | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #List Workday Workers
  result = api_instance.workdays_workers(workday_id, opts)
  p result
rescue JCAPIv2::ApiError => e
  puts "Exception when calling WorkdayImportApi->workdays_workers: #{e}"
end
```

## Documentation for API Endpoints

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*JCAPIv2::ActiveDirectoryApi* | [**activedirectories_agents_delete**](docs/ActiveDirectoryApi.md#activedirectories_agents_delete) | **DELETE** /activedirectories/{activedirectory_id}/agents/{agent_id} | Delete Active Directory Agent
*JCAPIv2::ActiveDirectoryApi* | [**activedirectories_agents_get**](docs/ActiveDirectoryApi.md#activedirectories_agents_get) | **GET** /activedirectories/{activedirectory_id}/agents/{agent_id} | Get Active Directory Agent
*JCAPIv2::ActiveDirectoryApi* | [**activedirectories_agents_list**](docs/ActiveDirectoryApi.md#activedirectories_agents_list) | **GET** /activedirectories/{activedirectory_id}/agents | List Active Directory Agents
*JCAPIv2::ActiveDirectoryApi* | [**activedirectories_agents_post**](docs/ActiveDirectoryApi.md#activedirectories_agents_post) | **POST** /activedirectories/{activedirectory_id}/agents | Create a new Active Directory Agent
*JCAPIv2::ActiveDirectoryApi* | [**activedirectories_delete**](docs/ActiveDirectoryApi.md#activedirectories_delete) | **DELETE** /activedirectories/{id} | Delete an Active Directory
*JCAPIv2::ActiveDirectoryApi* | [**activedirectories_get**](docs/ActiveDirectoryApi.md#activedirectories_get) | **GET** /activedirectories/{id} | Get an Active Directory
*JCAPIv2::ActiveDirectoryApi* | [**activedirectories_list**](docs/ActiveDirectoryApi.md#activedirectories_list) | **GET** /activedirectories | List Active Directories
*JCAPIv2::ActiveDirectoryApi* | [**activedirectories_post**](docs/ActiveDirectoryApi.md#activedirectories_post) | **POST** /activedirectories | Create a new Active Directory
*JCAPIv2::ActiveDirectoryApi* | [**graph_active_directory_associations_list**](docs/ActiveDirectoryApi.md#graph_active_directory_associations_list) | **GET** /activedirectories/{activedirectory_id}/associations | List the associations of an Active Directory instance
*JCAPIv2::ActiveDirectoryApi* | [**graph_active_directory_associations_post**](docs/ActiveDirectoryApi.md#graph_active_directory_associations_post) | **POST** /activedirectories/{activedirectory_id}/associations | Manage the associations of an Active Directory instance
*JCAPIv2::ActiveDirectoryApi* | [**graph_active_directory_traverse_user**](docs/ActiveDirectoryApi.md#graph_active_directory_traverse_user) | **GET** /activedirectories/{activedirectory_id}/users | List the Users bound to an Active Directory instance
*JCAPIv2::ActiveDirectoryApi* | [**graph_active_directory_traverse_user_group**](docs/ActiveDirectoryApi.md#graph_active_directory_traverse_user_group) | **GET** /activedirectories/{activedirectory_id}/usergroups | List the User Groups bound to an Active Directory instance
*JCAPIv2::AdministratorsApi* | [**administrator_organizations_create_by_administrator**](docs/AdministratorsApi.md#administrator_organizations_create_by_administrator) | **POST** /administrators/{id}/organizationlinks | Allow Adminstrator access to an Organization.
*JCAPIv2::AdministratorsApi* | [**administrator_organizations_list_by_administrator**](docs/AdministratorsApi.md#administrator_organizations_list_by_administrator) | **GET** /administrators/{id}/organizationlinks | List the association links between an Administrator and Organizations.
*JCAPIv2::AdministratorsApi* | [**administrator_organizations_list_by_organization**](docs/AdministratorsApi.md#administrator_organizations_list_by_organization) | **GET** /organizations/{id}/administratorlinks | List the association links between an Organization and Administrators.
*JCAPIv2::AdministratorsApi* | [**administrator_organizations_remove_by_administrator**](docs/AdministratorsApi.md#administrator_organizations_remove_by_administrator) | **DELETE** /administrators/{administrator_id}/organizationlinks/{id} | Remove association between an Administrator and an Organization.
*JCAPIv2::AppleMDMApi* | [**applemdms_csrget**](docs/AppleMDMApi.md#applemdms_csrget) | **GET** /applemdms/{apple_mdm_id}/csr | Get Apple MDM CSR Plist
*JCAPIv2::AppleMDMApi* | [**applemdms_delete**](docs/AppleMDMApi.md#applemdms_delete) | **DELETE** /applemdms/{id} | Delete an Apple MDM
*JCAPIv2::AppleMDMApi* | [**applemdms_deletedevice**](docs/AppleMDMApi.md#applemdms_deletedevice) | **DELETE** /applemdms/{apple_mdm_id}/devices/{device_id} | Remove an Apple MDM Device's Enrollment
*JCAPIv2::AppleMDMApi* | [**applemdms_depkeyget**](docs/AppleMDMApi.md#applemdms_depkeyget) | **GET** /applemdms/{apple_mdm_id}/depkey | Get Apple MDM DEP Public Key
*JCAPIv2::AppleMDMApi* | [**applemdms_devices_clear_activation_lock**](docs/AppleMDMApi.md#applemdms_devices_clear_activation_lock) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/clearActivationLock | Clears the Activation Lock for a Device
*JCAPIv2::AppleMDMApi* | [**applemdms_devices_os_update_status**](docs/AppleMDMApi.md#applemdms_devices_os_update_status) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/osUpdateStatus | Request the status of an OS update for a device
*JCAPIv2::AppleMDMApi* | [**applemdms_devices_refresh_activation_lock_information**](docs/AppleMDMApi.md#applemdms_devices_refresh_activation_lock_information) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/refreshActivationLockInformation | Refresh activation lock information for a device
*JCAPIv2::AppleMDMApi* | [**applemdms_devices_schedule_os_update**](docs/AppleMDMApi.md#applemdms_devices_schedule_os_update) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/scheduleOSUpdate | Schedule an OS update for a device
*JCAPIv2::AppleMDMApi* | [**applemdms_deviceserase**](docs/AppleMDMApi.md#applemdms_deviceserase) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/erase | Erase Device
*JCAPIv2::AppleMDMApi* | [**applemdms_deviceslist**](docs/AppleMDMApi.md#applemdms_deviceslist) | **GET** /applemdms/{apple_mdm_id}/devices | List AppleMDM Devices
*JCAPIv2::AppleMDMApi* | [**applemdms_deviceslock**](docs/AppleMDMApi.md#applemdms_deviceslock) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/lock | Lock Device
*JCAPIv2::AppleMDMApi* | [**applemdms_devicesrestart**](docs/AppleMDMApi.md#applemdms_devicesrestart) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/restart | Restart Device
*JCAPIv2::AppleMDMApi* | [**applemdms_devicesshutdown**](docs/AppleMDMApi.md#applemdms_devicesshutdown) | **POST** /applemdms/{apple_mdm_id}/devices/{device_id}/shutdown | Shut Down Device
*JCAPIv2::AppleMDMApi* | [**applemdms_enrollmentprofilesget**](docs/AppleMDMApi.md#applemdms_enrollmentprofilesget) | **GET** /applemdms/{apple_mdm_id}/enrollmentprofiles/{id} | Get an Apple MDM Enrollment Profile
*JCAPIv2::AppleMDMApi* | [**applemdms_enrollmentprofileslist**](docs/AppleMDMApi.md#applemdms_enrollmentprofileslist) | **GET** /applemdms/{apple_mdm_id}/enrollmentprofiles | List Apple MDM Enrollment Profiles
*JCAPIv2::AppleMDMApi* | [**applemdms_getdevice**](docs/AppleMDMApi.md#applemdms_getdevice) | **GET** /applemdms/{apple_mdm_id}/devices/{device_id} | Details of an AppleMDM Device
*JCAPIv2::AppleMDMApi* | [**applemdms_list**](docs/AppleMDMApi.md#applemdms_list) | **GET** /applemdms | List Apple MDMs
*JCAPIv2::AppleMDMApi* | [**applemdms_put**](docs/AppleMDMApi.md#applemdms_put) | **PUT** /applemdms/{id} | Update an Apple MDM
*JCAPIv2::AppleMDMApi* | [**applemdms_refreshdepdevices**](docs/AppleMDMApi.md#applemdms_refreshdepdevices) | **POST** /applemdms/{apple_mdm_id}/refreshdepdevices | Refresh DEP Devices
*JCAPIv2::ApplicationsApi* | [**applications_delete_logo**](docs/ApplicationsApi.md#applications_delete_logo) | **DELETE** /applications/{application_id}/logo | Delete application image
*JCAPIv2::ApplicationsApi* | [**applications_get**](docs/ApplicationsApi.md#applications_get) | **GET** /applications/{application_id} | Get an Application
*JCAPIv2::ApplicationsApi* | [**applications_post_logo**](docs/ApplicationsApi.md#applications_post_logo) | **POST** /applications/{application_id}/logo | Save application logo
*JCAPIv2::ApplicationsApi* | [**graph_application_associations_list**](docs/ApplicationsApi.md#graph_application_associations_list) | **GET** /applications/{application_id}/associations | List the associations of an Application
*JCAPIv2::ApplicationsApi* | [**graph_application_associations_post**](docs/ApplicationsApi.md#graph_application_associations_post) | **POST** /applications/{application_id}/associations | Manage the associations of an Application
*JCAPIv2::ApplicationsApi* | [**graph_application_traverse_user**](docs/ApplicationsApi.md#graph_application_traverse_user) | **GET** /applications/{application_id}/users | List the Users bound to an Application
*JCAPIv2::ApplicationsApi* | [**graph_application_traverse_user_group**](docs/ApplicationsApi.md#graph_application_traverse_user_group) | **GET** /applications/{application_id}/usergroups | List the User Groups bound to an Application
*JCAPIv2::ApplicationsApi* | [**import_create**](docs/ApplicationsApi.md#import_create) | **POST** /applications/{application_id}/import/jobs | Create an import job
*JCAPIv2::ApplicationsApi* | [**import_users**](docs/ApplicationsApi.md#import_users) | **GET** /applications/{application_id}/import/users | Get a list of users to import from an Application IdM service provider
*JCAPIv2::AuthenticationPoliciesApi* | [**authnpolicies_delete**](docs/AuthenticationPoliciesApi.md#authnpolicies_delete) | **DELETE** /authn/policies/{id} | Delete Authentication Policy
*JCAPIv2::AuthenticationPoliciesApi* | [**authnpolicies_get**](docs/AuthenticationPoliciesApi.md#authnpolicies_get) | **GET** /authn/policies/{id} | Get an authentication policy
*JCAPIv2::AuthenticationPoliciesApi* | [**authnpolicies_list**](docs/AuthenticationPoliciesApi.md#authnpolicies_list) | **GET** /authn/policies | List Authentication Policies
*JCAPIv2::AuthenticationPoliciesApi* | [**authnpolicies_patch**](docs/AuthenticationPoliciesApi.md#authnpolicies_patch) | **PATCH** /authn/policies/{id} | Patch Authentication Policy
*JCAPIv2::AuthenticationPoliciesApi* | [**authnpolicies_post**](docs/AuthenticationPoliciesApi.md#authnpolicies_post) | **POST** /authn/policies | Create an Authentication Policy
*JCAPIv2::BulkJobRequestsApi* | [**bulk_user_expires**](docs/BulkJobRequestsApi.md#bulk_user_expires) | **POST** /bulk/user/expires | Bulk Expire Users
*JCAPIv2::BulkJobRequestsApi* | [**bulk_user_states_create**](docs/BulkJobRequestsApi.md#bulk_user_states_create) | **POST** /bulk/userstates | Create Scheduled Userstate Job
*JCAPIv2::BulkJobRequestsApi* | [**bulk_user_states_delete**](docs/BulkJobRequestsApi.md#bulk_user_states_delete) | **DELETE** /bulk/userstates/{id} | Delete Scheduled Userstate Job
*JCAPIv2::BulkJobRequestsApi* | [**bulk_user_states_get_next_scheduled**](docs/BulkJobRequestsApi.md#bulk_user_states_get_next_scheduled) | **GET** /bulk/userstates/eventlist/next | Get the next scheduled state change for a list of users
*JCAPIv2::BulkJobRequestsApi* | [**bulk_user_states_list**](docs/BulkJobRequestsApi.md#bulk_user_states_list) | **GET** /bulk/userstates | List Scheduled Userstate Change Jobs
*JCAPIv2::BulkJobRequestsApi* | [**bulk_user_unlocks**](docs/BulkJobRequestsApi.md#bulk_user_unlocks) | **POST** /bulk/user/unlocks | Bulk Unlock Users
*JCAPIv2::BulkJobRequestsApi* | [**bulk_users_create**](docs/BulkJobRequestsApi.md#bulk_users_create) | **POST** /bulk/users | Bulk Users Create
*JCAPIv2::BulkJobRequestsApi* | [**bulk_users_create_results**](docs/BulkJobRequestsApi.md#bulk_users_create_results) | **GET** /bulk/users/{job_id}/results | List Bulk Users Results
*JCAPIv2::BulkJobRequestsApi* | [**bulk_users_update**](docs/BulkJobRequestsApi.md#bulk_users_update) | **PATCH** /bulk/users | Bulk Users Update
*JCAPIv2::CommandResultsApi* | [**commands_list_results_by_workflow**](docs/CommandResultsApi.md#commands_list_results_by_workflow) | **GET** /commandresult/workflows | List all Command Results by Workflow
*JCAPIv2::CommandsApi* | [**commands_cancel_queued_commands_by_workflow_instance_id**](docs/CommandsApi.md#commands_cancel_queued_commands_by_workflow_instance_id) | **DELETE** /commandqueue/{workflow_instance_id} | Cancel all queued commands for an organization by workflow instance Id
*JCAPIv2::CommandsApi* | [**commands_get_queued_commands_by_workflow**](docs/CommandsApi.md#commands_get_queued_commands_by_workflow) | **GET** /queuedcommand/workflows | Fetch the queued Commands for an Organization
*JCAPIv2::CommandsApi* | [**graph_command_associations_list**](docs/CommandsApi.md#graph_command_associations_list) | **GET** /commands/{command_id}/associations | List the associations of a Command
*JCAPIv2::CommandsApi* | [**graph_command_associations_post**](docs/CommandsApi.md#graph_command_associations_post) | **POST** /commands/{command_id}/associations | Manage the associations of a Command
*JCAPIv2::CommandsApi* | [**graph_command_traverse_system**](docs/CommandsApi.md#graph_command_traverse_system) | **GET** /commands/{command_id}/systems | List the Systems bound to a Command
*JCAPIv2::CommandsApi* | [**graph_command_traverse_system_group**](docs/CommandsApi.md#graph_command_traverse_system_group) | **GET** /commands/{command_id}/systemgroups | List the System Groups bound to a Command
*JCAPIv2::CustomEmailsApi* | [**custom_emails_create**](docs/CustomEmailsApi.md#custom_emails_create) | **POST** /customemails | Create custom email configuration
*JCAPIv2::CustomEmailsApi* | [**custom_emails_destroy**](docs/CustomEmailsApi.md#custom_emails_destroy) | **DELETE** /customemails/{custom_email_type} | Delete custom email configuration
*JCAPIv2::CustomEmailsApi* | [**custom_emails_get_templates**](docs/CustomEmailsApi.md#custom_emails_get_templates) | **GET** /customemail/templates | List custom email templates
*JCAPIv2::CustomEmailsApi* | [**custom_emails_read**](docs/CustomEmailsApi.md#custom_emails_read) | **GET** /customemails/{custom_email_type} | Get custom email configuration
*JCAPIv2::CustomEmailsApi* | [**custom_emails_update**](docs/CustomEmailsApi.md#custom_emails_update) | **PUT** /customemails/{custom_email_type} | Update custom email configuration
*JCAPIv2::DirectoriesApi* | [**directories_list**](docs/DirectoriesApi.md#directories_list) | **GET** /directories | List All Directories
*JCAPIv2::DuoApi* | [**duo_account_delete**](docs/DuoApi.md#duo_account_delete) | **DELETE** /duo/accounts/{id} | Delete a Duo Account
*JCAPIv2::DuoApi* | [**duo_account_get**](docs/DuoApi.md#duo_account_get) | **GET** /duo/accounts/{id} | Get a Duo Acount
*JCAPIv2::DuoApi* | [**duo_account_list**](docs/DuoApi.md#duo_account_list) | **GET** /duo/accounts | List Duo Accounts
*JCAPIv2::DuoApi* | [**duo_account_post**](docs/DuoApi.md#duo_account_post) | **POST** /duo/accounts | Create Duo Account
*JCAPIv2::DuoApi* | [**duo_application_delete**](docs/DuoApi.md#duo_application_delete) | **DELETE** /duo/accounts/{account_id}/applications/{application_id} | Delete a Duo Application
*JCAPIv2::DuoApi* | [**duo_application_get**](docs/DuoApi.md#duo_application_get) | **GET** /duo/accounts/{account_id}/applications/{application_id} | Get a Duo application
*JCAPIv2::DuoApi* | [**duo_application_list**](docs/DuoApi.md#duo_application_list) | **GET** /duo/accounts/{account_id}/applications | List Duo Applications
*JCAPIv2::DuoApi* | [**duo_application_post**](docs/DuoApi.md#duo_application_post) | **POST** /duo/accounts/{account_id}/applications | Create Duo Application
*JCAPIv2::DuoApi* | [**duo_application_update**](docs/DuoApi.md#duo_application_update) | **PUT** /duo/accounts/{account_id}/applications/{application_id} | Update Duo Application
*JCAPIv2::FdeApi* | [**systems_get_fde_key**](docs/FdeApi.md#systems_get_fde_key) | **GET** /systems/{system_id}/fdekey | Get System FDE Key
*JCAPIv2::FeatureTrialsApi* | [**feature_trials_get_feature_trials**](docs/FeatureTrialsApi.md#feature_trials_get_feature_trials) | **GET** /featureTrials/{feature_code} | Check current feature trial usage for a specific feature
*JCAPIv2::GSuiteApi* | [**gapps_domains_delete**](docs/GSuiteApi.md#gapps_domains_delete) | **DELETE** /gsuites/{gsuite_id}/domains/{domainId} | Delete a domain from a Google Workspace integration instance
*JCAPIv2::GSuiteApi* | [**gapps_domains_insert**](docs/GSuiteApi.md#gapps_domains_insert) | **POST** /gsuites/{gsuite_id}/domains | Add a domain to a Google Workspace integration instance
*JCAPIv2::GSuiteApi* | [**gapps_domains_list**](docs/GSuiteApi.md#gapps_domains_list) | **GET** /gsuites/{gsuite_id}/domains | List all domains configured for the Google Workspace integration instance
*JCAPIv2::GSuiteApi* | [**graph_g_suite_associations_list**](docs/GSuiteApi.md#graph_g_suite_associations_list) | **GET** /gsuites/{gsuite_id}/associations | List the associations of a G Suite instance
*JCAPIv2::GSuiteApi* | [**graph_g_suite_associations_post**](docs/GSuiteApi.md#graph_g_suite_associations_post) | **POST** /gsuites/{gsuite_id}/associations | Manage the associations of a G Suite instance
*JCAPIv2::GSuiteApi* | [**graph_g_suite_traverse_user**](docs/GSuiteApi.md#graph_g_suite_traverse_user) | **GET** /gsuites/{gsuite_id}/users | List the Users bound to a G Suite instance
*JCAPIv2::GSuiteApi* | [**graph_g_suite_traverse_user_group**](docs/GSuiteApi.md#graph_g_suite_traverse_user_group) | **GET** /gsuites/{gsuite_id}/usergroups | List the User Groups bound to a G Suite instance
*JCAPIv2::GSuiteApi* | [**gsuites_get**](docs/GSuiteApi.md#gsuites_get) | **GET** /gsuites/{id} | Get G Suite
*JCAPIv2::GSuiteApi* | [**gsuites_list_import_jumpcloud_users**](docs/GSuiteApi.md#gsuites_list_import_jumpcloud_users) | **GET** /gsuites/{gsuite_id}/import/jumpcloudusers | Get a list of users in Jumpcloud format to import from a Google Workspace account.
*JCAPIv2::GSuiteApi* | [**gsuites_list_import_users**](docs/GSuiteApi.md#gsuites_list_import_users) | **GET** /gsuites/{gsuite_id}/import/users | Get a list of users to import from a G Suite instance
*JCAPIv2::GSuiteApi* | [**gsuites_patch**](docs/GSuiteApi.md#gsuites_patch) | **PATCH** /gsuites/{id} | Update existing G Suite
*JCAPIv2::GSuiteApi* | [**translation_rules_g_suite_delete**](docs/GSuiteApi.md#translation_rules_g_suite_delete) | **DELETE** /gsuites/{gsuite_id}/translationrules/{id} | Deletes a G Suite translation rule
*JCAPIv2::GSuiteApi* | [**translation_rules_g_suite_get**](docs/GSuiteApi.md#translation_rules_g_suite_get) | **GET** /gsuites/{gsuite_id}/translationrules/{id} | Gets a specific G Suite translation rule
*JCAPIv2::GSuiteApi* | [**translation_rules_g_suite_list**](docs/GSuiteApi.md#translation_rules_g_suite_list) | **GET** /gsuites/{gsuite_id}/translationrules | List all the G Suite Translation Rules
*JCAPIv2::GSuiteApi* | [**translation_rules_g_suite_post**](docs/GSuiteApi.md#translation_rules_g_suite_post) | **POST** /gsuites/{gsuite_id}/translationrules | Create a new G Suite Translation Rule
*JCAPIv2::GSuiteImportApi* | [**gsuites_list_import_jumpcloud_users**](docs/GSuiteImportApi.md#gsuites_list_import_jumpcloud_users) | **GET** /gsuites/{gsuite_id}/import/jumpcloudusers | Get a list of users in Jumpcloud format to import from a Google Workspace account.
*JCAPIv2::GSuiteImportApi* | [**gsuites_list_import_users**](docs/GSuiteImportApi.md#gsuites_list_import_users) | **GET** /gsuites/{gsuite_id}/import/users | Get a list of users to import from a G Suite instance
*JCAPIv2::GoogleEMMApi* | [**devices_erase_device**](docs/GoogleEMMApi.md#devices_erase_device) | **POST** /google-emm/devices/{deviceId}/erase-device | Erase the Android Device
*JCAPIv2::GoogleEMMApi* | [**devices_get_device**](docs/GoogleEMMApi.md#devices_get_device) | **GET** /google-emm/devices/{deviceId} | Get device
*JCAPIv2::GoogleEMMApi* | [**devices_get_device_android_policy**](docs/GoogleEMMApi.md#devices_get_device_android_policy) | **GET** /google-emm/devices/{deviceId}/policy_results | Get the policy JSON of a device
*JCAPIv2::GoogleEMMApi* | [**devices_list_devices**](docs/GoogleEMMApi.md#devices_list_devices) | **GET** /google-emm/enterprises/{enterpriseObjectId}/devices | List devices
*JCAPIv2::GoogleEMMApi* | [**devices_lock_device**](docs/GoogleEMMApi.md#devices_lock_device) | **POST** /google-emm/devices/{deviceId}/lock | Lock device
*JCAPIv2::GoogleEMMApi* | [**devices_reboot_device**](docs/GoogleEMMApi.md#devices_reboot_device) | **POST** /google-emm/devices/{deviceId}/reboot | Reboot device
*JCAPIv2::GoogleEMMApi* | [**devices_reset_password**](docs/GoogleEMMApi.md#devices_reset_password) | **POST** /google-emm/devices/{deviceId}/resetpassword | Reset Password of a device
*JCAPIv2::GoogleEMMApi* | [**enrollment_tokens_create_enrollment_token**](docs/GoogleEMMApi.md#enrollment_tokens_create_enrollment_token) | **POST** /google-emm/enrollment-tokens | Create an enrollment token
*JCAPIv2::GoogleEMMApi* | [**enterprises_create_enterprise**](docs/GoogleEMMApi.md#enterprises_create_enterprise) | **POST** /google-emm/enterprises | Create a Google Enterprise
*JCAPIv2::GoogleEMMApi* | [**enterprises_delete_enterprise**](docs/GoogleEMMApi.md#enterprises_delete_enterprise) | **DELETE** /google-emm/enterprises/{enterpriseId} | Delete a Google Enterprise
*JCAPIv2::GoogleEMMApi* | [**enterprises_get_connection_status**](docs/GoogleEMMApi.md#enterprises_get_connection_status) | **GET** /google-emm/enterprises/{enterpriseId}/connection-status | Test connection with Google
*JCAPIv2::GoogleEMMApi* | [**enterprises_list_enterprises**](docs/GoogleEMMApi.md#enterprises_list_enterprises) | **GET** /google-emm/enterprises | List Google Enterprises
*JCAPIv2::GoogleEMMApi* | [**enterprises_patch_enterprise**](docs/GoogleEMMApi.md#enterprises_patch_enterprise) | **PATCH** /google-emm/enterprises/{enterpriseId} | Update a Google Enterprise
*JCAPIv2::GoogleEMMApi* | [**signup_urls_create**](docs/GoogleEMMApi.md#signup_urls_create) | **POST** /google-emm/signup-urls | Get a Signup URL to enroll Google enterprise
*JCAPIv2::GoogleEMMApi* | [**web_tokens_create_web_token**](docs/GoogleEMMApi.md#web_tokens_create_web_token) | **POST** /google-emm/web-tokens | Get a web token to render Google Play iFrame
*JCAPIv2::GraphApi* | [**graph_active_directory_associations_list**](docs/GraphApi.md#graph_active_directory_associations_list) | **GET** /activedirectories/{activedirectory_id}/associations | List the associations of an Active Directory instance
*JCAPIv2::GraphApi* | [**graph_active_directory_associations_post**](docs/GraphApi.md#graph_active_directory_associations_post) | **POST** /activedirectories/{activedirectory_id}/associations | Manage the associations of an Active Directory instance
*JCAPIv2::GraphApi* | [**graph_active_directory_traverse_user**](docs/GraphApi.md#graph_active_directory_traverse_user) | **GET** /activedirectories/{activedirectory_id}/users | List the Users bound to an Active Directory instance
*JCAPIv2::GraphApi* | [**graph_active_directory_traverse_user_group**](docs/GraphApi.md#graph_active_directory_traverse_user_group) | **GET** /activedirectories/{activedirectory_id}/usergroups | List the User Groups bound to an Active Directory instance
*JCAPIv2::GraphApi* | [**graph_application_associations_list**](docs/GraphApi.md#graph_application_associations_list) | **GET** /applications/{application_id}/associations | List the associations of an Application
*JCAPIv2::GraphApi* | [**graph_application_associations_post**](docs/GraphApi.md#graph_application_associations_post) | **POST** /applications/{application_id}/associations | Manage the associations of an Application
*JCAPIv2::GraphApi* | [**graph_application_traverse_user**](docs/GraphApi.md#graph_application_traverse_user) | **GET** /applications/{application_id}/users | List the Users bound to an Application
*JCAPIv2::GraphApi* | [**graph_application_traverse_user_group**](docs/GraphApi.md#graph_application_traverse_user_group) | **GET** /applications/{application_id}/usergroups | List the User Groups bound to an Application
*JCAPIv2::GraphApi* | [**graph_command_associations_list**](docs/GraphApi.md#graph_command_associations_list) | **GET** /commands/{command_id}/associations | List the associations of a Command
*JCAPIv2::GraphApi* | [**graph_command_associations_post**](docs/GraphApi.md#graph_command_associations_post) | **POST** /commands/{command_id}/associations | Manage the associations of a Command
*JCAPIv2::GraphApi* | [**graph_command_traverse_system**](docs/GraphApi.md#graph_command_traverse_system) | **GET** /commands/{command_id}/systems | List the Systems bound to a Command
*JCAPIv2::GraphApi* | [**graph_command_traverse_system_group**](docs/GraphApi.md#graph_command_traverse_system_group) | **GET** /commands/{command_id}/systemgroups | List the System Groups bound to a Command
*JCAPIv2::GraphApi* | [**graph_g_suite_associations_list**](docs/GraphApi.md#graph_g_suite_associations_list) | **GET** /gsuites/{gsuite_id}/associations | List the associations of a G Suite instance
*JCAPIv2::GraphApi* | [**graph_g_suite_associations_post**](docs/GraphApi.md#graph_g_suite_associations_post) | **POST** /gsuites/{gsuite_id}/associations | Manage the associations of a G Suite instance
*JCAPIv2::GraphApi* | [**graph_g_suite_traverse_user**](docs/GraphApi.md#graph_g_suite_traverse_user) | **GET** /gsuites/{gsuite_id}/users | List the Users bound to a G Suite instance
*JCAPIv2::GraphApi* | [**graph_g_suite_traverse_user_group**](docs/GraphApi.md#graph_g_suite_traverse_user_group) | **GET** /gsuites/{gsuite_id}/usergroups | List the User Groups bound to a G Suite instance
*JCAPIv2::GraphApi* | [**graph_ldap_server_associations_list**](docs/GraphApi.md#graph_ldap_server_associations_list) | **GET** /ldapservers/{ldapserver_id}/associations | List the associations of a LDAP Server
*JCAPIv2::GraphApi* | [**graph_ldap_server_associations_post**](docs/GraphApi.md#graph_ldap_server_associations_post) | **POST** /ldapservers/{ldapserver_id}/associations | Manage the associations of a LDAP Server
*JCAPIv2::GraphApi* | [**graph_ldap_server_traverse_user**](docs/GraphApi.md#graph_ldap_server_traverse_user) | **GET** /ldapservers/{ldapserver_id}/users | List the Users bound to a LDAP Server
*JCAPIv2::GraphApi* | [**graph_ldap_server_traverse_user_group**](docs/GraphApi.md#graph_ldap_server_traverse_user_group) | **GET** /ldapservers/{ldapserver_id}/usergroups | List the User Groups bound to a LDAP Server
*JCAPIv2::GraphApi* | [**graph_office365_associations_list**](docs/GraphApi.md#graph_office365_associations_list) | **GET** /office365s/{office365_id}/associations | List the associations of an Office 365 instance
*JCAPIv2::GraphApi* | [**graph_office365_associations_post**](docs/GraphApi.md#graph_office365_associations_post) | **POST** /office365s/{office365_id}/associations | Manage the associations of an Office 365 instance
*JCAPIv2::GraphApi* | [**graph_office365_traverse_user**](docs/GraphApi.md#graph_office365_traverse_user) | **GET** /office365s/{office365_id}/users | List the Users bound to an Office 365 instance
*JCAPIv2::GraphApi* | [**graph_office365_traverse_user_group**](docs/GraphApi.md#graph_office365_traverse_user_group) | **GET** /office365s/{office365_id}/usergroups | List the User Groups bound to an Office 365 instance
*JCAPIv2::GraphApi* | [**graph_policy_associations_list**](docs/GraphApi.md#graph_policy_associations_list) | **GET** /policies/{policy_id}/associations | List the associations of a Policy
*JCAPIv2::GraphApi* | [**graph_policy_associations_post**](docs/GraphApi.md#graph_policy_associations_post) | **POST** /policies/{policy_id}/associations | Manage the associations of a Policy
*JCAPIv2::GraphApi* | [**graph_policy_group_associations_list**](docs/GraphApi.md#graph_policy_group_associations_list) | **GET** /policygroups/{group_id}/associations | List the associations of a Policy Group.
*JCAPIv2::GraphApi* | [**graph_policy_group_associations_post**](docs/GraphApi.md#graph_policy_group_associations_post) | **POST** /policygroups/{group_id}/associations | Manage the associations of a Policy Group
*JCAPIv2::GraphApi* | [**graph_policy_group_members_list**](docs/GraphApi.md#graph_policy_group_members_list) | **GET** /policygroups/{group_id}/members | List the members of a Policy Group
*JCAPIv2::GraphApi* | [**graph_policy_group_members_post**](docs/GraphApi.md#graph_policy_group_members_post) | **POST** /policygroups/{group_id}/members | Manage the members of a Policy Group
*JCAPIv2::GraphApi* | [**graph_policy_group_membership**](docs/GraphApi.md#graph_policy_group_membership) | **GET** /policygroups/{group_id}/membership | List the Policy Group's membership
*JCAPIv2::GraphApi* | [**graph_policy_group_traverse_system**](docs/GraphApi.md#graph_policy_group_traverse_system) | **GET** /policygroups/{group_id}/systems | List the Systems bound to a Policy Group
*JCAPIv2::GraphApi* | [**graph_policy_group_traverse_system_group**](docs/GraphApi.md#graph_policy_group_traverse_system_group) | **GET** /policygroups/{group_id}/systemgroups | List the System Groups bound to Policy Groups
*JCAPIv2::GraphApi* | [**graph_policy_member_of**](docs/GraphApi.md#graph_policy_member_of) | **GET** /policies/{policy_id}/memberof | List the parent Groups of a Policy
*JCAPIv2::GraphApi* | [**graph_policy_traverse_system**](docs/GraphApi.md#graph_policy_traverse_system) | **GET** /policies/{policy_id}/systems | List the Systems bound to a Policy
*JCAPIv2::GraphApi* | [**graph_policy_traverse_system_group**](docs/GraphApi.md#graph_policy_traverse_system_group) | **GET** /policies/{policy_id}/systemgroups | List the System Groups bound to a Policy
*JCAPIv2::GraphApi* | [**graph_radius_server_associations_list**](docs/GraphApi.md#graph_radius_server_associations_list) | **GET** /radiusservers/{radiusserver_id}/associations | List the associations of a RADIUS  Server
*JCAPIv2::GraphApi* | [**graph_radius_server_associations_post**](docs/GraphApi.md#graph_radius_server_associations_post) | **POST** /radiusservers/{radiusserver_id}/associations | Manage the associations of a RADIUS Server
*JCAPIv2::GraphApi* | [**graph_radius_server_traverse_user**](docs/GraphApi.md#graph_radius_server_traverse_user) | **GET** /radiusservers/{radiusserver_id}/users | List the Users bound to a RADIUS  Server
*JCAPIv2::GraphApi* | [**graph_radius_server_traverse_user_group**](docs/GraphApi.md#graph_radius_server_traverse_user_group) | **GET** /radiusservers/{radiusserver_id}/usergroups | List the User Groups bound to a RADIUS  Server
*JCAPIv2::GraphApi* | [**graph_softwareapps_associations_list**](docs/GraphApi.md#graph_softwareapps_associations_list) | **GET** /softwareapps/{software_app_id}/associations | List the associations of a Software Application
*JCAPIv2::GraphApi* | [**graph_softwareapps_associations_post**](docs/GraphApi.md#graph_softwareapps_associations_post) | **POST** /softwareapps/{software_app_id}/associations | Manage the associations of a software application.
*JCAPIv2::GraphApi* | [**graph_softwareapps_traverse_system**](docs/GraphApi.md#graph_softwareapps_traverse_system) | **GET** /softwareapps/{software_app_id}/systems | List the Systems bound to a Software App.
*JCAPIv2::GraphApi* | [**graph_softwareapps_traverse_system_group**](docs/GraphApi.md#graph_softwareapps_traverse_system_group) | **GET** /softwareapps/{software_app_id}/systemgroups | List the System Groups bound to a Software App.
*JCAPIv2::GraphApi* | [**graph_system_associations_list**](docs/GraphApi.md#graph_system_associations_list) | **GET** /systems/{system_id}/associations | List the associations of a System
*JCAPIv2::GraphApi* | [**graph_system_associations_post**](docs/GraphApi.md#graph_system_associations_post) | **POST** /systems/{system_id}/associations | Manage associations of a System
*JCAPIv2::GraphApi* | [**graph_system_group_associations_list**](docs/GraphApi.md#graph_system_group_associations_list) | **GET** /systemgroups/{group_id}/associations | List the associations of a System Group
*JCAPIv2::GraphApi* | [**graph_system_group_associations_post**](docs/GraphApi.md#graph_system_group_associations_post) | **POST** /systemgroups/{group_id}/associations | Manage the associations of a System Group
*JCAPIv2::GraphApi* | [**graph_system_group_members_list**](docs/GraphApi.md#graph_system_group_members_list) | **GET** /systemgroups/{group_id}/members | List the members of a System Group
*JCAPIv2::GraphApi* | [**graph_system_group_members_post**](docs/GraphApi.md#graph_system_group_members_post) | **POST** /systemgroups/{group_id}/members | Manage the members of a System Group
*JCAPIv2::GraphApi* | [**graph_system_group_membership**](docs/GraphApi.md#graph_system_group_membership) | **GET** /systemgroups/{group_id}/membership | List the System Group's membership
*JCAPIv2::GraphApi* | [**graph_system_group_traverse_command**](docs/GraphApi.md#graph_system_group_traverse_command) | **GET** /systemgroups/{group_id}/commands | List the Commands bound to a System Group
*JCAPIv2::GraphApi* | [**graph_system_group_traverse_policy**](docs/GraphApi.md#graph_system_group_traverse_policy) | **GET** /systemgroups/{group_id}/policies | List the Policies bound to a System Group
*JCAPIv2::GraphApi* | [**graph_system_group_traverse_policy_group**](docs/GraphApi.md#graph_system_group_traverse_policy_group) | **GET** /systemgroups/{group_id}/policygroups | List the Policy Groups bound to a System Group
*JCAPIv2::GraphApi* | [**graph_system_group_traverse_user**](docs/GraphApi.md#graph_system_group_traverse_user) | **GET** /systemgroups/{group_id}/users | List the Users bound to a System Group
*JCAPIv2::GraphApi* | [**graph_system_group_traverse_user_group**](docs/GraphApi.md#graph_system_group_traverse_user_group) | **GET** /systemgroups/{group_id}/usergroups | List the User Groups bound to a System Group
*JCAPIv2::GraphApi* | [**graph_system_member_of**](docs/GraphApi.md#graph_system_member_of) | **GET** /systems/{system_id}/memberof | List the parent Groups of a System
*JCAPIv2::GraphApi* | [**graph_system_traverse_command**](docs/GraphApi.md#graph_system_traverse_command) | **GET** /systems/{system_id}/commands | List the Commands bound to a System
*JCAPIv2::GraphApi* | [**graph_system_traverse_policy**](docs/GraphApi.md#graph_system_traverse_policy) | **GET** /systems/{system_id}/policies | List the Policies bound to a System
*JCAPIv2::GraphApi* | [**graph_system_traverse_policy_group**](docs/GraphApi.md#graph_system_traverse_policy_group) | **GET** /systems/{system_id}/policygroups | List the Policy Groups bound to a System
*JCAPIv2::GraphApi* | [**graph_system_traverse_user**](docs/GraphApi.md#graph_system_traverse_user) | **GET** /systems/{system_id}/users | List the Users bound to a System
*JCAPIv2::GraphApi* | [**graph_system_traverse_user_group**](docs/GraphApi.md#graph_system_traverse_user_group) | **GET** /systems/{system_id}/usergroups | List the User Groups bound to a System
*JCAPIv2::GraphApi* | [**graph_user_associations_list**](docs/GraphApi.md#graph_user_associations_list) | **GET** /users/{user_id}/associations | List the associations of a User
*JCAPIv2::GraphApi* | [**graph_user_associations_post**](docs/GraphApi.md#graph_user_associations_post) | **POST** /users/{user_id}/associations | Manage the associations of a User
*JCAPIv2::GraphApi* | [**graph_user_group_associations_list**](docs/GraphApi.md#graph_user_group_associations_list) | **GET** /usergroups/{group_id}/associations | List the associations of a User Group.
*JCAPIv2::GraphApi* | [**graph_user_group_associations_post**](docs/GraphApi.md#graph_user_group_associations_post) | **POST** /usergroups/{group_id}/associations | Manage the associations of a User Group
*JCAPIv2::GraphApi* | [**graph_user_group_members_list**](docs/GraphApi.md#graph_user_group_members_list) | **GET** /usergroups/{group_id}/members | List the members of a User Group
*JCAPIv2::GraphApi* | [**graph_user_group_members_post**](docs/GraphApi.md#graph_user_group_members_post) | **POST** /usergroups/{group_id}/members | Manage the members of a User Group
*JCAPIv2::GraphApi* | [**graph_user_group_membership**](docs/GraphApi.md#graph_user_group_membership) | **GET** /usergroups/{group_id}/membership | List the User Group's membership
*JCAPIv2::GraphApi* | [**graph_user_group_traverse_active_directory**](docs/GraphApi.md#graph_user_group_traverse_active_directory) | **GET** /usergroups/{group_id}/activedirectories | List the Active Directories bound to a User Group
*JCAPIv2::GraphApi* | [**graph_user_group_traverse_application**](docs/GraphApi.md#graph_user_group_traverse_application) | **GET** /usergroups/{group_id}/applications | List the Applications bound to a User Group
*JCAPIv2::GraphApi* | [**graph_user_group_traverse_directory**](docs/GraphApi.md#graph_user_group_traverse_directory) | **GET** /usergroups/{group_id}/directories | List the Directories bound to a User Group
*JCAPIv2::GraphApi* | [**graph_user_group_traverse_g_suite**](docs/GraphApi.md#graph_user_group_traverse_g_suite) | **GET** /usergroups/{group_id}/gsuites | List the G Suite instances bound to a User Group
*JCAPIv2::GraphApi* | [**graph_user_group_traverse_ldap_server**](docs/GraphApi.md#graph_user_group_traverse_ldap_server) | **GET** /usergroups/{group_id}/ldapservers | List the LDAP Servers bound to a User Group
*JCAPIv2::GraphApi* | [**graph_user_group_traverse_office365**](docs/GraphApi.md#graph_user_group_traverse_office365) | **GET** /usergroups/{group_id}/office365s | List the Office 365 instances bound to a User Group
*JCAPIv2::GraphApi* | [**graph_user_group_traverse_radius_server**](docs/GraphApi.md#graph_user_group_traverse_radius_server) | **GET** /usergroups/{group_id}/radiusservers | List the RADIUS Servers bound to a User Group
*JCAPIv2::GraphApi* | [**graph_user_group_traverse_system**](docs/GraphApi.md#graph_user_group_traverse_system) | **GET** /usergroups/{group_id}/systems | List the Systems bound to a User Group
*JCAPIv2::GraphApi* | [**graph_user_group_traverse_system_group**](docs/GraphApi.md#graph_user_group_traverse_system_group) | **GET** /usergroups/{group_id}/systemgroups | List the System Groups bound to User Groups
*JCAPIv2::GraphApi* | [**graph_user_member_of**](docs/GraphApi.md#graph_user_member_of) | **GET** /users/{user_id}/memberof | List the parent Groups of a User
*JCAPIv2::GraphApi* | [**graph_user_traverse_active_directory**](docs/GraphApi.md#graph_user_traverse_active_directory) | **GET** /users/{user_id}/activedirectories | List the Active Directory instances bound to a User
*JCAPIv2::GraphApi* | [**graph_user_traverse_application**](docs/GraphApi.md#graph_user_traverse_application) | **GET** /users/{user_id}/applications | List the Applications bound to a User
*JCAPIv2::GraphApi* | [**graph_user_traverse_directory**](docs/GraphApi.md#graph_user_traverse_directory) | **GET** /users/{user_id}/directories | List the Directories bound to a User
*JCAPIv2::GraphApi* | [**graph_user_traverse_g_suite**](docs/GraphApi.md#graph_user_traverse_g_suite) | **GET** /users/{user_id}/gsuites | List the G Suite instances bound to a User
*JCAPIv2::GraphApi* | [**graph_user_traverse_ldap_server**](docs/GraphApi.md#graph_user_traverse_ldap_server) | **GET** /users/{user_id}/ldapservers | List the LDAP servers bound to a User
*JCAPIv2::GraphApi* | [**graph_user_traverse_office365**](docs/GraphApi.md#graph_user_traverse_office365) | **GET** /users/{user_id}/office365s | List the Office 365 instances bound to a User
*JCAPIv2::GraphApi* | [**graph_user_traverse_radius_server**](docs/GraphApi.md#graph_user_traverse_radius_server) | **GET** /users/{user_id}/radiusservers | List the RADIUS Servers bound to a User
*JCAPIv2::GraphApi* | [**graph_user_traverse_system**](docs/GraphApi.md#graph_user_traverse_system) | **GET** /users/{user_id}/systems | List the Systems bound to a User
*JCAPIv2::GraphApi* | [**graph_user_traverse_system_group**](docs/GraphApi.md#graph_user_traverse_system_group) | **GET** /users/{user_id}/systemgroups | List the System Groups bound to a User
*JCAPIv2::GraphApi* | [**policystatuses_systems_list**](docs/GraphApi.md#policystatuses_systems_list) | **GET** /systems/{system_id}/policystatuses | List the policy statuses for a system
*JCAPIv2::GroupsApi* | [**groups_list**](docs/GroupsApi.md#groups_list) | **GET** /groups | List All Groups
*JCAPIv2::IPListsApi* | [**iplists_delete**](docs/IPListsApi.md#iplists_delete) | **DELETE** /iplists/{id} | Delete an IP list
*JCAPIv2::IPListsApi* | [**iplists_get**](docs/IPListsApi.md#iplists_get) | **GET** /iplists/{id} | Get an IP list
*JCAPIv2::IPListsApi* | [**iplists_list**](docs/IPListsApi.md#iplists_list) | **GET** /iplists | List IP Lists
*JCAPIv2::IPListsApi* | [**iplists_patch**](docs/IPListsApi.md#iplists_patch) | **PATCH** /iplists/{id} | Update an IP list
*JCAPIv2::IPListsApi* | [**iplists_post**](docs/IPListsApi.md#iplists_post) | **POST** /iplists | Create IP List
*JCAPIv2::IPListsApi* | [**iplists_put**](docs/IPListsApi.md#iplists_put) | **PUT** /iplists/{id} | Replace an IP list
*JCAPIv2::ImageApi* | [**applications_delete_logo**](docs/ImageApi.md#applications_delete_logo) | **DELETE** /applications/{application_id}/logo | Delete application image
*JCAPIv2::LDAPServersApi* | [**graph_ldap_server_associations_list**](docs/LDAPServersApi.md#graph_ldap_server_associations_list) | **GET** /ldapservers/{ldapserver_id}/associations | List the associations of a LDAP Server
*JCAPIv2::LDAPServersApi* | [**graph_ldap_server_associations_post**](docs/LDAPServersApi.md#graph_ldap_server_associations_post) | **POST** /ldapservers/{ldapserver_id}/associations | Manage the associations of a LDAP Server
*JCAPIv2::LDAPServersApi* | [**graph_ldap_server_traverse_user**](docs/LDAPServersApi.md#graph_ldap_server_traverse_user) | **GET** /ldapservers/{ldapserver_id}/users | List the Users bound to a LDAP Server
*JCAPIv2::LDAPServersApi* | [**graph_ldap_server_traverse_user_group**](docs/LDAPServersApi.md#graph_ldap_server_traverse_user_group) | **GET** /ldapservers/{ldapserver_id}/usergroups | List the User Groups bound to a LDAP Server
*JCAPIv2::LDAPServersApi* | [**ldapservers_get**](docs/LDAPServersApi.md#ldapservers_get) | **GET** /ldapservers/{id} | Get LDAP Server
*JCAPIv2::LDAPServersApi* | [**ldapservers_list**](docs/LDAPServersApi.md#ldapservers_list) | **GET** /ldapservers | List LDAP Servers
*JCAPIv2::LDAPServersApi* | [**ldapservers_patch**](docs/LDAPServersApi.md#ldapservers_patch) | **PATCH** /ldapservers/{id} | Update existing LDAP server
*JCAPIv2::LogosApi* | [**logos_get**](docs/LogosApi.md#logos_get) | **GET** /logos/{id} | Get the logo associated with the specified id
*JCAPIv2::ManagedServiceProviderApi* | [**administrator_organizations_create_by_administrator**](docs/ManagedServiceProviderApi.md#administrator_organizations_create_by_administrator) | **POST** /administrators/{id}/organizationlinks | Allow Adminstrator access to an Organization.
*JCAPIv2::ManagedServiceProviderApi* | [**administrator_organizations_list_by_administrator**](docs/ManagedServiceProviderApi.md#administrator_organizations_list_by_administrator) | **GET** /administrators/{id}/organizationlinks | List the association links between an Administrator and Organizations.
*JCAPIv2::ManagedServiceProviderApi* | [**administrator_organizations_list_by_organization**](docs/ManagedServiceProviderApi.md#administrator_organizations_list_by_organization) | **GET** /organizations/{id}/administratorlinks | List the association links between an Organization and Administrators.
*JCAPIv2::ManagedServiceProviderApi* | [**administrator_organizations_remove_by_administrator**](docs/ManagedServiceProviderApi.md#administrator_organizations_remove_by_administrator) | **DELETE** /administrators/{administrator_id}/organizationlinks/{id} | Remove association between an Administrator and an Organization.
*JCAPIv2::ManagedServiceProviderApi* | [**policy_group_templates_delete**](docs/ManagedServiceProviderApi.md#policy_group_templates_delete) | **DELETE** /providers/{provider_id}/policygrouptemplates/{id} | Deletes policy group template.
*JCAPIv2::ManagedServiceProviderApi* | [**policy_group_templates_get**](docs/ManagedServiceProviderApi.md#policy_group_templates_get) | **GET** /providers/{provider_id}/policygrouptemplates/{id} | Gets a provider's policy group template.
*JCAPIv2::ManagedServiceProviderApi* | [**policy_group_templates_get_configured_policy_template**](docs/ManagedServiceProviderApi.md#policy_group_templates_get_configured_policy_template) | **GET** /providers/{provider_id}/configuredpolicytemplates/{id} | Retrieve a configured policy template by id.
*JCAPIv2::ManagedServiceProviderApi* | [**policy_group_templates_list**](docs/ManagedServiceProviderApi.md#policy_group_templates_list) | **GET** /providers/{provider_id}/policygrouptemplates | List a provider's policy group templates.
*JCAPIv2::ManagedServiceProviderApi* | [**policy_group_templates_list_configured_policy_templates**](docs/ManagedServiceProviderApi.md#policy_group_templates_list_configured_policy_templates) | **GET** /providers/{provider_id}/configuredpolicytemplates | List a provider's configured policy templates.
*JCAPIv2::ManagedServiceProviderApi* | [**policy_group_templates_list_members**](docs/ManagedServiceProviderApi.md#policy_group_templates_list_members) | **GET** /providers/{provider_id}/policygrouptemplates/{id}/members | Gets the list of members from a policy group template.
*JCAPIv2::ManagedServiceProviderApi* | [**provider_organizations_create_org**](docs/ManagedServiceProviderApi.md#provider_organizations_create_org) | **POST** /providers/{provider_id}/organizations | Create Provider Organization
*JCAPIv2::ManagedServiceProviderApi* | [**provider_organizations_update_org**](docs/ManagedServiceProviderApi.md#provider_organizations_update_org) | **PUT** /providers/{provider_id}/organizations/{id} | Update Provider Organization
*JCAPIv2::ManagedServiceProviderApi* | [**providers_get_provider**](docs/ManagedServiceProviderApi.md#providers_get_provider) | **GET** /providers/{provider_id} | Retrieve Provider
*JCAPIv2::ManagedServiceProviderApi* | [**providers_list_administrators**](docs/ManagedServiceProviderApi.md#providers_list_administrators) | **GET** /providers/{provider_id}/administrators | List Provider Administrators
*JCAPIv2::ManagedServiceProviderApi* | [**providers_list_organizations**](docs/ManagedServiceProviderApi.md#providers_list_organizations) | **GET** /providers/{provider_id}/organizations | List Provider Organizations
*JCAPIv2::ManagedServiceProviderApi* | [**providers_post_admins**](docs/ManagedServiceProviderApi.md#providers_post_admins) | **POST** /providers/{provider_id}/administrators | Create a new Provider Administrator
*JCAPIv2::ManagedServiceProviderApi* | [**providers_provider_list_case**](docs/ManagedServiceProviderApi.md#providers_provider_list_case) | **GET** /providers/{provider_id}/cases | Get all cases (Support/Feature requests) for provider
*JCAPIv2::ManagedServiceProviderApi* | [**providers_retrieve_invoice**](docs/ManagedServiceProviderApi.md#providers_retrieve_invoice) | **GET** /providers/{provider_id}/invoices/{ID} | Download a provider's invoice.
*JCAPIv2::ManagedServiceProviderApi* | [**providers_retrieve_invoices**](docs/ManagedServiceProviderApi.md#providers_retrieve_invoices) | **GET** /providers/{provider_id}/invoices | List a provider's invoices.
*JCAPIv2::Office365Api* | [**domains_delete**](docs/Office365Api.md#domains_delete) | **DELETE** /office365s/{office365_id}/domains/{domain_id} | Delete a domain from an Office 365 instance
*JCAPIv2::Office365Api* | [**domains_insert**](docs/Office365Api.md#domains_insert) | **POST** /office365s/{office365_id}/domains | Add a domain to an Office 365 instance
*JCAPIv2::Office365Api* | [**domains_list**](docs/Office365Api.md#domains_list) | **GET** /office365s/{office365_id}/domains | List all domains configured for an Office 365 instance
*JCAPIv2::Office365Api* | [**graph_office365_associations_list**](docs/Office365Api.md#graph_office365_associations_list) | **GET** /office365s/{office365_id}/associations | List the associations of an Office 365 instance
*JCAPIv2::Office365Api* | [**graph_office365_associations_post**](docs/Office365Api.md#graph_office365_associations_post) | **POST** /office365s/{office365_id}/associations | Manage the associations of an Office 365 instance
*JCAPIv2::Office365Api* | [**graph_office365_traverse_user**](docs/Office365Api.md#graph_office365_traverse_user) | **GET** /office365s/{office365_id}/users | List the Users bound to an Office 365 instance
*JCAPIv2::Office365Api* | [**graph_office365_traverse_user_group**](docs/Office365Api.md#graph_office365_traverse_user_group) | **GET** /office365s/{office365_id}/usergroups | List the User Groups bound to an Office 365 instance
*JCAPIv2::Office365Api* | [**office365s_get**](docs/Office365Api.md#office365s_get) | **GET** /office365s/{office365_id} | Get Office 365 instance
*JCAPIv2::Office365Api* | [**office365s_list_import_users**](docs/Office365Api.md#office365s_list_import_users) | **GET** /office365s/{office365_id}/import/users | Get a list of users to import from an Office 365 instance
*JCAPIv2::Office365Api* | [**office365s_patch**](docs/Office365Api.md#office365s_patch) | **PATCH** /office365s/{office365_id} | Update existing Office 365 instance.
*JCAPIv2::Office365Api* | [**translation_rules_office365_delete**](docs/Office365Api.md#translation_rules_office365_delete) | **DELETE** /office365s/{office365_id}/translationrules/{id} | Deletes a Office 365 translation rule
*JCAPIv2::Office365Api* | [**translation_rules_office365_get**](docs/Office365Api.md#translation_rules_office365_get) | **GET** /office365s/{office365_id}/translationrules/{id} | Gets a specific Office 365 translation rule
*JCAPIv2::Office365Api* | [**translation_rules_office365_list**](docs/Office365Api.md#translation_rules_office365_list) | **GET** /office365s/{office365_id}/translationrules | List all the Office 365 Translation Rules
*JCAPIv2::Office365Api* | [**translation_rules_office365_post**](docs/Office365Api.md#translation_rules_office365_post) | **POST** /office365s/{office365_id}/translationrules | Create a new Office 365 Translation Rule
*JCAPIv2::Office365ImportApi* | [**office365s_list_import_users**](docs/Office365ImportApi.md#office365s_list_import_users) | **GET** /office365s/{office365_id}/import/users | Get a list of users to import from an Office 365 instance
*JCAPIv2::OrganizationsApi* | [**administrator_organizations_create_by_administrator**](docs/OrganizationsApi.md#administrator_organizations_create_by_administrator) | **POST** /administrators/{id}/organizationlinks | Allow Adminstrator access to an Organization.
*JCAPIv2::OrganizationsApi* | [**administrator_organizations_list_by_administrator**](docs/OrganizationsApi.md#administrator_organizations_list_by_administrator) | **GET** /administrators/{id}/organizationlinks | List the association links between an Administrator and Organizations.
*JCAPIv2::OrganizationsApi* | [**administrator_organizations_list_by_organization**](docs/OrganizationsApi.md#administrator_organizations_list_by_organization) | **GET** /organizations/{id}/administratorlinks | List the association links between an Organization and Administrators.
*JCAPIv2::OrganizationsApi* | [**administrator_organizations_remove_by_administrator**](docs/OrganizationsApi.md#administrator_organizations_remove_by_administrator) | **DELETE** /administrators/{administrator_id}/organizationlinks/{id} | Remove association between an Administrator and an Organization.
*JCAPIv2::OrganizationsApi* | [**organizations_org_list_cases**](docs/OrganizationsApi.md#organizations_org_list_cases) | **GET** /organizations/cases | Get all cases (Support/Feature requests) for organization
*JCAPIv2::PasswordManagerApi* | [**device_service_get_device**](docs/PasswordManagerApi.md#device_service_get_device) | **GET** /passwordmanager/devices/{UUID} | 
*JCAPIv2::PasswordManagerApi* | [**device_service_list_devices**](docs/PasswordManagerApi.md#device_service_list_devices) | **GET** /passwordmanager/devices | 
*JCAPIv2::PoliciesApi* | [**graph_policy_associations_list**](docs/PoliciesApi.md#graph_policy_associations_list) | **GET** /policies/{policy_id}/associations | List the associations of a Policy
*JCAPIv2::PoliciesApi* | [**graph_policy_associations_post**](docs/PoliciesApi.md#graph_policy_associations_post) | **POST** /policies/{policy_id}/associations | Manage the associations of a Policy
*JCAPIv2::PoliciesApi* | [**graph_policy_member_of**](docs/PoliciesApi.md#graph_policy_member_of) | **GET** /policies/{policy_id}/memberof | List the parent Groups of a Policy
*JCAPIv2::PoliciesApi* | [**graph_policy_traverse_system**](docs/PoliciesApi.md#graph_policy_traverse_system) | **GET** /policies/{policy_id}/systems | List the Systems bound to a Policy
*JCAPIv2::PoliciesApi* | [**graph_policy_traverse_system_group**](docs/PoliciesApi.md#graph_policy_traverse_system_group) | **GET** /policies/{policy_id}/systemgroups | List the System Groups bound to a Policy
*JCAPIv2::PoliciesApi* | [**policies_delete**](docs/PoliciesApi.md#policies_delete) | **DELETE** /policies/{id} | Deletes a Policy
*JCAPIv2::PoliciesApi* | [**policies_get**](docs/PoliciesApi.md#policies_get) | **GET** /policies/{id} | Gets a specific Policy.
*JCAPIv2::PoliciesApi* | [**policies_list**](docs/PoliciesApi.md#policies_list) | **GET** /policies | Lists all the Policies
*JCAPIv2::PoliciesApi* | [**policies_post**](docs/PoliciesApi.md#policies_post) | **POST** /policies | Create a new Policy
*JCAPIv2::PoliciesApi* | [**policies_put**](docs/PoliciesApi.md#policies_put) | **PUT** /policies/{id} | Update an existing Policy
*JCAPIv2::PoliciesApi* | [**policyresults_get**](docs/PoliciesApi.md#policyresults_get) | **GET** /policyresults/{id} | Get a specific Policy Result.
*JCAPIv2::PoliciesApi* | [**policyresults_list**](docs/PoliciesApi.md#policyresults_list) | **GET** /policies/{policy_id}/policyresults | Lists all the policy results of a policy.
*JCAPIv2::PoliciesApi* | [**policyresults_org_list**](docs/PoliciesApi.md#policyresults_org_list) | **GET** /policyresults | Lists all of the policy results for an organization.
*JCAPIv2::PoliciesApi* | [**policystatuses_policies_list**](docs/PoliciesApi.md#policystatuses_policies_list) | **GET** /policies/{policy_id}/policystatuses | Lists the latest policy results of a policy.
*JCAPIv2::PoliciesApi* | [**policystatuses_systems_list**](docs/PoliciesApi.md#policystatuses_systems_list) | **GET** /systems/{system_id}/policystatuses | List the policy statuses for a system
*JCAPIv2::PoliciesApi* | [**policytemplates_get**](docs/PoliciesApi.md#policytemplates_get) | **GET** /policytemplates/{id} | Get a specific Policy Template
*JCAPIv2::PoliciesApi* | [**policytemplates_list**](docs/PoliciesApi.md#policytemplates_list) | **GET** /policytemplates | Lists all of the Policy Templates
*JCAPIv2::PolicyGroupAssociationsApi* | [**graph_policy_group_associations_list**](docs/PolicyGroupAssociationsApi.md#graph_policy_group_associations_list) | **GET** /policygroups/{group_id}/associations | List the associations of a Policy Group.
*JCAPIv2::PolicyGroupAssociationsApi* | [**graph_policy_group_associations_post**](docs/PolicyGroupAssociationsApi.md#graph_policy_group_associations_post) | **POST** /policygroups/{group_id}/associations | Manage the associations of a Policy Group
*JCAPIv2::PolicyGroupAssociationsApi* | [**graph_policy_group_traverse_system**](docs/PolicyGroupAssociationsApi.md#graph_policy_group_traverse_system) | **GET** /policygroups/{group_id}/systems | List the Systems bound to a Policy Group
*JCAPIv2::PolicyGroupAssociationsApi* | [**graph_policy_group_traverse_system_group**](docs/PolicyGroupAssociationsApi.md#graph_policy_group_traverse_system_group) | **GET** /policygroups/{group_id}/systemgroups | List the System Groups bound to Policy Groups
*JCAPIv2::PolicyGroupMembersMembershipApi* | [**graph_policy_group_members_list**](docs/PolicyGroupMembersMembershipApi.md#graph_policy_group_members_list) | **GET** /policygroups/{group_id}/members | List the members of a Policy Group
*JCAPIv2::PolicyGroupMembersMembershipApi* | [**graph_policy_group_members_post**](docs/PolicyGroupMembersMembershipApi.md#graph_policy_group_members_post) | **POST** /policygroups/{group_id}/members | Manage the members of a Policy Group
*JCAPIv2::PolicyGroupMembersMembershipApi* | [**graph_policy_group_membership**](docs/PolicyGroupMembersMembershipApi.md#graph_policy_group_membership) | **GET** /policygroups/{group_id}/membership | List the Policy Group's membership
*JCAPIv2::PolicyGroupTemplatesApi* | [**policy_group_templates_delete**](docs/PolicyGroupTemplatesApi.md#policy_group_templates_delete) | **DELETE** /providers/{provider_id}/policygrouptemplates/{id} | Deletes policy group template.
*JCAPIv2::PolicyGroupTemplatesApi* | [**policy_group_templates_get**](docs/PolicyGroupTemplatesApi.md#policy_group_templates_get) | **GET** /providers/{provider_id}/policygrouptemplates/{id} | Gets a provider's policy group template.
*JCAPIv2::PolicyGroupTemplatesApi* | [**policy_group_templates_get_configured_policy_template**](docs/PolicyGroupTemplatesApi.md#policy_group_templates_get_configured_policy_template) | **GET** /providers/{provider_id}/configuredpolicytemplates/{id} | Retrieve a configured policy template by id.
*JCAPIv2::PolicyGroupTemplatesApi* | [**policy_group_templates_list**](docs/PolicyGroupTemplatesApi.md#policy_group_templates_list) | **GET** /providers/{provider_id}/policygrouptemplates | List a provider's policy group templates.
*JCAPIv2::PolicyGroupTemplatesApi* | [**policy_group_templates_list_configured_policy_templates**](docs/PolicyGroupTemplatesApi.md#policy_group_templates_list_configured_policy_templates) | **GET** /providers/{provider_id}/configuredpolicytemplates | List a provider's configured policy templates.
*JCAPIv2::PolicyGroupTemplatesApi* | [**policy_group_templates_list_members**](docs/PolicyGroupTemplatesApi.md#policy_group_templates_list_members) | **GET** /providers/{provider_id}/policygrouptemplates/{id}/members | Gets the list of members from a policy group template.
*JCAPIv2::PolicyGroupsApi* | [**graph_policy_group_associations_list**](docs/PolicyGroupsApi.md#graph_policy_group_associations_list) | **GET** /policygroups/{group_id}/associations | List the associations of a Policy Group.
*JCAPIv2::PolicyGroupsApi* | [**graph_policy_group_associations_post**](docs/PolicyGroupsApi.md#graph_policy_group_associations_post) | **POST** /policygroups/{group_id}/associations | Manage the associations of a Policy Group
*JCAPIv2::PolicyGroupsApi* | [**graph_policy_group_members_list**](docs/PolicyGroupsApi.md#graph_policy_group_members_list) | **GET** /policygroups/{group_id}/members | List the members of a Policy Group
*JCAPIv2::PolicyGroupsApi* | [**graph_policy_group_members_post**](docs/PolicyGroupsApi.md#graph_policy_group_members_post) | **POST** /policygroups/{group_id}/members | Manage the members of a Policy Group
*JCAPIv2::PolicyGroupsApi* | [**graph_policy_group_membership**](docs/PolicyGroupsApi.md#graph_policy_group_membership) | **GET** /policygroups/{group_id}/membership | List the Policy Group's membership
*JCAPIv2::PolicyGroupsApi* | [**graph_policy_group_traverse_system**](docs/PolicyGroupsApi.md#graph_policy_group_traverse_system) | **GET** /policygroups/{group_id}/systems | List the Systems bound to a Policy Group
*JCAPIv2::PolicyGroupsApi* | [**graph_policy_group_traverse_system_group**](docs/PolicyGroupsApi.md#graph_policy_group_traverse_system_group) | **GET** /policygroups/{group_id}/systemgroups | List the System Groups bound to Policy Groups
*JCAPIv2::PolicyGroupsApi* | [**groups_policy_delete**](docs/PolicyGroupsApi.md#groups_policy_delete) | **DELETE** /policygroups/{id} | Delete a Policy Group
*JCAPIv2::PolicyGroupsApi* | [**groups_policy_get**](docs/PolicyGroupsApi.md#groups_policy_get) | **GET** /policygroups/{id} | View an individual Policy Group details
*JCAPIv2::PolicyGroupsApi* | [**groups_policy_list**](docs/PolicyGroupsApi.md#groups_policy_list) | **GET** /policygroups | List all Policy Groups
*JCAPIv2::PolicyGroupsApi* | [**groups_policy_post**](docs/PolicyGroupsApi.md#groups_policy_post) | **POST** /policygroups | Create a new Policy Group
*JCAPIv2::PolicyGroupsApi* | [**groups_policy_put**](docs/PolicyGroupsApi.md#groups_policy_put) | **PUT** /policygroups/{id} | Update a Policy Group
*JCAPIv2::PolicytemplatesApi* | [**policytemplates_get**](docs/PolicytemplatesApi.md#policytemplates_get) | **GET** /policytemplates/{id} | Get a specific Policy Template
*JCAPIv2::PolicytemplatesApi* | [**policytemplates_list**](docs/PolicytemplatesApi.md#policytemplates_list) | **GET** /policytemplates | Lists all of the Policy Templates
*JCAPIv2::ProvidersApi* | [**autotask_create_configuration**](docs/ProvidersApi.md#autotask_create_configuration) | **POST** /providers/{provider_id}/integrations/autotask | Creates a new Autotask integration for the provider
*JCAPIv2::ProvidersApi* | [**autotask_delete_configuration**](docs/ProvidersApi.md#autotask_delete_configuration) | **DELETE** /integrations/autotask/{UUID} | Delete Autotask Integration
*JCAPIv2::ProvidersApi* | [**autotask_get_configuration**](docs/ProvidersApi.md#autotask_get_configuration) | **GET** /integrations/autotask/{UUID} | Retrieve Autotask Integration Configuration
*JCAPIv2::ProvidersApi* | [**autotask_patch_mappings**](docs/ProvidersApi.md#autotask_patch_mappings) | **PATCH** /integrations/autotask/{UUID}/mappings | Create, edit, and/or delete Autotask Mappings
*JCAPIv2::ProvidersApi* | [**autotask_patch_settings**](docs/ProvidersApi.md#autotask_patch_settings) | **PATCH** /integrations/autotask/{UUID}/settings | Create, edit, and/or delete Autotask Integration settings
*JCAPIv2::ProvidersApi* | [**autotask_retrieve_all_alert_configuration_options**](docs/ProvidersApi.md#autotask_retrieve_all_alert_configuration_options) | **GET** /providers/{provider_id}/integrations/autotask/alerts/configuration/options | Get all Autotask ticketing alert configuration options for a provider
*JCAPIv2::ProvidersApi* | [**autotask_retrieve_all_alert_configurations**](docs/ProvidersApi.md#autotask_retrieve_all_alert_configurations) | **GET** /providers/{provider_id}/integrations/autotask/alerts/configuration | Get all Autotask ticketing alert configurations for a provider
*JCAPIv2::ProvidersApi* | [**autotask_retrieve_companies**](docs/ProvidersApi.md#autotask_retrieve_companies) | **GET** /integrations/autotask/{UUID}/companies | Retrieve Autotask Companies
*JCAPIv2::ProvidersApi* | [**autotask_retrieve_company_types**](docs/ProvidersApi.md#autotask_retrieve_company_types) | **GET** /integrations/autotask/{UUID}/companytypes | Retrieve Autotask Company Types
*JCAPIv2::ProvidersApi* | [**autotask_retrieve_contracts**](docs/ProvidersApi.md#autotask_retrieve_contracts) | **GET** /integrations/autotask/{UUID}/contracts | Retrieve Autotask Contracts
*JCAPIv2::ProvidersApi* | [**autotask_retrieve_contracts_fields**](docs/ProvidersApi.md#autotask_retrieve_contracts_fields) | **GET** /integrations/autotask/{UUID}/contracts/fields | Retrieve Autotask Contract Fields
*JCAPIv2::ProvidersApi* | [**autotask_retrieve_mappings**](docs/ProvidersApi.md#autotask_retrieve_mappings) | **GET** /integrations/autotask/{UUID}/mappings | Retrieve Autotask mappings
*JCAPIv2::ProvidersApi* | [**autotask_retrieve_services**](docs/ProvidersApi.md#autotask_retrieve_services) | **GET** /integrations/autotask/{UUID}/contracts/services | Retrieve Autotask Contract Services
*JCAPIv2::ProvidersApi* | [**autotask_retrieve_settings**](docs/ProvidersApi.md#autotask_retrieve_settings) | **GET** /integrations/autotask/{UUID}/settings | Retrieve Autotask Integration settings
*JCAPIv2::ProvidersApi* | [**autotask_update_alert_configuration**](docs/ProvidersApi.md#autotask_update_alert_configuration) | **PUT** /providers/{provider_id}/integrations/autotask/alerts/{alert_UUID}/configuration | Update an Autotask ticketing alert's configuration
*JCAPIv2::ProvidersApi* | [**autotask_update_configuration**](docs/ProvidersApi.md#autotask_update_configuration) | **PATCH** /integrations/autotask/{UUID} | Update Autotask Integration configuration
*JCAPIv2::ProvidersApi* | [**billing_get_contract**](docs/ProvidersApi.md#billing_get_contract) | **GET** /providers/{provider_id}/billing/contract | Retrieve contract for a Provider
*JCAPIv2::ProvidersApi* | [**billing_get_details**](docs/ProvidersApi.md#billing_get_details) | **GET** /providers/{provider_id}/billing/details | Retrieve billing details for a Provider
*JCAPIv2::ProvidersApi* | [**connectwise_create_configuration**](docs/ProvidersApi.md#connectwise_create_configuration) | **POST** /providers/{provider_id}/integrations/connectwise | Creates a new ConnectWise integration for the provider
*JCAPIv2::ProvidersApi* | [**connectwise_delete_configuration**](docs/ProvidersApi.md#connectwise_delete_configuration) | **DELETE** /integrations/connectwise/{UUID} | Delete ConnectWise Integration
*JCAPIv2::ProvidersApi* | [**connectwise_get_configuration**](docs/ProvidersApi.md#connectwise_get_configuration) | **GET** /integrations/connectwise/{UUID} | Retrieve ConnectWise Integration Configuration
*JCAPIv2::ProvidersApi* | [**connectwise_patch_mappings**](docs/ProvidersApi.md#connectwise_patch_mappings) | **PATCH** /integrations/connectwise/{UUID}/mappings | Create, edit, and/or delete ConnectWise Mappings
*JCAPIv2::ProvidersApi* | [**connectwise_patch_settings**](docs/ProvidersApi.md#connectwise_patch_settings) | **PATCH** /integrations/connectwise/{UUID}/settings | Create, edit, and/or delete ConnectWise Integration settings
*JCAPIv2::ProvidersApi* | [**connectwise_retrieve_additions**](docs/ProvidersApi.md#connectwise_retrieve_additions) | **GET** /integrations/connectwise/{UUID}/agreements/{agreement_ID}/additions | Retrieve ConnectWise Additions
*JCAPIv2::ProvidersApi* | [**connectwise_retrieve_agreements**](docs/ProvidersApi.md#connectwise_retrieve_agreements) | **GET** /integrations/connectwise/{UUID}/agreements | Retrieve ConnectWise Agreements
*JCAPIv2::ProvidersApi* | [**connectwise_retrieve_all_alert_configuration_options**](docs/ProvidersApi.md#connectwise_retrieve_all_alert_configuration_options) | **GET** /providers/{provider_id}/integrations/connectwise/alerts/configuration/options | Get all ConnectWise ticketing alert configuration options for a provider
*JCAPIv2::ProvidersApi* | [**connectwise_retrieve_all_alert_configurations**](docs/ProvidersApi.md#connectwise_retrieve_all_alert_configurations) | **GET** /providers/{provider_id}/integrations/connectwise/alerts/configuration | Get all ConnectWise ticketing alert configurations for a provider
*JCAPIv2::ProvidersApi* | [**connectwise_retrieve_companies**](docs/ProvidersApi.md#connectwise_retrieve_companies) | **GET** /integrations/connectwise/{UUID}/companies | Retrieve ConnectWise Companies
*JCAPIv2::ProvidersApi* | [**connectwise_retrieve_company_types**](docs/ProvidersApi.md#connectwise_retrieve_company_types) | **GET** /integrations/connectwise/{UUID}/companytypes | Retrieve ConnectWise Company Types
*JCAPIv2::ProvidersApi* | [**connectwise_retrieve_mappings**](docs/ProvidersApi.md#connectwise_retrieve_mappings) | **GET** /integrations/connectwise/{UUID}/mappings | Retrieve ConnectWise mappings
*JCAPIv2::ProvidersApi* | [**connectwise_retrieve_settings**](docs/ProvidersApi.md#connectwise_retrieve_settings) | **GET** /integrations/connectwise/{UUID}/settings | Retrieve ConnectWise Integration settings
*JCAPIv2::ProvidersApi* | [**connectwise_update_alert_configuration**](docs/ProvidersApi.md#connectwise_update_alert_configuration) | **PUT** /providers/{provider_id}/integrations/connectwise/alerts/{alert_UUID}/configuration | Update a ConnectWise ticketing alert's configuration
*JCAPIv2::ProvidersApi* | [**connectwise_update_configuration**](docs/ProvidersApi.md#connectwise_update_configuration) | **PATCH** /integrations/connectwise/{UUID} | Update ConnectWise Integration configuration
*JCAPIv2::ProvidersApi* | [**mtp_integration_retrieve_alerts**](docs/ProvidersApi.md#mtp_integration_retrieve_alerts) | **GET** /providers/{provider_id}/integrations/ticketing/alerts | Get all ticketing alerts available for a provider's ticketing integration.
*JCAPIv2::ProvidersApi* | [**mtp_integration_retrieve_sync_errors**](docs/ProvidersApi.md#mtp_integration_retrieve_sync_errors) | **GET** /integrations/{integration_type}/{UUID}/errors | Retrieve Recent Integration Sync Errors
*JCAPIv2::ProvidersApi* | [**policy_group_templates_delete**](docs/ProvidersApi.md#policy_group_templates_delete) | **DELETE** /providers/{provider_id}/policygrouptemplates/{id} | Deletes policy group template.
*JCAPIv2::ProvidersApi* | [**policy_group_templates_get**](docs/ProvidersApi.md#policy_group_templates_get) | **GET** /providers/{provider_id}/policygrouptemplates/{id} | Gets a provider's policy group template.
*JCAPIv2::ProvidersApi* | [**policy_group_templates_get_configured_policy_template**](docs/ProvidersApi.md#policy_group_templates_get_configured_policy_template) | **GET** /providers/{provider_id}/configuredpolicytemplates/{id} | Retrieve a configured policy template by id.
*JCAPIv2::ProvidersApi* | [**policy_group_templates_list**](docs/ProvidersApi.md#policy_group_templates_list) | **GET** /providers/{provider_id}/policygrouptemplates | List a provider's policy group templates.
*JCAPIv2::ProvidersApi* | [**policy_group_templates_list_configured_policy_templates**](docs/ProvidersApi.md#policy_group_templates_list_configured_policy_templates) | **GET** /providers/{provider_id}/configuredpolicytemplates | List a provider's configured policy templates.
*JCAPIv2::ProvidersApi* | [**policy_group_templates_list_members**](docs/ProvidersApi.md#policy_group_templates_list_members) | **GET** /providers/{provider_id}/policygrouptemplates/{id}/members | Gets the list of members from a policy group template.
*JCAPIv2::ProvidersApi* | [**provider_organizations_create_org**](docs/ProvidersApi.md#provider_organizations_create_org) | **POST** /providers/{provider_id}/organizations | Create Provider Organization
*JCAPIv2::ProvidersApi* | [**provider_organizations_update_org**](docs/ProvidersApi.md#provider_organizations_update_org) | **PUT** /providers/{provider_id}/organizations/{id} | Update Provider Organization
*JCAPIv2::ProvidersApi* | [**providers_get_provider**](docs/ProvidersApi.md#providers_get_provider) | **GET** /providers/{provider_id} | Retrieve Provider
*JCAPIv2::ProvidersApi* | [**providers_list_administrators**](docs/ProvidersApi.md#providers_list_administrators) | **GET** /providers/{provider_id}/administrators | List Provider Administrators
*JCAPIv2::ProvidersApi* | [**providers_list_organizations**](docs/ProvidersApi.md#providers_list_organizations) | **GET** /providers/{provider_id}/organizations | List Provider Organizations
*JCAPIv2::ProvidersApi* | [**providers_post_admins**](docs/ProvidersApi.md#providers_post_admins) | **POST** /providers/{provider_id}/administrators | Create a new Provider Administrator
*JCAPIv2::ProvidersApi* | [**providers_provider_list_case**](docs/ProvidersApi.md#providers_provider_list_case) | **GET** /providers/{provider_id}/cases | Get all cases (Support/Feature requests) for provider
*JCAPIv2::ProvidersApi* | [**providers_remove_administrator**](docs/ProvidersApi.md#providers_remove_administrator) | **DELETE** /providers/{provider_id}/administrators/{id} | Delete Provider Administrator
*JCAPIv2::ProvidersApi* | [**providers_retrieve_integrations**](docs/ProvidersApi.md#providers_retrieve_integrations) | **GET** /providers/{provider_id}/integrations | Retrieve Integrations for Provider
*JCAPIv2::ProvidersApi* | [**providers_retrieve_invoice**](docs/ProvidersApi.md#providers_retrieve_invoice) | **GET** /providers/{provider_id}/invoices/{ID} | Download a provider's invoice.
*JCAPIv2::ProvidersApi* | [**providers_retrieve_invoices**](docs/ProvidersApi.md#providers_retrieve_invoices) | **GET** /providers/{provider_id}/invoices | List a provider's invoices.
*JCAPIv2::ProvidersApi* | [**syncro_create_configuration**](docs/ProvidersApi.md#syncro_create_configuration) | **POST** /providers/{provider_id}/integrations/syncro | Creates a new Syncro integration for the provider
*JCAPIv2::ProvidersApi* | [**syncro_delete_configuration**](docs/ProvidersApi.md#syncro_delete_configuration) | **DELETE** /integrations/syncro/{UUID} | Delete Syncro Integration
*JCAPIv2::ProvidersApi* | [**syncro_get_configuration**](docs/ProvidersApi.md#syncro_get_configuration) | **GET** /integrations/syncro/{UUID} | Retrieve Syncro Integration Configuration
*JCAPIv2::ProvidersApi* | [**syncro_patch_mappings**](docs/ProvidersApi.md#syncro_patch_mappings) | **PATCH** /integrations/syncro/{UUID}/mappings | Create, edit, and/or delete Syncro Mappings
*JCAPIv2::ProvidersApi* | [**syncro_patch_settings**](docs/ProvidersApi.md#syncro_patch_settings) | **PATCH** /integrations/syncro/{UUID}/settings | Create, edit, and/or delete Syncro Integration settings
*JCAPIv2::ProvidersApi* | [**syncro_retrieve_all_alert_configuration_options**](docs/ProvidersApi.md#syncro_retrieve_all_alert_configuration_options) | **GET** /providers/{provider_id}/integrations/syncro/alerts/configuration/options | Get all Syncro ticketing alert configuration options for a provider
*JCAPIv2::ProvidersApi* | [**syncro_retrieve_all_alert_configurations**](docs/ProvidersApi.md#syncro_retrieve_all_alert_configurations) | **GET** /providers/{provider_id}/integrations/syncro/alerts/configuration | Get all Syncro ticketing alert configurations for a provider
*JCAPIv2::ProvidersApi* | [**syncro_retrieve_billing_mapping_configuration_options**](docs/ProvidersApi.md#syncro_retrieve_billing_mapping_configuration_options) | **GET** /integrations/syncro/{UUID}/billing_mapping_configuration_options | Retrieve Syncro billing mappings dependencies
*JCAPIv2::ProvidersApi* | [**syncro_retrieve_companies**](docs/ProvidersApi.md#syncro_retrieve_companies) | **GET** /integrations/syncro/{UUID}/companies | Retrieve Syncro Companies
*JCAPIv2::ProvidersApi* | [**syncro_retrieve_mappings**](docs/ProvidersApi.md#syncro_retrieve_mappings) | **GET** /integrations/syncro/{UUID}/mappings | Retrieve Syncro mappings
*JCAPIv2::ProvidersApi* | [**syncro_retrieve_settings**](docs/ProvidersApi.md#syncro_retrieve_settings) | **GET** /integrations/syncro/{UUID}/settings | Retrieve Syncro Integration settings
*JCAPIv2::ProvidersApi* | [**syncro_update_alert_configuration**](docs/ProvidersApi.md#syncro_update_alert_configuration) | **PUT** /providers/{provider_id}/integrations/syncro/alerts/{alert_UUID}/configuration | Update a Syncro ticketing alert's configuration
*JCAPIv2::ProvidersApi* | [**syncro_update_configuration**](docs/ProvidersApi.md#syncro_update_configuration) | **PATCH** /integrations/syncro/{UUID} | Update Syncro Integration configuration
*JCAPIv2::RADIUSServersApi* | [**graph_radius_server_associations_list**](docs/RADIUSServersApi.md#graph_radius_server_associations_list) | **GET** /radiusservers/{radiusserver_id}/associations | List the associations of a RADIUS  Server
*JCAPIv2::RADIUSServersApi* | [**graph_radius_server_associations_post**](docs/RADIUSServersApi.md#graph_radius_server_associations_post) | **POST** /radiusservers/{radiusserver_id}/associations | Manage the associations of a RADIUS Server
*JCAPIv2::RADIUSServersApi* | [**graph_radius_server_traverse_user**](docs/RADIUSServersApi.md#graph_radius_server_traverse_user) | **GET** /radiusservers/{radiusserver_id}/users | List the Users bound to a RADIUS  Server
*JCAPIv2::RADIUSServersApi* | [**graph_radius_server_traverse_user_group**](docs/RADIUSServersApi.md#graph_radius_server_traverse_user_group) | **GET** /radiusservers/{radiusserver_id}/usergroups | List the User Groups bound to a RADIUS  Server
*JCAPIv2::SCIMImportApi* | [**import_users**](docs/SCIMImportApi.md#import_users) | **GET** /applications/{application_id}/import/users | Get a list of users to import from an Application IdM service provider
*JCAPIv2::SambaDomainsApi* | [**ldapservers_samba_domains_delete**](docs/SambaDomainsApi.md#ldapservers_samba_domains_delete) | **DELETE** /ldapservers/{ldapserver_id}/sambadomains/{id} | Delete Samba Domain
*JCAPIv2::SambaDomainsApi* | [**ldapservers_samba_domains_get**](docs/SambaDomainsApi.md#ldapservers_samba_domains_get) | **GET** /ldapservers/{ldapserver_id}/sambadomains/{id} | Get Samba Domain
*JCAPIv2::SambaDomainsApi* | [**ldapservers_samba_domains_list**](docs/SambaDomainsApi.md#ldapservers_samba_domains_list) | **GET** /ldapservers/{ldapserver_id}/sambadomains | List Samba Domains
*JCAPIv2::SambaDomainsApi* | [**ldapservers_samba_domains_post**](docs/SambaDomainsApi.md#ldapservers_samba_domains_post) | **POST** /ldapservers/{ldapserver_id}/sambadomains | Create Samba Domain
*JCAPIv2::SambaDomainsApi* | [**ldapservers_samba_domains_put**](docs/SambaDomainsApi.md#ldapservers_samba_domains_put) | **PUT** /ldapservers/{ldapserver_id}/sambadomains/{id} | Update Samba Domain
*JCAPIv2::SoftwareAppsApi* | [**graph_softwareapps_associations_list**](docs/SoftwareAppsApi.md#graph_softwareapps_associations_list) | **GET** /softwareapps/{software_app_id}/associations | List the associations of a Software Application
*JCAPIv2::SoftwareAppsApi* | [**graph_softwareapps_associations_post**](docs/SoftwareAppsApi.md#graph_softwareapps_associations_post) | **POST** /softwareapps/{software_app_id}/associations | Manage the associations of a software application.
*JCAPIv2::SoftwareAppsApi* | [**graph_softwareapps_traverse_system**](docs/SoftwareAppsApi.md#graph_softwareapps_traverse_system) | **GET** /softwareapps/{software_app_id}/systems | List the Systems bound to a Software App.
*JCAPIv2::SoftwareAppsApi* | [**graph_softwareapps_traverse_system_group**](docs/SoftwareAppsApi.md#graph_softwareapps_traverse_system_group) | **GET** /softwareapps/{software_app_id}/systemgroups | List the System Groups bound to a Software App.
*JCAPIv2::SoftwareAppsApi* | [**software_app_statuses_list**](docs/SoftwareAppsApi.md#software_app_statuses_list) | **GET** /softwareapps/{software_app_id}/statuses | Get the status of the provided Software Application
*JCAPIv2::SoftwareAppsApi* | [**software_apps_delete**](docs/SoftwareAppsApi.md#software_apps_delete) | **DELETE** /softwareapps/{id} | Delete a configured Software Application
*JCAPIv2::SoftwareAppsApi* | [**software_apps_get**](docs/SoftwareAppsApi.md#software_apps_get) | **GET** /softwareapps/{id} | Retrieve a configured Software Application.
*JCAPIv2::SoftwareAppsApi* | [**software_apps_list**](docs/SoftwareAppsApi.md#software_apps_list) | **GET** /softwareapps | Get all configured Software Applications.
*JCAPIv2::SoftwareAppsApi* | [**software_apps_post**](docs/SoftwareAppsApi.md#software_apps_post) | **POST** /softwareapps | Create a Software Application that will be managed by JumpCloud.
*JCAPIv2::SoftwareAppsApi* | [**software_apps_reclaim_licenses**](docs/SoftwareAppsApi.md#software_apps_reclaim_licenses) | **POST** /softwareapps/{software_app_id}/reclaim-licenses | Reclaim Licenses for a Software Application.
*JCAPIv2::SoftwareAppsApi* | [**software_apps_retry_installation**](docs/SoftwareAppsApi.md#software_apps_retry_installation) | **POST** /softwareapps/{software_app_id}/retry-installation | Retry Installation for a Software Application
*JCAPIv2::SoftwareAppsApi* | [**software_apps_update**](docs/SoftwareAppsApi.md#software_apps_update) | **PUT** /softwareapps/{id} | Update a Software Application Configuration.
*JCAPIv2::SoftwareAppsApi* | [**validator_validate_application_install_package**](docs/SoftwareAppsApi.md#validator_validate_application_install_package) | **POST** /softwareapps/validate | Validate Installation Packages
*JCAPIv2::SubscriptionsApi* | [**subscriptions_get**](docs/SubscriptionsApi.md#subscriptions_get) | **GET** /subscriptions | Lists all the Pricing & Packaging Subscriptions
*JCAPIv2::SystemGroupAssociationsApi* | [**graph_system_group_associations_list**](docs/SystemGroupAssociationsApi.md#graph_system_group_associations_list) | **GET** /systemgroups/{group_id}/associations | List the associations of a System Group
*JCAPIv2::SystemGroupAssociationsApi* | [**graph_system_group_associations_post**](docs/SystemGroupAssociationsApi.md#graph_system_group_associations_post) | **POST** /systemgroups/{group_id}/associations | Manage the associations of a System Group
*JCAPIv2::SystemGroupAssociationsApi* | [**graph_system_group_traverse_command**](docs/SystemGroupAssociationsApi.md#graph_system_group_traverse_command) | **GET** /systemgroups/{group_id}/commands | List the Commands bound to a System Group
*JCAPIv2::SystemGroupAssociationsApi* | [**graph_system_group_traverse_policy**](docs/SystemGroupAssociationsApi.md#graph_system_group_traverse_policy) | **GET** /systemgroups/{group_id}/policies | List the Policies bound to a System Group
*JCAPIv2::SystemGroupAssociationsApi* | [**graph_system_group_traverse_policy_group**](docs/SystemGroupAssociationsApi.md#graph_system_group_traverse_policy_group) | **GET** /systemgroups/{group_id}/policygroups | List the Policy Groups bound to a System Group
*JCAPIv2::SystemGroupAssociationsApi* | [**graph_system_group_traverse_user**](docs/SystemGroupAssociationsApi.md#graph_system_group_traverse_user) | **GET** /systemgroups/{group_id}/users | List the Users bound to a System Group
*JCAPIv2::SystemGroupAssociationsApi* | [**graph_system_group_traverse_user_group**](docs/SystemGroupAssociationsApi.md#graph_system_group_traverse_user_group) | **GET** /systemgroups/{group_id}/usergroups | List the User Groups bound to a System Group
*JCAPIv2::SystemGroupMembersMembershipApi* | [**graph_system_group_members_list**](docs/SystemGroupMembersMembershipApi.md#graph_system_group_members_list) | **GET** /systemgroups/{group_id}/members | List the members of a System Group
*JCAPIv2::SystemGroupMembersMembershipApi* | [**graph_system_group_members_post**](docs/SystemGroupMembersMembershipApi.md#graph_system_group_members_post) | **POST** /systemgroups/{group_id}/members | Manage the members of a System Group
*JCAPIv2::SystemGroupMembersMembershipApi* | [**graph_system_group_membership**](docs/SystemGroupMembersMembershipApi.md#graph_system_group_membership) | **GET** /systemgroups/{group_id}/membership | List the System Group's membership
*JCAPIv2::SystemGroupsApi* | [**graph_system_group_associations_list**](docs/SystemGroupsApi.md#graph_system_group_associations_list) | **GET** /systemgroups/{group_id}/associations | List the associations of a System Group
*JCAPIv2::SystemGroupsApi* | [**graph_system_group_associations_post**](docs/SystemGroupsApi.md#graph_system_group_associations_post) | **POST** /systemgroups/{group_id}/associations | Manage the associations of a System Group
*JCAPIv2::SystemGroupsApi* | [**graph_system_group_members_list**](docs/SystemGroupsApi.md#graph_system_group_members_list) | **GET** /systemgroups/{group_id}/members | List the members of a System Group
*JCAPIv2::SystemGroupsApi* | [**graph_system_group_members_post**](docs/SystemGroupsApi.md#graph_system_group_members_post) | **POST** /systemgroups/{group_id}/members | Manage the members of a System Group
*JCAPIv2::SystemGroupsApi* | [**graph_system_group_membership**](docs/SystemGroupsApi.md#graph_system_group_membership) | **GET** /systemgroups/{group_id}/membership | List the System Group's membership
*JCAPIv2::SystemGroupsApi* | [**graph_system_group_traverse_policy**](docs/SystemGroupsApi.md#graph_system_group_traverse_policy) | **GET** /systemgroups/{group_id}/policies | List the Policies bound to a System Group
*JCAPIv2::SystemGroupsApi* | [**graph_system_group_traverse_policy_group**](docs/SystemGroupsApi.md#graph_system_group_traverse_policy_group) | **GET** /systemgroups/{group_id}/policygroups | List the Policy Groups bound to a System Group
*JCAPIv2::SystemGroupsApi* | [**graph_system_group_traverse_user**](docs/SystemGroupsApi.md#graph_system_group_traverse_user) | **GET** /systemgroups/{group_id}/users | List the Users bound to a System Group
*JCAPIv2::SystemGroupsApi* | [**graph_system_group_traverse_user_group**](docs/SystemGroupsApi.md#graph_system_group_traverse_user_group) | **GET** /systemgroups/{group_id}/usergroups | List the User Groups bound to a System Group
*JCAPIv2::SystemGroupsApi* | [**groups_system_delete**](docs/SystemGroupsApi.md#groups_system_delete) | **DELETE** /systemgroups/{id} | Delete a System Group
*JCAPIv2::SystemGroupsApi* | [**groups_system_get**](docs/SystemGroupsApi.md#groups_system_get) | **GET** /systemgroups/{id} | View an individual System Group details
*JCAPIv2::SystemGroupsApi* | [**groups_system_list**](docs/SystemGroupsApi.md#groups_system_list) | **GET** /systemgroups | List all System Groups
*JCAPIv2::SystemGroupsApi* | [**groups_system_post**](docs/SystemGroupsApi.md#groups_system_post) | **POST** /systemgroups | Create a new System Group
*JCAPIv2::SystemGroupsApi* | [**groups_system_put**](docs/SystemGroupsApi.md#groups_system_put) | **PUT** /systemgroups/{id} | Update a System Group
*JCAPIv2::SystemGroupsApi* | [**groups_system_suggestions_get**](docs/SystemGroupsApi.md#groups_system_suggestions_get) | **GET** /systemgroups/{group_id}/suggestions | List Suggestions for a System Group
*JCAPIv2::SystemGroupsApi* | [**groups_system_suggestions_post**](docs/SystemGroupsApi.md#groups_system_suggestions_post) | **POST** /systemgroups/{group_id}/suggestions | Apply Suggestions for a System Group
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_alf**](docs/SystemInsightsApi.md#systeminsights_list_alf) | **GET** /systeminsights/alf | List System Insights ALF
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_alf_exceptions**](docs/SystemInsightsApi.md#systeminsights_list_alf_exceptions) | **GET** /systeminsights/alf_exceptions | List System Insights ALF Exceptions
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_alf_explicit_auths**](docs/SystemInsightsApi.md#systeminsights_list_alf_explicit_auths) | **GET** /systeminsights/alf_explicit_auths | List System Insights ALF Explicit Authentications
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_appcompat_shims**](docs/SystemInsightsApi.md#systeminsights_list_appcompat_shims) | **GET** /systeminsights/appcompat_shims | List System Insights Application Compatibility Shims
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_apps**](docs/SystemInsightsApi.md#systeminsights_list_apps) | **GET** /systeminsights/apps | List System Insights Apps
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_authorized_keys**](docs/SystemInsightsApi.md#systeminsights_list_authorized_keys) | **GET** /systeminsights/authorized_keys | List System Insights Authorized Keys
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_azure_instance_metadata**](docs/SystemInsightsApi.md#systeminsights_list_azure_instance_metadata) | **GET** /systeminsights/azure_instance_metadata | List System Insights Azure Instance Metadata
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_azure_instance_tags**](docs/SystemInsightsApi.md#systeminsights_list_azure_instance_tags) | **GET** /systeminsights/azure_instance_tags | List System Insights Azure Instance Tags
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_battery**](docs/SystemInsightsApi.md#systeminsights_list_battery) | **GET** /systeminsights/battery | List System Insights Battery
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_bitlocker_info**](docs/SystemInsightsApi.md#systeminsights_list_bitlocker_info) | **GET** /systeminsights/bitlocker_info | List System Insights Bitlocker Info
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_browser_plugins**](docs/SystemInsightsApi.md#systeminsights_list_browser_plugins) | **GET** /systeminsights/browser_plugins | List System Insights Browser Plugins
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_certificates**](docs/SystemInsightsApi.md#systeminsights_list_certificates) | **GET** /systeminsights/certificates | List System Insights Certificates
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_chassis_info**](docs/SystemInsightsApi.md#systeminsights_list_chassis_info) | **GET** /systeminsights/chassis_info | List System Insights Chassis Info
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_chrome_extensions**](docs/SystemInsightsApi.md#systeminsights_list_chrome_extensions) | **GET** /systeminsights/chrome_extensions | List System Insights Chrome Extensions
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_connectivity**](docs/SystemInsightsApi.md#systeminsights_list_connectivity) | **GET** /systeminsights/connectivity | List System Insights Connectivity
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_crashes**](docs/SystemInsightsApi.md#systeminsights_list_crashes) | **GET** /systeminsights/crashes | List System Insights Crashes
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_cups_destinations**](docs/SystemInsightsApi.md#systeminsights_list_cups_destinations) | **GET** /systeminsights/cups_destinations | List System Insights CUPS Destinations
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_disk_encryption**](docs/SystemInsightsApi.md#systeminsights_list_disk_encryption) | **GET** /systeminsights/disk_encryption | List System Insights Disk Encryption
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_disk_info**](docs/SystemInsightsApi.md#systeminsights_list_disk_info) | **GET** /systeminsights/disk_info | List System Insights Disk Info
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_dns_resolvers**](docs/SystemInsightsApi.md#systeminsights_list_dns_resolvers) | **GET** /systeminsights/dns_resolvers | List System Insights DNS Resolvers
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_etc_hosts**](docs/SystemInsightsApi.md#systeminsights_list_etc_hosts) | **GET** /systeminsights/etc_hosts | List System Insights Etc Hosts
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_firefox_addons**](docs/SystemInsightsApi.md#systeminsights_list_firefox_addons) | **GET** /systeminsights/firefox_addons | List System Insights Firefox Addons
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_groups**](docs/SystemInsightsApi.md#systeminsights_list_groups) | **GET** /systeminsights/groups | List System Insights Groups
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_ie_extensions**](docs/SystemInsightsApi.md#systeminsights_list_ie_extensions) | **GET** /systeminsights/ie_extensions | List System Insights IE Extensions
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_interface_addresses**](docs/SystemInsightsApi.md#systeminsights_list_interface_addresses) | **GET** /systeminsights/interface_addresses | List System Insights Interface Addresses
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_interface_details**](docs/SystemInsightsApi.md#systeminsights_list_interface_details) | **GET** /systeminsights/interface_details | List System Insights Interface Details
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_kernel_info**](docs/SystemInsightsApi.md#systeminsights_list_kernel_info) | **GET** /systeminsights/kernel_info | List System Insights Kernel Info
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_launchd**](docs/SystemInsightsApi.md#systeminsights_list_launchd) | **GET** /systeminsights/launchd | List System Insights Launchd
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_linux_packages**](docs/SystemInsightsApi.md#systeminsights_list_linux_packages) | **GET** /systeminsights/linux_packages | List System Insights Linux Packages
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_logged_in_users**](docs/SystemInsightsApi.md#systeminsights_list_logged_in_users) | **GET** /systeminsights/logged_in_users | List System Insights Logged-In Users
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_logical_drives**](docs/SystemInsightsApi.md#systeminsights_list_logical_drives) | **GET** /systeminsights/logical_drives | List System Insights Logical Drives
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_managed_policies**](docs/SystemInsightsApi.md#systeminsights_list_managed_policies) | **GET** /systeminsights/managed_policies | List System Insights Managed Policies
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_mounts**](docs/SystemInsightsApi.md#systeminsights_list_mounts) | **GET** /systeminsights/mounts | List System Insights Mounts
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_os_version**](docs/SystemInsightsApi.md#systeminsights_list_os_version) | **GET** /systeminsights/os_version | List System Insights OS Version
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_patches**](docs/SystemInsightsApi.md#systeminsights_list_patches) | **GET** /systeminsights/patches | List System Insights Patches
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_programs**](docs/SystemInsightsApi.md#systeminsights_list_programs) | **GET** /systeminsights/programs | List System Insights Programs
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_python_packages**](docs/SystemInsightsApi.md#systeminsights_list_python_packages) | **GET** /systeminsights/python_packages | List System Insights Python Packages
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_safari_extensions**](docs/SystemInsightsApi.md#systeminsights_list_safari_extensions) | **GET** /systeminsights/safari_extensions | List System Insights Safari Extensions
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_scheduled_tasks**](docs/SystemInsightsApi.md#systeminsights_list_scheduled_tasks) | **GET** /systeminsights/scheduled_tasks | List System Insights Scheduled Tasks
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_secureboot**](docs/SystemInsightsApi.md#systeminsights_list_secureboot) | **GET** /systeminsights/secureboot | List System Insights Secure Boot
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_services**](docs/SystemInsightsApi.md#systeminsights_list_services) | **GET** /systeminsights/services | List System Insights Services
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_shadow**](docs/SystemInsightsApi.md#systeminsights_list_shadow) | **GET** /systeminsights/shadow | LIst System Insights Shadow
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_shared_folders**](docs/SystemInsightsApi.md#systeminsights_list_shared_folders) | **GET** /systeminsights/shared_folders | List System Insights Shared Folders
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_shared_resources**](docs/SystemInsightsApi.md#systeminsights_list_shared_resources) | **GET** /systeminsights/shared_resources | List System Insights Shared Resources
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_sharing_preferences**](docs/SystemInsightsApi.md#systeminsights_list_sharing_preferences) | **GET** /systeminsights/sharing_preferences | List System Insights Sharing Preferences
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_sip_config**](docs/SystemInsightsApi.md#systeminsights_list_sip_config) | **GET** /systeminsights/sip_config | List System Insights SIP Config
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_startup_items**](docs/SystemInsightsApi.md#systeminsights_list_startup_items) | **GET** /systeminsights/startup_items | List System Insights Startup Items
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_system_controls**](docs/SystemInsightsApi.md#systeminsights_list_system_controls) | **GET** /systeminsights/system_controls | List System Insights System Control
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_system_info**](docs/SystemInsightsApi.md#systeminsights_list_system_info) | **GET** /systeminsights/system_info | List System Insights System Info
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_tpm_info**](docs/SystemInsightsApi.md#systeminsights_list_tpm_info) | **GET** /systeminsights/tpm_info | List System Insights TPM Info
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_uptime**](docs/SystemInsightsApi.md#systeminsights_list_uptime) | **GET** /systeminsights/uptime | List System Insights Uptime
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_usb_devices**](docs/SystemInsightsApi.md#systeminsights_list_usb_devices) | **GET** /systeminsights/usb_devices | List System Insights USB Devices
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_user_groups**](docs/SystemInsightsApi.md#systeminsights_list_user_groups) | **GET** /systeminsights/user_groups | List System Insights User Groups
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_user_ssh_keys**](docs/SystemInsightsApi.md#systeminsights_list_user_ssh_keys) | **GET** /systeminsights/user_ssh_keys | List System Insights User SSH Keys
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_userassist**](docs/SystemInsightsApi.md#systeminsights_list_userassist) | **GET** /systeminsights/userassist | List System Insights User Assist
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_users**](docs/SystemInsightsApi.md#systeminsights_list_users) | **GET** /systeminsights/users | List System Insights Users
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_wifi_networks**](docs/SystemInsightsApi.md#systeminsights_list_wifi_networks) | **GET** /systeminsights/wifi_networks | List System Insights WiFi Networks
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_wifi_status**](docs/SystemInsightsApi.md#systeminsights_list_wifi_status) | **GET** /systeminsights/wifi_status | List System Insights WiFi Status
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_windows_security_center**](docs/SystemInsightsApi.md#systeminsights_list_windows_security_center) | **GET** /systeminsights/windows_security_center | List System Insights Windows Security Center
*JCAPIv2::SystemInsightsApi* | [**systeminsights_list_windows_security_products**](docs/SystemInsightsApi.md#systeminsights_list_windows_security_products) | **GET** /systeminsights/windows_security_products | List System Insights Windows Security Products
*JCAPIv2::SystemsApi* | [**graph_system_associations_list**](docs/SystemsApi.md#graph_system_associations_list) | **GET** /systems/{system_id}/associations | List the associations of a System
*JCAPIv2::SystemsApi* | [**graph_system_associations_post**](docs/SystemsApi.md#graph_system_associations_post) | **POST** /systems/{system_id}/associations | Manage associations of a System
*JCAPIv2::SystemsApi* | [**graph_system_member_of**](docs/SystemsApi.md#graph_system_member_of) | **GET** /systems/{system_id}/memberof | List the parent Groups of a System
*JCAPIv2::SystemsApi* | [**graph_system_traverse_command**](docs/SystemsApi.md#graph_system_traverse_command) | **GET** /systems/{system_id}/commands | List the Commands bound to a System
*JCAPIv2::SystemsApi* | [**graph_system_traverse_policy**](docs/SystemsApi.md#graph_system_traverse_policy) | **GET** /systems/{system_id}/policies | List the Policies bound to a System
*JCAPIv2::SystemsApi* | [**graph_system_traverse_policy_group**](docs/SystemsApi.md#graph_system_traverse_policy_group) | **GET** /systems/{system_id}/policygroups | List the Policy Groups bound to a System
*JCAPIv2::SystemsApi* | [**graph_system_traverse_user**](docs/SystemsApi.md#graph_system_traverse_user) | **GET** /systems/{system_id}/users | List the Users bound to a System
*JCAPIv2::SystemsApi* | [**graph_system_traverse_user_group**](docs/SystemsApi.md#graph_system_traverse_user_group) | **GET** /systems/{system_id}/usergroups | List the User Groups bound to a System
*JCAPIv2::SystemsApi* | [**systems_get_fde_key**](docs/SystemsApi.md#systems_get_fde_key) | **GET** /systems/{system_id}/fdekey | Get System FDE Key
*JCAPIv2::SystemsApi* | [**systems_list_software_apps_with_statuses**](docs/SystemsApi.md#systems_list_software_apps_with_statuses) | **GET** /systems/{system_id}/softwareappstatuses | List the associated Software Application Statuses of a System
*JCAPIv2::SystemsOrganizationSettingsApi* | [**systems_org_settings_get_sign_in_with_jump_cloud_settings**](docs/SystemsOrganizationSettingsApi.md#systems_org_settings_get_sign_in_with_jump_cloud_settings) | **GET** /devices/settings/signinwithjumpcloud | Get the Sign In with JumpCloud Settings
*JCAPIv2::SystemsOrganizationSettingsApi* | [**systems_org_settings_set_sign_in_with_jump_cloud_settings**](docs/SystemsOrganizationSettingsApi.md#systems_org_settings_set_sign_in_with_jump_cloud_settings) | **PUT** /devices/settings/signinwithjumpcloud | Set the Sign In with JumpCloud Settings
*JCAPIv2::UserGroupAssociationsApi* | [**graph_user_group_associations_list**](docs/UserGroupAssociationsApi.md#graph_user_group_associations_list) | **GET** /usergroups/{group_id}/associations | List the associations of a User Group.
*JCAPIv2::UserGroupAssociationsApi* | [**graph_user_group_associations_post**](docs/UserGroupAssociationsApi.md#graph_user_group_associations_post) | **POST** /usergroups/{group_id}/associations | Manage the associations of a User Group
*JCAPIv2::UserGroupAssociationsApi* | [**graph_user_group_traverse_active_directory**](docs/UserGroupAssociationsApi.md#graph_user_group_traverse_active_directory) | **GET** /usergroups/{group_id}/activedirectories | List the Active Directories bound to a User Group
*JCAPIv2::UserGroupAssociationsApi* | [**graph_user_group_traverse_application**](docs/UserGroupAssociationsApi.md#graph_user_group_traverse_application) | **GET** /usergroups/{group_id}/applications | List the Applications bound to a User Group
*JCAPIv2::UserGroupAssociationsApi* | [**graph_user_group_traverse_directory**](docs/UserGroupAssociationsApi.md#graph_user_group_traverse_directory) | **GET** /usergroups/{group_id}/directories | List the Directories bound to a User Group
*JCAPIv2::UserGroupAssociationsApi* | [**graph_user_group_traverse_g_suite**](docs/UserGroupAssociationsApi.md#graph_user_group_traverse_g_suite) | **GET** /usergroups/{group_id}/gsuites | List the G Suite instances bound to a User Group
*JCAPIv2::UserGroupAssociationsApi* | [**graph_user_group_traverse_ldap_server**](docs/UserGroupAssociationsApi.md#graph_user_group_traverse_ldap_server) | **GET** /usergroups/{group_id}/ldapservers | List the LDAP Servers bound to a User Group
*JCAPIv2::UserGroupAssociationsApi* | [**graph_user_group_traverse_office365**](docs/UserGroupAssociationsApi.md#graph_user_group_traverse_office365) | **GET** /usergroups/{group_id}/office365s | List the Office 365 instances bound to a User Group
*JCAPIv2::UserGroupAssociationsApi* | [**graph_user_group_traverse_radius_server**](docs/UserGroupAssociationsApi.md#graph_user_group_traverse_radius_server) | **GET** /usergroups/{group_id}/radiusservers | List the RADIUS Servers bound to a User Group
*JCAPIv2::UserGroupAssociationsApi* | [**graph_user_group_traverse_system**](docs/UserGroupAssociationsApi.md#graph_user_group_traverse_system) | **GET** /usergroups/{group_id}/systems | List the Systems bound to a User Group
*JCAPIv2::UserGroupAssociationsApi* | [**graph_user_group_traverse_system_group**](docs/UserGroupAssociationsApi.md#graph_user_group_traverse_system_group) | **GET** /usergroups/{group_id}/systemgroups | List the System Groups bound to User Groups
*JCAPIv2::UserGroupMembersMembershipApi* | [**graph_user_group_members_list**](docs/UserGroupMembersMembershipApi.md#graph_user_group_members_list) | **GET** /usergroups/{group_id}/members | List the members of a User Group
*JCAPIv2::UserGroupMembersMembershipApi* | [**graph_user_group_members_post**](docs/UserGroupMembersMembershipApi.md#graph_user_group_members_post) | **POST** /usergroups/{group_id}/members | Manage the members of a User Group
*JCAPIv2::UserGroupMembersMembershipApi* | [**graph_user_group_membership**](docs/UserGroupMembersMembershipApi.md#graph_user_group_membership) | **GET** /usergroups/{group_id}/membership | List the User Group's membership
*JCAPIv2::UserGroupsApi* | [**graph_user_group_associations_list**](docs/UserGroupsApi.md#graph_user_group_associations_list) | **GET** /usergroups/{group_id}/associations | List the associations of a User Group.
*JCAPIv2::UserGroupsApi* | [**graph_user_group_associations_post**](docs/UserGroupsApi.md#graph_user_group_associations_post) | **POST** /usergroups/{group_id}/associations | Manage the associations of a User Group
*JCAPIv2::UserGroupsApi* | [**graph_user_group_members_list**](docs/UserGroupsApi.md#graph_user_group_members_list) | **GET** /usergroups/{group_id}/members | List the members of a User Group
*JCAPIv2::UserGroupsApi* | [**graph_user_group_members_post**](docs/UserGroupsApi.md#graph_user_group_members_post) | **POST** /usergroups/{group_id}/members | Manage the members of a User Group
*JCAPIv2::UserGroupsApi* | [**graph_user_group_membership**](docs/UserGroupsApi.md#graph_user_group_membership) | **GET** /usergroups/{group_id}/membership | List the User Group's membership
*JCAPIv2::UserGroupsApi* | [**graph_user_group_traverse_active_directory**](docs/UserGroupsApi.md#graph_user_group_traverse_active_directory) | **GET** /usergroups/{group_id}/activedirectories | List the Active Directories bound to a User Group
*JCAPIv2::UserGroupsApi* | [**graph_user_group_traverse_application**](docs/UserGroupsApi.md#graph_user_group_traverse_application) | **GET** /usergroups/{group_id}/applications | List the Applications bound to a User Group
*JCAPIv2::UserGroupsApi* | [**graph_user_group_traverse_directory**](docs/UserGroupsApi.md#graph_user_group_traverse_directory) | **GET** /usergroups/{group_id}/directories | List the Directories bound to a User Group
*JCAPIv2::UserGroupsApi* | [**graph_user_group_traverse_g_suite**](docs/UserGroupsApi.md#graph_user_group_traverse_g_suite) | **GET** /usergroups/{group_id}/gsuites | List the G Suite instances bound to a User Group
*JCAPIv2::UserGroupsApi* | [**graph_user_group_traverse_ldap_server**](docs/UserGroupsApi.md#graph_user_group_traverse_ldap_server) | **GET** /usergroups/{group_id}/ldapservers | List the LDAP Servers bound to a User Group
*JCAPIv2::UserGroupsApi* | [**graph_user_group_traverse_office365**](docs/UserGroupsApi.md#graph_user_group_traverse_office365) | **GET** /usergroups/{group_id}/office365s | List the Office 365 instances bound to a User Group
*JCAPIv2::UserGroupsApi* | [**graph_user_group_traverse_radius_server**](docs/UserGroupsApi.md#graph_user_group_traverse_radius_server) | **GET** /usergroups/{group_id}/radiusservers | List the RADIUS Servers bound to a User Group
*JCAPIv2::UserGroupsApi* | [**graph_user_group_traverse_system**](docs/UserGroupsApi.md#graph_user_group_traverse_system) | **GET** /usergroups/{group_id}/systems | List the Systems bound to a User Group
*JCAPIv2::UserGroupsApi* | [**graph_user_group_traverse_system_group**](docs/UserGroupsApi.md#graph_user_group_traverse_system_group) | **GET** /usergroups/{group_id}/systemgroups | List the System Groups bound to User Groups
*JCAPIv2::UserGroupsApi* | [**groups_user_delete**](docs/UserGroupsApi.md#groups_user_delete) | **DELETE** /usergroups/{id} | Delete a User Group
*JCAPIv2::UserGroupsApi* | [**groups_user_get**](docs/UserGroupsApi.md#groups_user_get) | **GET** /usergroups/{id} | View an individual User Group details
*JCAPIv2::UserGroupsApi* | [**groups_user_list**](docs/UserGroupsApi.md#groups_user_list) | **GET** /usergroups | List all User Groups
*JCAPIv2::UserGroupsApi* | [**groups_user_post**](docs/UserGroupsApi.md#groups_user_post) | **POST** /usergroups | Create a new User Group
*JCAPIv2::UserGroupsApi* | [**groups_user_put**](docs/UserGroupsApi.md#groups_user_put) | **PUT** /usergroups/{id} | Update a User Group
*JCAPIv2::UserGroupsApi* | [**groups_user_suggestions_get**](docs/UserGroupsApi.md#groups_user_suggestions_get) | **GET** /usergroups/{group_id}/suggestions | List Suggestions for a User Group
*JCAPIv2::UserGroupsApi* | [**groups_user_suggestions_post**](docs/UserGroupsApi.md#groups_user_suggestions_post) | **POST** /usergroups/{group_id}/suggestions | Apply Suggestions for a User Group
*JCAPIv2::UsersApi* | [**graph_user_associations_list**](docs/UsersApi.md#graph_user_associations_list) | **GET** /users/{user_id}/associations | List the associations of a User
*JCAPIv2::UsersApi* | [**graph_user_associations_post**](docs/UsersApi.md#graph_user_associations_post) | **POST** /users/{user_id}/associations | Manage the associations of a User
*JCAPIv2::UsersApi* | [**graph_user_member_of**](docs/UsersApi.md#graph_user_member_of) | **GET** /users/{user_id}/memberof | List the parent Groups of a User
*JCAPIv2::UsersApi* | [**graph_user_traverse_active_directory**](docs/UsersApi.md#graph_user_traverse_active_directory) | **GET** /users/{user_id}/activedirectories | List the Active Directory instances bound to a User
*JCAPIv2::UsersApi* | [**graph_user_traverse_application**](docs/UsersApi.md#graph_user_traverse_application) | **GET** /users/{user_id}/applications | List the Applications bound to a User
*JCAPIv2::UsersApi* | [**graph_user_traverse_directory**](docs/UsersApi.md#graph_user_traverse_directory) | **GET** /users/{user_id}/directories | List the Directories bound to a User
*JCAPIv2::UsersApi* | [**graph_user_traverse_g_suite**](docs/UsersApi.md#graph_user_traverse_g_suite) | **GET** /users/{user_id}/gsuites | List the G Suite instances bound to a User
*JCAPIv2::UsersApi* | [**graph_user_traverse_ldap_server**](docs/UsersApi.md#graph_user_traverse_ldap_server) | **GET** /users/{user_id}/ldapservers | List the LDAP servers bound to a User
*JCAPIv2::UsersApi* | [**graph_user_traverse_office365**](docs/UsersApi.md#graph_user_traverse_office365) | **GET** /users/{user_id}/office365s | List the Office 365 instances bound to a User
*JCAPIv2::UsersApi* | [**graph_user_traverse_radius_server**](docs/UsersApi.md#graph_user_traverse_radius_server) | **GET** /users/{user_id}/radiusservers | List the RADIUS Servers bound to a User
*JCAPIv2::UsersApi* | [**graph_user_traverse_system**](docs/UsersApi.md#graph_user_traverse_system) | **GET** /users/{user_id}/systems | List the Systems bound to a User
*JCAPIv2::UsersApi* | [**graph_user_traverse_system_group**](docs/UsersApi.md#graph_user_traverse_system_group) | **GET** /users/{user_id}/systemgroups | List the System Groups bound to a User
*JCAPIv2::UsersApi* | [**push_endpoints_delete**](docs/UsersApi.md#push_endpoints_delete) | **DELETE** /users/{user_id}/pushendpoints/{push_endpoint_id} | Delete a Push Endpoint associated with a User
*JCAPIv2::UsersApi* | [**push_endpoints_get**](docs/UsersApi.md#push_endpoints_get) | **GET** /users/{user_id}/pushendpoints/{push_endpoint_id} | Get a push endpoint associated with a User
*JCAPIv2::UsersApi* | [**push_endpoints_list**](docs/UsersApi.md#push_endpoints_list) | **GET** /users/{user_id}/pushendpoints | List Push Endpoints associated with a User
*JCAPIv2::UsersApi* | [**push_endpoints_patch**](docs/UsersApi.md#push_endpoints_patch) | **PATCH** /users/{user_id}/pushendpoints/{push_endpoint_id} | Update a push endpoint associated with a User
*JCAPIv2::WorkdayImportApi* | [**workdays_authorize**](docs/WorkdayImportApi.md#workdays_authorize) | **POST** /workdays/{workday_id}/auth | Authorize Workday
*JCAPIv2::WorkdayImportApi* | [**workdays_deauthorize**](docs/WorkdayImportApi.md#workdays_deauthorize) | **DELETE** /workdays/{workday_id}/auth | Deauthorize Workday
*JCAPIv2::WorkdayImportApi* | [**workdays_get**](docs/WorkdayImportApi.md#workdays_get) | **GET** /workdays/{id} | Get Workday
*JCAPIv2::WorkdayImportApi* | [**workdays_import**](docs/WorkdayImportApi.md#workdays_import) | **POST** /workdays/{workday_id}/import | Workday Import
*JCAPIv2::WorkdayImportApi* | [**workdays_importresults**](docs/WorkdayImportApi.md#workdays_importresults) | **GET** /workdays/{id}/import/{job_id}/results | List Import Results
*JCAPIv2::WorkdayImportApi* | [**workdays_list**](docs/WorkdayImportApi.md#workdays_list) | **GET** /workdays | List Workdays
*JCAPIv2::WorkdayImportApi* | [**workdays_post**](docs/WorkdayImportApi.md#workdays_post) | **POST** /workdays | Create new Workday
*JCAPIv2::WorkdayImportApi* | [**workdays_put**](docs/WorkdayImportApi.md#workdays_put) | **PUT** /workdays/{id} | Update Workday
*JCAPIv2::WorkdayImportApi* | [**workdays_workers**](docs/WorkdayImportApi.md#workdays_workers) | **GET** /workdays/{workday_id}/workers | List Workday Workers

## Documentation for Models

 - [JCAPIv2::ADE](docs/ADE.md)
 - [JCAPIv2::ADES](docs/ADES.md)
 - [JCAPIv2::ActiveDirectory](docs/ActiveDirectory.md)
 - [JCAPIv2::ActiveDirectoryAgent](docs/ActiveDirectoryAgent.md)
 - [JCAPIv2::ActiveDirectoryAgentGet](docs/ActiveDirectoryAgentGet.md)
 - [JCAPIv2::ActiveDirectoryAgentList](docs/ActiveDirectoryAgentList.md)
 - [JCAPIv2::Address](docs/Address.md)
 - [JCAPIv2::Administrator](docs/Administrator.md)
 - [JCAPIv2::AdministratorOrganizationLink](docs/AdministratorOrganizationLink.md)
 - [JCAPIv2::AdministratorOrganizationLinkReq](docs/AdministratorOrganizationLinkReq.md)
 - [JCAPIv2::AllOfAutotaskTicketingAlertConfigurationListRecordsItems](docs/AllOfAutotaskTicketingAlertConfigurationListRecordsItems.md)
 - [JCAPIv2::AllOfConnectWiseTicketingAlertConfigurationListRecordsItems](docs/AllOfConnectWiseTicketingAlertConfigurationListRecordsItems.md)
 - [JCAPIv2::AllOfPwmAllUsersResultsItems](docs/AllOfPwmAllUsersResultsItems.md)
 - [JCAPIv2::AllOfPwmItemsMetadataResultsItems](docs/AllOfPwmItemsMetadataResultsItems.md)
 - [JCAPIv2::AllOfSyncroTicketingAlertConfigurationListRecordsItems](docs/AllOfSyncroTicketingAlertConfigurationListRecordsItems.md)
 - [JCAPIv2::AnyValue](docs/AnyValue.md)
 - [JCAPIv2::AppleMDM](docs/AppleMDM.md)
 - [JCAPIv2::AppleMdmDevice](docs/AppleMdmDevice.md)
 - [JCAPIv2::AppleMdmDeviceInfo](docs/AppleMdmDeviceInfo.md)
 - [JCAPIv2::AppleMdmDeviceSecurityInfo](docs/AppleMdmDeviceSecurityInfo.md)
 - [JCAPIv2::AppleMdmPatch](docs/AppleMdmPatch.md)
 - [JCAPIv2::AppleMdmPublicKeyCert](docs/AppleMdmPublicKeyCert.md)
 - [JCAPIv2::AppleMdmSignedCsrPlist](docs/AppleMdmSignedCsrPlist.md)
 - [JCAPIv2::ApplicationIdLogoBody](docs/ApplicationIdLogoBody.md)
 - [JCAPIv2::Apps](docs/Apps.md)
 - [JCAPIv2::AppsInner](docs/AppsInner.md)
 - [JCAPIv2::AuthInfo](docs/AuthInfo.md)
 - [JCAPIv2::AuthInput](docs/AuthInput.md)
 - [JCAPIv2::AuthInputObject](docs/AuthInputObject.md)
 - [JCAPIv2::AuthinputBasic](docs/AuthinputBasic.md)
 - [JCAPIv2::AuthinputOauth](docs/AuthinputOauth.md)
 - [JCAPIv2::AuthnPolicy](docs/AuthnPolicy.md)
 - [JCAPIv2::AuthnPolicyEffect](docs/AuthnPolicyEffect.md)
 - [JCAPIv2::AuthnPolicyObligations](docs/AuthnPolicyObligations.md)
 - [JCAPIv2::AuthnPolicyObligationsExternalIdentityProvider](docs/AuthnPolicyObligationsExternalIdentityProvider.md)
 - [JCAPIv2::AuthnPolicyObligationsMfa](docs/AuthnPolicyObligationsMfa.md)
 - [JCAPIv2::AuthnPolicyObligationsUserVerification](docs/AuthnPolicyObligationsUserVerification.md)
 - [JCAPIv2::AuthnPolicyResourceTarget](docs/AuthnPolicyResourceTarget.md)
 - [JCAPIv2::AuthnPolicyTargets](docs/AuthnPolicyTargets.md)
 - [JCAPIv2::AuthnPolicyType](docs/AuthnPolicyType.md)
 - [JCAPIv2::AuthnPolicyUserAttributeFilter](docs/AuthnPolicyUserAttributeFilter.md)
 - [JCAPIv2::AuthnPolicyUserAttributeTarget](docs/AuthnPolicyUserAttributeTarget.md)
 - [JCAPIv2::AuthnPolicyUserGroupTarget](docs/AuthnPolicyUserGroupTarget.md)
 - [JCAPIv2::AuthnPolicyUserTarget](docs/AuthnPolicyUserTarget.md)
 - [JCAPIv2::AutotaskCompany](docs/AutotaskCompany.md)
 - [JCAPIv2::AutotaskCompanyResp](docs/AutotaskCompanyResp.md)
 - [JCAPIv2::AutotaskCompanyTypeResp](docs/AutotaskCompanyTypeResp.md)
 - [JCAPIv2::AutotaskContract](docs/AutotaskContract.md)
 - [JCAPIv2::AutotaskContractField](docs/AutotaskContractField.md)
 - [JCAPIv2::AutotaskContractFieldValues](docs/AutotaskContractFieldValues.md)
 - [JCAPIv2::AutotaskIntegration](docs/AutotaskIntegration.md)
 - [JCAPIv2::AutotaskIntegrationPatchReq](docs/AutotaskIntegrationPatchReq.md)
 - [JCAPIv2::AutotaskIntegrationReq](docs/AutotaskIntegrationReq.md)
 - [JCAPIv2::AutotaskMappingRequest](docs/AutotaskMappingRequest.md)
 - [JCAPIv2::AutotaskMappingRequestCompany](docs/AutotaskMappingRequestCompany.md)
 - [JCAPIv2::AutotaskMappingRequestContract](docs/AutotaskMappingRequestContract.md)
 - [JCAPIv2::AutotaskMappingRequestData](docs/AutotaskMappingRequestData.md)
 - [JCAPIv2::AutotaskMappingRequestOrganization](docs/AutotaskMappingRequestOrganization.md)
 - [JCAPIv2::AutotaskMappingRequestService](docs/AutotaskMappingRequestService.md)
 - [JCAPIv2::AutotaskMappingResponse](docs/AutotaskMappingResponse.md)
 - [JCAPIv2::AutotaskMappingResponseCompany](docs/AutotaskMappingResponseCompany.md)
 - [JCAPIv2::AutotaskMappingResponseContract](docs/AutotaskMappingResponseContract.md)
 - [JCAPIv2::AutotaskMappingResponseOrganization](docs/AutotaskMappingResponseOrganization.md)
 - [JCAPIv2::AutotaskMappingResponseService](docs/AutotaskMappingResponseService.md)
 - [JCAPIv2::AutotaskService](docs/AutotaskService.md)
 - [JCAPIv2::AutotaskSettings](docs/AutotaskSettings.md)
 - [JCAPIv2::AutotaskSettingsPatchReq](docs/AutotaskSettingsPatchReq.md)
 - [JCAPIv2::AutotaskTicketingAlertConfiguration](docs/AutotaskTicketingAlertConfiguration.md)
 - [JCAPIv2::AutotaskTicketingAlertConfigurationList](docs/AutotaskTicketingAlertConfigurationList.md)
 - [JCAPIv2::AutotaskTicketingAlertConfigurationOption](docs/AutotaskTicketingAlertConfigurationOption.md)
 - [JCAPIv2::AutotaskTicketingAlertConfigurationOptionValues](docs/AutotaskTicketingAlertConfigurationOptionValues.md)
 - [JCAPIv2::AutotaskTicketingAlertConfigurationOptions](docs/AutotaskTicketingAlertConfigurationOptions.md)
 - [JCAPIv2::AutotaskTicketingAlertConfigurationPriority](docs/AutotaskTicketingAlertConfigurationPriority.md)
 - [JCAPIv2::AutotaskTicketingAlertConfigurationRequest](docs/AutotaskTicketingAlertConfigurationRequest.md)
 - [JCAPIv2::AutotaskTicketingAlertConfigurationResource](docs/AutotaskTicketingAlertConfigurationResource.md)
 - [JCAPIv2::BillingIntegrationCompanyType](docs/BillingIntegrationCompanyType.md)
 - [JCAPIv2::BulkScheduledStatechangeCreate](docs/BulkScheduledStatechangeCreate.md)
 - [JCAPIv2::BulkUserCreate](docs/BulkUserCreate.md)
 - [JCAPIv2::BulkUserExpire](docs/BulkUserExpire.md)
 - [JCAPIv2::BulkUserUnlock](docs/BulkUserUnlock.md)
 - [JCAPIv2::BulkUserUpdate](docs/BulkUserUpdate.md)
 - [JCAPIv2::CasesResponse](docs/CasesResponse.md)
 - [JCAPIv2::CommandResultList](docs/CommandResultList.md)
 - [JCAPIv2::CommandResultListResults](docs/CommandResultListResults.md)
 - [JCAPIv2::CommandsGraphObjectWithPaths](docs/CommandsGraphObjectWithPaths.md)
 - [JCAPIv2::ConfiguredPolicyTemplate](docs/ConfiguredPolicyTemplate.md)
 - [JCAPIv2::ConfiguredPolicyTemplateValue](docs/ConfiguredPolicyTemplateValue.md)
 - [JCAPIv2::ConnectWiseMappingRequest](docs/ConnectWiseMappingRequest.md)
 - [JCAPIv2::ConnectWiseMappingRequestCompany](docs/ConnectWiseMappingRequestCompany.md)
 - [JCAPIv2::ConnectWiseMappingRequestData](docs/ConnectWiseMappingRequestData.md)
 - [JCAPIv2::ConnectWiseMappingRequestOrganization](docs/ConnectWiseMappingRequestOrganization.md)
 - [JCAPIv2::ConnectWiseMappingResponse](docs/ConnectWiseMappingResponse.md)
 - [JCAPIv2::ConnectWiseMappingResponseAddition](docs/ConnectWiseMappingResponseAddition.md)
 - [JCAPIv2::ConnectWiseSettings](docs/ConnectWiseSettings.md)
 - [JCAPIv2::ConnectWiseSettingsPatchReq](docs/ConnectWiseSettingsPatchReq.md)
 - [JCAPIv2::ConnectWiseTicketingAlertConfiguration](docs/ConnectWiseTicketingAlertConfiguration.md)
 - [JCAPIv2::ConnectWiseTicketingAlertConfigurationList](docs/ConnectWiseTicketingAlertConfigurationList.md)
 - [JCAPIv2::ConnectWiseTicketingAlertConfigurationOption](docs/ConnectWiseTicketingAlertConfigurationOption.md)
 - [JCAPIv2::ConnectWiseTicketingAlertConfigurationOptions](docs/ConnectWiseTicketingAlertConfigurationOptions.md)
 - [JCAPIv2::ConnectWiseTicketingAlertConfigurationRequest](docs/ConnectWiseTicketingAlertConfigurationRequest.md)
 - [JCAPIv2::ConnectwiseAddition](docs/ConnectwiseAddition.md)
 - [JCAPIv2::ConnectwiseAgreement](docs/ConnectwiseAgreement.md)
 - [JCAPIv2::ConnectwiseCompany](docs/ConnectwiseCompany.md)
 - [JCAPIv2::ConnectwiseCompanyResp](docs/ConnectwiseCompanyResp.md)
 - [JCAPIv2::ConnectwiseCompanyTypeResp](docs/ConnectwiseCompanyTypeResp.md)
 - [JCAPIv2::ConnectwiseIntegration](docs/ConnectwiseIntegration.md)
 - [JCAPIv2::ConnectwiseIntegrationPatchReq](docs/ConnectwiseIntegrationPatchReq.md)
 - [JCAPIv2::ConnectwiseIntegrationReq](docs/ConnectwiseIntegrationReq.md)
 - [JCAPIv2::CreateOrganization](docs/CreateOrganization.md)
 - [JCAPIv2::CustomEmail](docs/CustomEmail.md)
 - [JCAPIv2::CustomEmailTemplate](docs/CustomEmailTemplate.md)
 - [JCAPIv2::CustomEmailTemplateField](docs/CustomEmailTemplateField.md)
 - [JCAPIv2::CustomEmailType](docs/CustomEmailType.md)
 - [JCAPIv2::DEP](docs/DEP.md)
 - [JCAPIv2::DEPSetupAssistantOption](docs/DEPSetupAssistantOption.md)
 - [JCAPIv2::DEPWelcomeScreen](docs/DEPWelcomeScreen.md)
 - [JCAPIv2::DefaultDomain](docs/DefaultDomain.md)
 - [JCAPIv2::DeviceIdEraseBody](docs/DeviceIdEraseBody.md)
 - [JCAPIv2::DeviceIdLockBody](docs/DeviceIdLockBody.md)
 - [JCAPIv2::DeviceIdResetpasswordBody](docs/DeviceIdResetpasswordBody.md)
 - [JCAPIv2::DeviceIdRestartBody](docs/DeviceIdRestartBody.md)
 - [JCAPIv2::DevicePackageV1Device](docs/DevicePackageV1Device.md)
 - [JCAPIv2::DevicePackageV1ListDevicesResponse](docs/DevicePackageV1ListDevicesResponse.md)
 - [JCAPIv2::DevicesGetSignInWithJumpCloudSettingsResponse](docs/DevicesGetSignInWithJumpCloudSettingsResponse.md)
 - [JCAPIv2::DevicesSetSignInWithJumpCloudSettingsRequest](docs/DevicesSetSignInWithJumpCloudSettingsRequest.md)
 - [JCAPIv2::DevicesSignInWithJumpCloudSetting](docs/DevicesSignInWithJumpCloudSetting.md)
 - [JCAPIv2::DevicesSignInWithJumpCloudSettingOSFamily](docs/DevicesSignInWithJumpCloudSettingOSFamily.md)
 - [JCAPIv2::DevicesSignInWithJumpCloudSettingPermission](docs/DevicesSignInWithJumpCloudSettingPermission.md)
 - [JCAPIv2::Directory](docs/Directory.md)
 - [JCAPIv2::DirectoryDefaultDomain](docs/DirectoryDefaultDomain.md)
 - [JCAPIv2::DuoAccount](docs/DuoAccount.md)
 - [JCAPIv2::DuoApplication](docs/DuoApplication.md)
 - [JCAPIv2::DuoApplicationReq](docs/DuoApplicationReq.md)
 - [JCAPIv2::DuoApplicationUpdateReq](docs/DuoApplicationUpdateReq.md)
 - [JCAPIv2::EnterprisesEnterpriseIdBody](docs/EnterprisesEnterpriseIdBody.md)
 - [JCAPIv2::Error](docs/Error.md)
 - [JCAPIv2::ErrorDetails](docs/ErrorDetails.md)
 - [JCAPIv2::Feature](docs/Feature.md)
 - [JCAPIv2::FeatureTrialData](docs/FeatureTrialData.md)
 - [JCAPIv2::Filter](docs/Filter.md)
 - [JCAPIv2::FilterQuery](docs/FilterQuery.md)
 - [JCAPIv2::GSuiteBuiltinTranslation](docs/GSuiteBuiltinTranslation.md)
 - [JCAPIv2::GSuiteDirectionTranslation](docs/GSuiteDirectionTranslation.md)
 - [JCAPIv2::GSuiteTranslationRule](docs/GSuiteTranslationRule.md)
 - [JCAPIv2::GSuiteTranslationRuleRequest](docs/GSuiteTranslationRuleRequest.md)
 - [JCAPIv2::GoogleProtobufAny](docs/GoogleProtobufAny.md)
 - [JCAPIv2::GoogleRpcStatus](docs/GoogleRpcStatus.md)
 - [JCAPIv2::GraphAttributeLdapGroups](docs/GraphAttributeLdapGroups.md)
 - [JCAPIv2::GraphAttributePosixGroups](docs/GraphAttributePosixGroups.md)
 - [JCAPIv2::GraphAttributePosixGroupsPosixGroups](docs/GraphAttributePosixGroupsPosixGroups.md)
 - [JCAPIv2::GraphAttributeRadius](docs/GraphAttributeRadius.md)
 - [JCAPIv2::GraphAttributeRadiusRadius](docs/GraphAttributeRadiusRadius.md)
 - [JCAPIv2::GraphAttributeRadiusRadiusReply](docs/GraphAttributeRadiusRadiusReply.md)
 - [JCAPIv2::GraphAttributeSambaEnabled](docs/GraphAttributeSambaEnabled.md)
 - [JCAPIv2::GraphAttributeSudo](docs/GraphAttributeSudo.md)
 - [JCAPIv2::GraphAttributeSudoSudo](docs/GraphAttributeSudoSudo.md)
 - [JCAPIv2::GraphAttributes](docs/GraphAttributes.md)
 - [JCAPIv2::GraphConnection](docs/GraphConnection.md)
 - [JCAPIv2::GraphObject](docs/GraphObject.md)
 - [JCAPIv2::GraphObjectWithPaths](docs/GraphObjectWithPaths.md)
 - [JCAPIv2::GraphOperation](docs/GraphOperation.md)
 - [JCAPIv2::GraphOperationActiveDirectory](docs/GraphOperationActiveDirectory.md)
 - [JCAPIv2::GraphOperationApplication](docs/GraphOperationApplication.md)
 - [JCAPIv2::GraphOperationCommand](docs/GraphOperationCommand.md)
 - [JCAPIv2::GraphOperationGSuite](docs/GraphOperationGSuite.md)
 - [JCAPIv2::GraphOperationLdapServer](docs/GraphOperationLdapServer.md)
 - [JCAPIv2::GraphOperationOffice365](docs/GraphOperationOffice365.md)
 - [JCAPIv2::GraphOperationPolicy](docs/GraphOperationPolicy.md)
 - [JCAPIv2::GraphOperationPolicyGroup](docs/GraphOperationPolicyGroup.md)
 - [JCAPIv2::GraphOperationPolicyGroupMember](docs/GraphOperationPolicyGroupMember.md)
 - [JCAPIv2::GraphOperationRadiusServer](docs/GraphOperationRadiusServer.md)
 - [JCAPIv2::GraphOperationSoftwareApp](docs/GraphOperationSoftwareApp.md)
 - [JCAPIv2::GraphOperationSystem](docs/GraphOperationSystem.md)
 - [JCAPIv2::GraphOperationSystemGroup](docs/GraphOperationSystemGroup.md)
 - [JCAPIv2::GraphOperationSystemGroupMember](docs/GraphOperationSystemGroupMember.md)
 - [JCAPIv2::GraphOperationUser](docs/GraphOperationUser.md)
 - [JCAPIv2::GraphOperationUserGroup](docs/GraphOperationUserGroup.md)
 - [JCAPIv2::GraphOperationUserGroupMember](docs/GraphOperationUserGroupMember.md)
 - [JCAPIv2::GraphType](docs/GraphType.md)
 - [JCAPIv2::Group](docs/Group.md)
 - [JCAPIv2::GroupAttributesUserGroup](docs/GroupAttributesUserGroup.md)
 - [JCAPIv2::GroupIdSuggestionsBody](docs/GroupIdSuggestionsBody.md)
 - [JCAPIv2::GroupIdSuggestionsBody1](docs/GroupIdSuggestionsBody1.md)
 - [JCAPIv2::GroupMembershipMethodType](docs/GroupMembershipMethodType.md)
 - [JCAPIv2::GroupPwm](docs/GroupPwm.md)
 - [JCAPIv2::GroupType](docs/GroupType.md)
 - [JCAPIv2::Groups](docs/Groups.md)
 - [JCAPIv2::GroupsInner](docs/GroupsInner.md)
 - [JCAPIv2::Gsuite](docs/Gsuite.md)
 - [JCAPIv2::IPList](docs/IPList.md)
 - [JCAPIv2::IPListRequest](docs/IPListRequest.md)
 - [JCAPIv2::ImportOperation](docs/ImportOperation.md)
 - [JCAPIv2::ImportUser](docs/ImportUser.md)
 - [JCAPIv2::ImportUserAddress](docs/ImportUserAddress.md)
 - [JCAPIv2::ImportUserPhoneNumber](docs/ImportUserPhoneNumber.md)
 - [JCAPIv2::ImportUsersRequest](docs/ImportUsersRequest.md)
 - [JCAPIv2::ImportUsersResponse](docs/ImportUsersResponse.md)
 - [JCAPIv2::InlineResponse200](docs/InlineResponse200.md)
 - [JCAPIv2::InlineResponse2001](docs/InlineResponse2001.md)
 - [JCAPIv2::InlineResponse20010](docs/InlineResponse20010.md)
 - [JCAPIv2::InlineResponse20011](docs/InlineResponse20011.md)
 - [JCAPIv2::InlineResponse20012](docs/InlineResponse20012.md)
 - [JCAPIv2::InlineResponse20012Users](docs/InlineResponse20012Users.md)
 - [JCAPIv2::InlineResponse20013](docs/InlineResponse20013.md)
 - [JCAPIv2::InlineResponse20014](docs/InlineResponse20014.md)
 - [JCAPIv2::InlineResponse20015](docs/InlineResponse20015.md)
 - [JCAPIv2::InlineResponse2002](docs/InlineResponse2002.md)
 - [JCAPIv2::InlineResponse2002Users](docs/InlineResponse2002Users.md)
 - [JCAPIv2::InlineResponse2003](docs/InlineResponse2003.md)
 - [JCAPIv2::InlineResponse2004](docs/InlineResponse2004.md)
 - [JCAPIv2::InlineResponse2005](docs/InlineResponse2005.md)
 - [JCAPIv2::InlineResponse2006](docs/InlineResponse2006.md)
 - [JCAPIv2::InlineResponse2007](docs/InlineResponse2007.md)
 - [JCAPIv2::InlineResponse2008](docs/InlineResponse2008.md)
 - [JCAPIv2::InlineResponse2009](docs/InlineResponse2009.md)
 - [JCAPIv2::InlineResponse201](docs/InlineResponse201.md)
 - [JCAPIv2::InlineResponse400](docs/InlineResponse400.md)
 - [JCAPIv2::InstallActionType](docs/InstallActionType.md)
 - [JCAPIv2::Integration](docs/Integration.md)
 - [JCAPIv2::IntegrationSyncError](docs/IntegrationSyncError.md)
 - [JCAPIv2::IntegrationSyncErrorResp](docs/IntegrationSyncErrorResp.md)
 - [JCAPIv2::IntegrationType](docs/IntegrationType.md)
 - [JCAPIv2::IntegrationsResponse](docs/IntegrationsResponse.md)
 - [JCAPIv2::JobId](docs/JobId.md)
 - [JCAPIv2::JobWorkresult](docs/JobWorkresult.md)
 - [JCAPIv2::JumpcloudGappsDomain](docs/JumpcloudGappsDomain.md)
 - [JCAPIv2::JumpcloudGappsDomainListResponse](docs/JumpcloudGappsDomainListResponse.md)
 - [JCAPIv2::JumpcloudGappsDomainResponse](docs/JumpcloudGappsDomainResponse.md)
 - [JCAPIv2::JumpcloudGoogleEmmAllowPersonalUsage](docs/JumpcloudGoogleEmmAllowPersonalUsage.md)
 - [JCAPIv2::JumpcloudGoogleEmmCommandResponse](docs/JumpcloudGoogleEmmCommandResponse.md)
 - [JCAPIv2::JumpcloudGoogleEmmCommonCriteriaModeInfo](docs/JumpcloudGoogleEmmCommonCriteriaModeInfo.md)
 - [JCAPIv2::JumpcloudGoogleEmmConnectionStatus](docs/JumpcloudGoogleEmmConnectionStatus.md)
 - [JCAPIv2::JumpcloudGoogleEmmCreateEnrollmentTokenRequest](docs/JumpcloudGoogleEmmCreateEnrollmentTokenRequest.md)
 - [JCAPIv2::JumpcloudGoogleEmmCreateEnrollmentTokenResponse](docs/JumpcloudGoogleEmmCreateEnrollmentTokenResponse.md)
 - [JCAPIv2::JumpcloudGoogleEmmCreateEnterpriseRequest](docs/JumpcloudGoogleEmmCreateEnterpriseRequest.md)
 - [JCAPIv2::JumpcloudGoogleEmmCreateWebTokenRequest](docs/JumpcloudGoogleEmmCreateWebTokenRequest.md)
 - [JCAPIv2::JumpcloudGoogleEmmDevice](docs/JumpcloudGoogleEmmDevice.md)
 - [JCAPIv2::JumpcloudGoogleEmmDeviceAndroidPolicy](docs/JumpcloudGoogleEmmDeviceAndroidPolicy.md)
 - [JCAPIv2::JumpcloudGoogleEmmDeviceData](docs/JumpcloudGoogleEmmDeviceData.md)
 - [JCAPIv2::JumpcloudGoogleEmmDeviceInformation](docs/JumpcloudGoogleEmmDeviceInformation.md)
 - [JCAPIv2::JumpcloudGoogleEmmDeviceSettings](docs/JumpcloudGoogleEmmDeviceSettings.md)
 - [JCAPIv2::JumpcloudGoogleEmmDeviceStateInfo](docs/JumpcloudGoogleEmmDeviceStateInfo.md)
 - [JCAPIv2::JumpcloudGoogleEmmEMMEnrollmentInfo](docs/JumpcloudGoogleEmmEMMEnrollmentInfo.md)
 - [JCAPIv2::JumpcloudGoogleEmmEnterprise](docs/JumpcloudGoogleEmmEnterprise.md)
 - [JCAPIv2::JumpcloudGoogleEmmFeature](docs/JumpcloudGoogleEmmFeature.md)
 - [JCAPIv2::JumpcloudGoogleEmmHardwareInfo](docs/JumpcloudGoogleEmmHardwareInfo.md)
 - [JCAPIv2::JumpcloudGoogleEmmListDevicesResponse](docs/JumpcloudGoogleEmmListDevicesResponse.md)
 - [JCAPIv2::JumpcloudGoogleEmmListEnterprisesResponse](docs/JumpcloudGoogleEmmListEnterprisesResponse.md)
 - [JCAPIv2::JumpcloudGoogleEmmMemoryInfo](docs/JumpcloudGoogleEmmMemoryInfo.md)
 - [JCAPIv2::JumpcloudGoogleEmmNetworkInfo](docs/JumpcloudGoogleEmmNetworkInfo.md)
 - [JCAPIv2::JumpcloudGoogleEmmSecurityPosture](docs/JumpcloudGoogleEmmSecurityPosture.md)
 - [JCAPIv2::JumpcloudGoogleEmmSignupURL](docs/JumpcloudGoogleEmmSignupURL.md)
 - [JCAPIv2::JumpcloudGoogleEmmSoftwareInfo](docs/JumpcloudGoogleEmmSoftwareInfo.md)
 - [JCAPIv2::JumpcloudGoogleEmmSystemUpdateInfo](docs/JumpcloudGoogleEmmSystemUpdateInfo.md)
 - [JCAPIv2::JumpcloudGoogleEmmTelephonyInfo](docs/JumpcloudGoogleEmmTelephonyInfo.md)
 - [JCAPIv2::JumpcloudGoogleEmmWebToken](docs/JumpcloudGoogleEmmWebToken.md)
 - [JCAPIv2::JumpcloudMspGetDetailsResponse](docs/JumpcloudMspGetDetailsResponse.md)
 - [JCAPIv2::JumpcloudMspProduct](docs/JumpcloudMspProduct.md)
 - [JCAPIv2::JumpcloudPackageValidatorApplePackageDetails](docs/JumpcloudPackageValidatorApplePackageDetails.md)
 - [JCAPIv2::JumpcloudPackageValidatorValidateApplicationInstallPackageRequest](docs/JumpcloudPackageValidatorValidateApplicationInstallPackageRequest.md)
 - [JCAPIv2::JumpcloudPackageValidatorValidateApplicationInstallPackageResponse](docs/JumpcloudPackageValidatorValidateApplicationInstallPackageResponse.md)
 - [JCAPIv2::LdapGroup](docs/LdapGroup.md)
 - [JCAPIv2::LdapServer](docs/LdapServer.md)
 - [JCAPIv2::LdapServerAction](docs/LdapServerAction.md)
 - [JCAPIv2::LdapserversIdBody](docs/LdapserversIdBody.md)
 - [JCAPIv2::MemberSuggestion](docs/MemberSuggestion.md)
 - [JCAPIv2::MemberSuggestionsPostResult](docs/MemberSuggestionsPostResult.md)
 - [JCAPIv2::Mobileconfig](docs/Mobileconfig.md)
 - [JCAPIv2::ModelCase](docs/ModelCase.md)
 - [JCAPIv2::O365Domain](docs/O365Domain.md)
 - [JCAPIv2::O365DomainResponse](docs/O365DomainResponse.md)
 - [JCAPIv2::O365DomainsListResponse](docs/O365DomainsListResponse.md)
 - [JCAPIv2::OSRestriction](docs/OSRestriction.md)
 - [JCAPIv2::OSRestrictionAppleRestrictions](docs/OSRestrictionAppleRestrictions.md)
 - [JCAPIv2::ObjectStorageItem](docs/ObjectStorageItem.md)
 - [JCAPIv2::ObjectStorageVersion](docs/ObjectStorageVersion.md)
 - [JCAPIv2::Office365](docs/Office365.md)
 - [JCAPIv2::Office365BuiltinTranslation](docs/Office365BuiltinTranslation.md)
 - [JCAPIv2::Office365DirectionTranslation](docs/Office365DirectionTranslation.md)
 - [JCAPIv2::Office365IdDomainsBody](docs/Office365IdDomainsBody.md)
 - [JCAPIv2::Office365TranslationRule](docs/Office365TranslationRule.md)
 - [JCAPIv2::Office365TranslationRuleRequest](docs/Office365TranslationRuleRequest.md)
 - [JCAPIv2::Organization](docs/Organization.md)
 - [JCAPIv2::PasswordsSecurity](docs/PasswordsSecurity.md)
 - [JCAPIv2::PhoneNumber](docs/PhoneNumber.md)
 - [JCAPIv2::Policy](docs/Policy.md)
 - [JCAPIv2::PolicyGroup](docs/PolicyGroup.md)
 - [JCAPIv2::PolicyGroupData](docs/PolicyGroupData.md)
 - [JCAPIv2::PolicyGroupTemplate](docs/PolicyGroupTemplate.md)
 - [JCAPIv2::PolicyGroupTemplateMember](docs/PolicyGroupTemplateMember.md)
 - [JCAPIv2::PolicyGroupTemplateMembers](docs/PolicyGroupTemplateMembers.md)
 - [JCAPIv2::PolicyGroupTemplates](docs/PolicyGroupTemplates.md)
 - [JCAPIv2::PolicyRequest](docs/PolicyRequest.md)
 - [JCAPIv2::PolicyRequestTemplate](docs/PolicyRequestTemplate.md)
 - [JCAPIv2::PolicyResult](docs/PolicyResult.md)
 - [JCAPIv2::PolicyTemplate](docs/PolicyTemplate.md)
 - [JCAPIv2::PolicyTemplateConfigField](docs/PolicyTemplateConfigField.md)
 - [JCAPIv2::PolicyTemplateConfigFieldTooltip](docs/PolicyTemplateConfigFieldTooltip.md)
 - [JCAPIv2::PolicyTemplateConfigFieldTooltipVariables](docs/PolicyTemplateConfigFieldTooltipVariables.md)
 - [JCAPIv2::PolicyTemplateWithDetails](docs/PolicyTemplateWithDetails.md)
 - [JCAPIv2::PolicyValue](docs/PolicyValue.md)
 - [JCAPIv2::PolicyWithDetails](docs/PolicyWithDetails.md)
 - [JCAPIv2::Provider](docs/Provider.md)
 - [JCAPIv2::ProviderAdminReq](docs/ProviderAdminReq.md)
 - [JCAPIv2::ProviderInvoice](docs/ProviderInvoice.md)
 - [JCAPIv2::ProviderInvoiceResponse](docs/ProviderInvoiceResponse.md)
 - [JCAPIv2::PushEndpointResponse](docs/PushEndpointResponse.md)
 - [JCAPIv2::PushEndpointResponseDevice](docs/PushEndpointResponseDevice.md)
 - [JCAPIv2::PushendpointsPushEndpointIdBody](docs/PushendpointsPushEndpointIdBody.md)
 - [JCAPIv2::PwmAllUsers](docs/PwmAllUsers.md)
 - [JCAPIv2::PwmCloudBackupRestores](docs/PwmCloudBackupRestores.md)
 - [JCAPIv2::PwmItemHistory](docs/PwmItemHistory.md)
 - [JCAPIv2::PwmItemsCountByType](docs/PwmItemsCountByType.md)
 - [JCAPIv2::PwmItemsMetadata](docs/PwmItemsMetadata.md)
 - [JCAPIv2::PwmOverviewAppVersions](docs/PwmOverviewAppVersions.md)
 - [JCAPIv2::PwmOverviewAppVersionsResults](docs/PwmOverviewAppVersionsResults.md)
 - [JCAPIv2::PwmOverviewMain](docs/PwmOverviewMain.md)
 - [JCAPIv2::PwmOverviewMainDevices](docs/PwmOverviewMainDevices.md)
 - [JCAPIv2::PwmUser](docs/PwmUser.md)
 - [JCAPIv2::PwmUserById](docs/PwmUserById.md)
 - [JCAPIv2::PwmUserItem](docs/PwmUserItem.md)
 - [JCAPIv2::PwmUserItems](docs/PwmUserItems.md)
 - [JCAPIv2::PwmUserSharedFolders](docs/PwmUserSharedFolders.md)
 - [JCAPIv2::PwmUserSharedFoldersResults](docs/PwmUserSharedFoldersResults.md)
 - [JCAPIv2::Query](docs/Query.md)
 - [JCAPIv2::QueuedCommandList](docs/QueuedCommandList.md)
 - [JCAPIv2::QueuedCommandListResults](docs/QueuedCommandListResults.md)
 - [JCAPIv2::SambaDomain](docs/SambaDomain.md)
 - [JCAPIv2::ScheduleOSUpdate](docs/ScheduleOSUpdate.md)
 - [JCAPIv2::ScheduledUserstateResult](docs/ScheduledUserstateResult.md)
 - [JCAPIv2::SetupAssistantOption](docs/SetupAssistantOption.md)
 - [JCAPIv2::SharedFolder](docs/SharedFolder.md)
 - [JCAPIv2::SharedFolderAccessLevels](docs/SharedFolderAccessLevels.md)
 - [JCAPIv2::SharedFolderAccessLevelsResults](docs/SharedFolderAccessLevelsResults.md)
 - [JCAPIv2::SharedFolderDetails](docs/SharedFolderDetails.md)
 - [JCAPIv2::SharedFolderGroups](docs/SharedFolderGroups.md)
 - [JCAPIv2::SharedFolderUsers](docs/SharedFolderUsers.md)
 - [JCAPIv2::SharedFolderUsersResults](docs/SharedFolderUsersResults.md)
 - [JCAPIv2::SharedFoldersList](docs/SharedFoldersList.md)
 - [JCAPIv2::SoftwareApp](docs/SoftwareApp.md)
 - [JCAPIv2::SoftwareAppAppleVpp](docs/SoftwareAppAppleVpp.md)
 - [JCAPIv2::SoftwareAppCreate](docs/SoftwareAppCreate.md)
 - [JCAPIv2::SoftwareAppGoogleAndroid](docs/SoftwareAppGoogleAndroid.md)
 - [JCAPIv2::SoftwareAppPermissionGrants](docs/SoftwareAppPermissionGrants.md)
 - [JCAPIv2::SoftwareAppReclaimLicenses](docs/SoftwareAppReclaimLicenses.md)
 - [JCAPIv2::SoftwareAppSettings](docs/SoftwareAppSettings.md)
 - [JCAPIv2::SoftwareAppStatus](docs/SoftwareAppStatus.md)
 - [JCAPIv2::SoftwareAppWithStatus](docs/SoftwareAppWithStatus.md)
 - [JCAPIv2::SoftwareAppsRetryInstallationRequest](docs/SoftwareAppsRetryInstallationRequest.md)
 - [JCAPIv2::Subscription](docs/Subscription.md)
 - [JCAPIv2::SuggestionCounts](docs/SuggestionCounts.md)
 - [JCAPIv2::SyncroBillingMappingConfigurationOption](docs/SyncroBillingMappingConfigurationOption.md)
 - [JCAPIv2::SyncroBillingMappingConfigurationOptionValue](docs/SyncroBillingMappingConfigurationOptionValue.md)
 - [JCAPIv2::SyncroBillingMappingConfigurationOptionValueLine](docs/SyncroBillingMappingConfigurationOptionValueLine.md)
 - [JCAPIv2::SyncroBillingMappingConfigurationOptionsResp](docs/SyncroBillingMappingConfigurationOptionsResp.md)
 - [JCAPIv2::SyncroCompany](docs/SyncroCompany.md)
 - [JCAPIv2::SyncroCompanyResp](docs/SyncroCompanyResp.md)
 - [JCAPIv2::SyncroIntegration](docs/SyncroIntegration.md)
 - [JCAPIv2::SyncroIntegrationPatchReq](docs/SyncroIntegrationPatchReq.md)
 - [JCAPIv2::SyncroIntegrationReq](docs/SyncroIntegrationReq.md)
 - [JCAPIv2::SyncroMappingRequest](docs/SyncroMappingRequest.md)
 - [JCAPIv2::SyncroMappingRequestBillingConfigurations](docs/SyncroMappingRequestBillingConfigurations.md)
 - [JCAPIv2::SyncroMappingRequestBillingConfigurationsFields](docs/SyncroMappingRequestBillingConfigurationsFields.md)
 - [JCAPIv2::SyncroMappingRequestBillingConfigurationsFieldsLineItemId](docs/SyncroMappingRequestBillingConfigurationsFieldsLineItemId.md)
 - [JCAPIv2::SyncroMappingRequestBillingConfigurationsFieldsLineItemName](docs/SyncroMappingRequestBillingConfigurationsFieldsLineItemName.md)
 - [JCAPIv2::SyncroMappingRequestData](docs/SyncroMappingRequestData.md)
 - [JCAPIv2::SyncroMappingResponse](docs/SyncroMappingResponse.md)
 - [JCAPIv2::SyncroSettings](docs/SyncroSettings.md)
 - [JCAPIv2::SyncroSettingsPatchReq](docs/SyncroSettingsPatchReq.md)
 - [JCAPIv2::SyncroTicketingAlertConfiguration](docs/SyncroTicketingAlertConfiguration.md)
 - [JCAPIv2::SyncroTicketingAlertConfigurationList](docs/SyncroTicketingAlertConfigurationList.md)
 - [JCAPIv2::SyncroTicketingAlertConfigurationOption](docs/SyncroTicketingAlertConfigurationOption.md)
 - [JCAPIv2::SyncroTicketingAlertConfigurationOptions](docs/SyncroTicketingAlertConfigurationOptions.md)
 - [JCAPIv2::SyncroTicketingAlertConfigurationRequest](docs/SyncroTicketingAlertConfigurationRequest.md)
 - [JCAPIv2::SystemGroup](docs/SystemGroup.md)
 - [JCAPIv2::SystemGroupPost](docs/SystemGroupPost.md)
 - [JCAPIv2::SystemGroupPut](docs/SystemGroupPut.md)
 - [JCAPIv2::SystemInsightsAlf](docs/SystemInsightsAlf.md)
 - [JCAPIv2::SystemInsightsAlfExceptions](docs/SystemInsightsAlfExceptions.md)
 - [JCAPIv2::SystemInsightsAlfExplicitAuths](docs/SystemInsightsAlfExplicitAuths.md)
 - [JCAPIv2::SystemInsightsAppcompatShims](docs/SystemInsightsAppcompatShims.md)
 - [JCAPIv2::SystemInsightsApps](docs/SystemInsightsApps.md)
 - [JCAPIv2::SystemInsightsAuthorizedKeys](docs/SystemInsightsAuthorizedKeys.md)
 - [JCAPIv2::SystemInsightsAzureInstanceMetadata](docs/SystemInsightsAzureInstanceMetadata.md)
 - [JCAPIv2::SystemInsightsAzureInstanceTags](docs/SystemInsightsAzureInstanceTags.md)
 - [JCAPIv2::SystemInsightsBattery](docs/SystemInsightsBattery.md)
 - [JCAPIv2::SystemInsightsBitlockerInfo](docs/SystemInsightsBitlockerInfo.md)
 - [JCAPIv2::SystemInsightsBrowserPlugins](docs/SystemInsightsBrowserPlugins.md)
 - [JCAPIv2::SystemInsightsCertificates](docs/SystemInsightsCertificates.md)
 - [JCAPIv2::SystemInsightsChassisInfo](docs/SystemInsightsChassisInfo.md)
 - [JCAPIv2::SystemInsightsChromeExtensions](docs/SystemInsightsChromeExtensions.md)
 - [JCAPIv2::SystemInsightsConnectivity](docs/SystemInsightsConnectivity.md)
 - [JCAPIv2::SystemInsightsCrashes](docs/SystemInsightsCrashes.md)
 - [JCAPIv2::SystemInsightsCupsDestinations](docs/SystemInsightsCupsDestinations.md)
 - [JCAPIv2::SystemInsightsDiskEncryption](docs/SystemInsightsDiskEncryption.md)
 - [JCAPIv2::SystemInsightsDiskInfo](docs/SystemInsightsDiskInfo.md)
 - [JCAPIv2::SystemInsightsDnsResolvers](docs/SystemInsightsDnsResolvers.md)
 - [JCAPIv2::SystemInsightsEtcHosts](docs/SystemInsightsEtcHosts.md)
 - [JCAPIv2::SystemInsightsFirefoxAddons](docs/SystemInsightsFirefoxAddons.md)
 - [JCAPIv2::SystemInsightsGroups](docs/SystemInsightsGroups.md)
 - [JCAPIv2::SystemInsightsIeExtensions](docs/SystemInsightsIeExtensions.md)
 - [JCAPIv2::SystemInsightsInterfaceAddresses](docs/SystemInsightsInterfaceAddresses.md)
 - [JCAPIv2::SystemInsightsInterfaceDetails](docs/SystemInsightsInterfaceDetails.md)
 - [JCAPIv2::SystemInsightsKernelInfo](docs/SystemInsightsKernelInfo.md)
 - [JCAPIv2::SystemInsightsLaunchd](docs/SystemInsightsLaunchd.md)
 - [JCAPIv2::SystemInsightsLinuxPackages](docs/SystemInsightsLinuxPackages.md)
 - [JCAPIv2::SystemInsightsLoggedInUsers](docs/SystemInsightsLoggedInUsers.md)
 - [JCAPIv2::SystemInsightsLogicalDrives](docs/SystemInsightsLogicalDrives.md)
 - [JCAPIv2::SystemInsightsManagedPolicies](docs/SystemInsightsManagedPolicies.md)
 - [JCAPIv2::SystemInsightsMounts](docs/SystemInsightsMounts.md)
 - [JCAPIv2::SystemInsightsOsVersion](docs/SystemInsightsOsVersion.md)
 - [JCAPIv2::SystemInsightsPatches](docs/SystemInsightsPatches.md)
 - [JCAPIv2::SystemInsightsPrograms](docs/SystemInsightsPrograms.md)
 - [JCAPIv2::SystemInsightsPythonPackages](docs/SystemInsightsPythonPackages.md)
 - [JCAPIv2::SystemInsightsSafariExtensions](docs/SystemInsightsSafariExtensions.md)
 - [JCAPIv2::SystemInsightsScheduledTasks](docs/SystemInsightsScheduledTasks.md)
 - [JCAPIv2::SystemInsightsSecureboot](docs/SystemInsightsSecureboot.md)
 - [JCAPIv2::SystemInsightsServices](docs/SystemInsightsServices.md)
 - [JCAPIv2::SystemInsightsShadow](docs/SystemInsightsShadow.md)
 - [JCAPIv2::SystemInsightsSharedFolders](docs/SystemInsightsSharedFolders.md)
 - [JCAPIv2::SystemInsightsSharedResources](docs/SystemInsightsSharedResources.md)
 - [JCAPIv2::SystemInsightsSharingPreferences](docs/SystemInsightsSharingPreferences.md)
 - [JCAPIv2::SystemInsightsSipConfig](docs/SystemInsightsSipConfig.md)
 - [JCAPIv2::SystemInsightsStartupItems](docs/SystemInsightsStartupItems.md)
 - [JCAPIv2::SystemInsightsSystemControls](docs/SystemInsightsSystemControls.md)
 - [JCAPIv2::SystemInsightsSystemInfo](docs/SystemInsightsSystemInfo.md)
 - [JCAPIv2::SystemInsightsTpmInfo](docs/SystemInsightsTpmInfo.md)
 - [JCAPIv2::SystemInsightsUptime](docs/SystemInsightsUptime.md)
 - [JCAPIv2::SystemInsightsUsbDevices](docs/SystemInsightsUsbDevices.md)
 - [JCAPIv2::SystemInsightsUserGroups](docs/SystemInsightsUserGroups.md)
 - [JCAPIv2::SystemInsightsUserSshKeys](docs/SystemInsightsUserSshKeys.md)
 - [JCAPIv2::SystemInsightsUserassist](docs/SystemInsightsUserassist.md)
 - [JCAPIv2::SystemInsightsUsers](docs/SystemInsightsUsers.md)
 - [JCAPIv2::SystemInsightsWifiNetworks](docs/SystemInsightsWifiNetworks.md)
 - [JCAPIv2::SystemInsightsWifiStatus](docs/SystemInsightsWifiStatus.md)
 - [JCAPIv2::SystemInsightsWindowsSecurityCenter](docs/SystemInsightsWindowsSecurityCenter.md)
 - [JCAPIv2::SystemInsightsWindowsSecurityProducts](docs/SystemInsightsWindowsSecurityProducts.md)
 - [JCAPIv2::Systemfdekey](docs/Systemfdekey.md)
 - [JCAPIv2::TicketingIntegrationAlert](docs/TicketingIntegrationAlert.md)
 - [JCAPIv2::TicketingIntegrationAlertsResp](docs/TicketingIntegrationAlertsResp.md)
 - [JCAPIv2::User](docs/User.md)
 - [JCAPIv2::UserGroup](docs/UserGroup.md)
 - [JCAPIv2::UserGroupPost](docs/UserGroupPost.md)
 - [JCAPIv2::UserGroupPut](docs/UserGroupPut.md)
 - [JCAPIv2::WorkdayFields](docs/WorkdayFields.md)
 - [JCAPIv2::WorkdayInput](docs/WorkdayInput.md)
 - [JCAPIv2::WorkdayOutput](docs/WorkdayOutput.md)
 - [JCAPIv2::WorkdayWorker](docs/WorkdayWorker.md)
 - [JCAPIv2::WorkdayoutputAuth](docs/WorkdayoutputAuth.md)

## Documentation for Authorization


### x-api-key

- **Type**: API key
- **API key parameter name**: x-api-key
- **Location**: HTTP header

