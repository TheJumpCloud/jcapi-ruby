# JCAPIv1::SearchApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**search_commandresults_post**](SearchApi.md#search_commandresults_post) | **POST** /search/commandresults | Search Commands Results
[**search_commands_post**](SearchApi.md#search_commands_post) | **POST** /search/commands | Search Commands
[**search_organizations_post**](SearchApi.md#search_organizations_post) | **POST** /search/organizations | Search Organizations
[**search_systems_post**](SearchApi.md#search_systems_post) | **POST** /search/systems | Search Systems
[**search_systemusers_post**](SearchApi.md#search_systemusers_post) | **POST** /search/systemusers | Search System Users

# **search_commandresults_post**
> Commandresultslist search_commandresults_post(opts)

Search Commands Results

Return Command Results in multi-record format allowing for the passing of the `filter` parameter.  To support advanced filtering you can use the `filter` and `searchFilter` parameters that can only be passed in the body of POST /api/search/commandresults route. The `filter` parameter must be passed as Content-Type application/json.  The `filter` parameter is an object with a single property, either `and` or `or` with the value of the property being an array of query expressions.  This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the `and` or `or` are not included the default behavior is to match ALL query expressions.   #### Sample Request  Exact search for a specific command result ``` curl -X POST https://console.jumpcloud.com/api/search/commandresults \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"filter\" : \"workflowInstanceId:$eq:62f3c599ec4e928499069c7f\",   \"fields\" : \"name workflowId sudo\" }' ```

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SearchApi.new
opts = { 
  body: JCAPIv1::Search.new # Search | 
  x_org_id: 'x_org_id_example' # String | 
  fields: 'fields_example' # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example' # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10 # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Search Commands Results
  result = api_instance.search_commandresults_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SearchApi->search_commandresults_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Search**](Search.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] 
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | **String**| A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together. | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Commandresultslist**](Commandresultslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **search_commands_post**
> Commandslist search_commands_post(opts)

Search Commands

Return Commands in multi-record format allowing for the passing of the `filter` and `searchFilter` parameters. This WILL NOT allow you to add a new command. To support advanced filtering you can use the `filter` and `searchFilter` parameters that can only be passed in the body of POST /api/search/* routes. The `filter` and `searchFilter` parameters must be passed as Content-Type application/json. The `filter` parameter is an object with a single property, either `and` or `or` with the value of the property being an array of query expressions. This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the `and` or `or` are not included the default behavior is to match ALL query expressions. The `searchFilter` parameter allows text searching on supported fields by specifying a `searchTerm` and a list of `fields` to query on. If any `field` has a partial text match on the `searchTerm` the record will be returned.  #### Sample Request Exact search for a list of commands in a launchType ``` curl -X POST https://console.jumpcloud.com/api/search/commands \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"filter\" : [{\"launchType\" : \"repeated\"}],   \"fields\" : \"name launchType sudo\" }' ``` Text search for commands with name ``` curl -X POST https://console.jumpcloud.com/api/search/commands \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\" : {     \"searchTerm\": \"List\",     \"fields\": [\"name\"]   },   \"fields\" : \"name launchType sudo\" }' ``` Text search for multiple commands ``` curl -X POST https://console.jumpcloud.com/api/search/commands \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\" : {     \"searchTerm\": [\"List\", \"Log\"],     \"fields\": [\"name\"]   },   \"fields\" : \"name launchType sudo\" }' ``` Combining `filter` and `searchFilter` to text search for commands with name who are in a list of launchType ``` curl -X POST https://console.jumpcloud.com/api/search/commands \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\": {     \"searchTerm\": \"List\",     \"fields\": [\"name\"]   },   \"filter\": {     \"or\": [       {\"launchType\" : \"repeated\"},       {\"launchType\" : \"one-time\"}     ]   },   \"fields\" : \"name launchType sudo\" }' ```

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SearchApi.new
opts = { 
  body: JCAPIv1::Search.new # Search | 
  x_org_id: 'x_org_id_example' # String | 
  fields: 'fields_example' # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example' # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10 # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Search Commands
  result = api_instance.search_commands_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SearchApi->search_commands_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Search**](Search.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] 
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | **String**| A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together. | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Commandslist**](Commandslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **search_organizations_post**
> Organizationslist search_organizations_post(opts)

Search Organizations

This endpoint will return Organization data based on your search parameters. This endpoint WILL NOT allow you to add a new Organization.  You can use the supported parameters and pass those in the body of request.  The parameters must be passed as Content-Type application/json.   #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/search/organizations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"search\":{     \"fields\" : [\"settings.name\"],     \"searchTerm\": \"Second\"     },   \"fields\": [\"_id\", \"displayName\", \"logoUrl\"],   \"limit\" : 0,   \"skip\" : 0 }' ```

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SearchApi.new
opts = { 
  body: JCAPIv1::Search.new # Search | 
  fields: 'fields_example' # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example' # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10 # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Search Organizations
  result = api_instance.search_organizations_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SearchApi->search_organizations_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Search**](Search.md)|  | [optional] 
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | **String**| A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together. | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Organizationslist**](Organizationslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **search_systems_post**
> Systemslist search_systems_post(opts)

Search Systems

Return Systems in multi-record format allowing for the passing of the `filter` and `searchFilter` parameters. This WILL NOT allow you to add a new system.  To support advanced filtering you can use the `filter` and `searchFilter` parameters that can only be passed in the body of POST /api/search/* routes. The `filter` and `searchFilter` parameters must be passed as Content-Type application/json.  The `filter` parameter is an object with a single property, either `and` or `or` with the value of the property being an array of query expressions.  This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the `and` or `or` are not included the default behavior is to match ALL query expressions.  The `searchFilter` parameter allows text searching on supported fields by specifying a `searchTerm` and a list of `fields` to query on. If any `field` has a partial text match on the `searchTerm` the record will be returned.   #### Sample Request  Exact search for a list of hostnames ``` curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"filter\": {     \"or\": [       {\"hostname\" : \"my-hostname\"},       {\"hostname\" : \"other-hostname\"}     ]   },   \"fields\" : \"os hostname displayName\" }' ```  Text search for a hostname or display name ``` curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\": {     \"searchTerm\": \"my-host\",     \"fields\": [\"hostname\", \"displayName\"]   },   \"fields\": \"os hostname displayName\" }' ```  Text search for a multiple hostnames. ``` curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\": {     \"searchTerm\": [\"my-host\", \"my-other-host\"],     \"fields\": [\"hostname\"]   },   \"fields\": \"os hostname displayName\" }' ```  Combining `filter` and `searchFilter` to search for names that match a given OS ``` curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\": {     \"searchTerm\": \"my-host\",     \"fields\": [\"hostname\", \"displayName\"]   },   \"filter\": {     \"or\": [       {\"os\" : \"Ubuntu\"},       {\"os\" : \"Mac OS X\"}     ]   },   \"fields\": \"os hostname displayName\" }' ```

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SearchApi.new
opts = { 
  body: JCAPIv1::Search.new # Search | 
  x_org_id: 'x_org_id_example' # String | 
  fields: 'fields_example' # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  limit: 10 # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
  filter: 'filter_example' # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
}

begin
  #Search Systems
  result = api_instance.search_systems_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SearchApi->search_systems_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Search**](Search.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] 
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned.  | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **filter** | **String**| A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together. | [optional] 

### Return type

[**Systemslist**](Systemslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **search_systemusers_post**
> Systemuserslist search_systemusers_post(opts)

Search System Users

Return System Users in multi-record format allowing for the passing of the `filter` and `searchFilter` parameters. This WILL NOT allow you to add a new system user.  To support advanced filtering you can use the `filter` and `searchFilter` parameters that can only be passed in the body of POST /api/search/* routes. The `filter` and `searchFilter` parameters must be passed as Content-Type application/json.  The `filter` parameter is an object with a single property, either `and` or `or` with the value of the property being an array of query expressions.  This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the `and` or `or` are not included the default behavior is to match ALL query expressions.  The `searchFilter` parameter allows text searching on supported fields by specifying a `searchTerm` and a list of `fields` to query on. If any `field` has a partial text match on the `searchTerm` the record will be returned.   #### Sample Request  Exact search for a list of system users in a department ``` curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"filter\" : [{\"department\" : \"IT\"}],   \"fields\" : \"email username sudo\" }' ```  Text search for system users with and email on a domain ``` curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\" : {     \"searchTerm\": \"@jumpcloud.com\",     \"fields\": [\"email\"]   },   \"fields\" : \"email username sudo\" }' ```  Text search for multiple system users ``` curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\" : {     \"searchTerm\": [\"john\", \"sarah\"],     \"fields\": [\"username\"]   },   \"fields\" : \"email username sudo\" }' ```  Combining `filter` and `searchFilter` to text search for system users with and email on a domain who are in a list of departments ``` curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\": {     \"searchTerm\": \"@jumpcloud.com\",     \"fields\": [\"email\"]   },   \"filter\": {     \"or\": [       {\"department\" : \"IT\"},       {\"department\" : \"Sales\"}     ]   },   \"fields\" : \"email username sudo\" }' ```

### Example
```ruby
# load the gem
require 'jcapiv1'
# setup authorization
JCAPIv1.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv1::SearchApi.new
opts = { 
  body: JCAPIv1::Search.new # Search | 
  x_org_id: 'x_org_id_example' # String | 
  fields: 'fields_example' # String | Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  filter: 'filter_example' # String | A filter to apply to the query. See the supported operators below. For more complex searches, see the related `/search/<domain>` endpoints, e.g. `/search/systems`.  **Filter structure**: `<field>:<operator>:<value>`.  **field** = Populate with a valid field from an endpoint response.  **operator** = Supported operators are: - `$eq` (equals) - `$ne` (does not equal) - `$gt` (is greater than) - `$gte` (is greater than or equal to) - `$lt` (is less than) - `$lte` (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the `$` will result in undefined behavior._  **value** = Populate with the value you want to search for. Is case sensitive.  **Examples** - `GET /users?filter=username:$eq:testuser` - `GET /systemusers?filter=password_expiration_date:$lte:2021-10-24` - `GET /systemusers?filter=department:$ne:Accounting` - `GET /systems?filter[0]=firstname:$eq:foo&filter[1]=lastname:$eq:bar` - this will    AND the filters together. - `GET /systems?filter[or][0]=lastname:$eq:foo&filter[or][1]=lastname:$eq:bar` - this will    OR the filters together.
  limit: 10 # Integer | The number of records to return at once. Limited to 100.
  skip: 0 # Integer | The offset into the records to return.
}

begin
  #Search System Users
  result = api_instance.search_systemusers_post(opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SearchApi->search_systemusers_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Search**](Search.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] 
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned.  | [optional] 
 **filter** | **String**| A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together. | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]

### Return type

[**Systemuserslist**](Systemuserslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



