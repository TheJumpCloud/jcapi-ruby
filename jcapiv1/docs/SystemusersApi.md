# JCAPIv1::SystemusersApi

All URIs are relative to *https://console.jumpcloud.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**sshkey_delete**](SystemusersApi.md#sshkey_delete) | **DELETE** /systemusers/{id}/sshkeys/{id} | Delete a system user&#39;s Public SSH Keys
[**sshkey_list**](SystemusersApi.md#sshkey_list) | **GET** /systemusers/{id}/sshkeys | List a system user&#39;s public SSH keys
[**sshkey_post**](SystemusersApi.md#sshkey_post) | **POST** /systemusers/{id}/sshkeys | Create a system user&#39;s Public SSH Key
[**systemusers_delete**](SystemusersApi.md#systemusers_delete) | **DELETE** /systemusers/{id} | Delete a system user
[**systemusers_get**](SystemusersApi.md#systemusers_get) | **GET** /systemusers/{id} | List a system user
[**systemusers_list**](SystemusersApi.md#systemusers_list) | **GET** /systemusers | List all system users
[**systemusers_post**](SystemusersApi.md#systemusers_post) | **POST** /systemusers | Create a system user
[**systemusers_put**](SystemusersApi.md#systemusers_put) | **PUT** /systemusers/{id} | Update a system user
[**systemusers_resetmfa**](SystemusersApi.md#systemusers_resetmfa) | **POST** /systemusers/{id}/resetmfa | Reset a system user&#39;s MFA token
[**systemusers_systems_binding_list**](SystemusersApi.md#systemusers_systems_binding_list) | **GET** /systemusers/{id}/systems | List system user binding
[**systemusers_systems_binding_put**](SystemusersApi.md#systemusers_systems_binding_put) | **PUT** /systemusers/{id}/systems | Update a system user binding
[**systemusers_unlock**](SystemusersApi.md#systemusers_unlock) | **POST** /systemusers/{id}/unlock | Unlock a system user


# **sshkey_delete**
> sshkey_delete(id, content_type, accept, opts)

Delete a system user's Public SSH Keys

This endpoint will delete a specific System User's SSH Key.

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

api_instance = JCAPIv1::SystemusersApi.new

id = 'id_example' # String | 

content_type = 'application/json' # String | 

accept = 'application/json' # String | 

opts = { 
  x_org_id: '' # String | 
}

begin
  #Delete a system user's Public SSH Keys
  api_instance.sshkey_delete(id, content_type, accept, opts)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->sshkey_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **sshkey_list**
> Sshkeylist sshkey_list(id, content_type, accept, opts)

List a system user's public SSH keys

This endpoint will return a specific System User's public SSH key.

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

api_instance = JCAPIv1::SystemusersApi.new

id = 'id_example' # String | 

content_type = 'application/json' # String | 

accept = 'application/json' # String | 

opts = { 
  x_org_id: '' # String | 
}

begin
  #List a system user's public SSH keys
  result = api_instance.sshkey_list(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->sshkey_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Sshkeylist**](Sshkeylist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **sshkey_post**
> Sshkeylist sshkey_post(id, content_type, accept, opts)

Create a system user's Public SSH Key

This endpoint will create a specific System User's Public SSH Key.

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

api_instance = JCAPIv1::SystemusersApi.new

id = 'id_example' # String | 

content_type = 'application/json' # String | 

accept = 'application/json' # String | 

opts = { 
  body: JCAPIv1::Sshkeypost.new, # Sshkeypost | 
  x_org_id: '' # String | 
}

begin
  #Create a system user's Public SSH Key
  result = api_instance.sshkey_post(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->sshkey_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Sshkeypost**](Sshkeypost.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Sshkeylist**](Sshkeylist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_delete**
> Systemuserreturn systemusers_delete(id, content_type, accept, opts)

Delete a system user

This endpoint allows you to delete a particular system user.  #### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/systemusers/{UserID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv1::SystemusersApi.new

id = 'id_example' # String | 

content_type = 'application/json' # String | 

accept = 'application/json' # String | 

opts = { 
  x_org_id: '' # String | 
}

begin
  #Delete a system user
  result = api_instance.systemusers_delete(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Systemuserreturn**](Systemuserreturn.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_get**
> Systemuserreturn systemusers_get(id, content_type, accept, opts)

List a system user

This endpoint returns a particular System User.  #### Sample Request  ``` curl -X GET https://console.jumpcloud.com/api/systemusers/{UserID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv1::SystemusersApi.new

id = 'id_example' # String | 

content_type = 'application/json' # String | 

accept = 'application/json' # String | 

opts = { 
  fields: '', # String | Use a space seperated string of field parameters to include the data in the response. If omitted the default list of fields will be returned. 
  filter: 'filter_example' # String | A filter to apply to the query.
  x_org_id: '' # String | 
}

begin
  #List a system user
  result = api_instance.systemusers_get(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **filter** | **String**| A filter to apply to the query. | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Systemuserreturn**](Systemuserreturn.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_list**
> Systemuserslist systemusers_list(content_type, accept, opts)

List all system users

This endpoint returns all systemusers.  #### Sample Request  ``` curl -X GET https://console.jumpcloud.com/api/systemusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

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

api_instance = JCAPIv1::SystemusersApi.new

content_type = 'application/json' # String | 

accept = 'application/json' # String | 

opts = { 
  limit: 10, # Integer | The number of records to return at once.
  skip: 0, # Integer | The offset into the records to return.
  sort: '', # String | The comma separated fields used to sort the collection. Default sort is ascending, prefix with `-` to sort descending. 
  fields: '', # String | The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  x_org_id: '' # String | 
  search: 'search_example', # String | A nested object containing a string `searchTerm` and a list of `fields` to search on.
  filter: 'filter_example' # String | A filter to apply to the query.
}

begin
  #List all system users
  result = api_instance.systemusers_list(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **limit** | **Integer**| The number of records to return at once. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]
 **fields** | **String**| The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **x_org_id** | **String**|  | [optional] [default to ]
 **search** | **String**| A nested object containing a string &#x60;searchTerm&#x60; and a list of &#x60;fields&#x60; to search on. | [optional] 
 **filter** | **String**| A filter to apply to the query. | [optional] 

### Return type

[**Systemuserslist**](Systemuserslist.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_post**
> Systemuserreturn systemusers_post(content_type, accept, opts)

Create a system user

This endpoint allows you to create a new system user.  #### Sample Request  ``` curl -X POST https://console.jumpcloud.com/api/systemusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{  \"username\":\"{username}\",  \"email\":\"{email_address}\",  \"firstname\":\"{Name}\",  \"lastname\":\"{Name}\" }' ```

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

api_instance = JCAPIv1::SystemusersApi.new

content_type = 'application/json' # String | 

accept = 'application/json' # String | 

opts = { 
  body: JCAPIv1::Systemuserputpost.new, # Systemuserputpost | 
  x_org_id: '' # String | 
}

begin
  #Create a system user
  result = api_instance.systemusers_post(content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Systemuserputpost**](Systemuserputpost.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Systemuserreturn**](Systemuserreturn.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_put**
> Systemuserreturn systemusers_put(id, content_type, accept, opts)

Update a system user

This endpoint allows you to update a system user.  #### Sample Request  ``` curl -X PUT https://console.jumpcloud.com/api/systemusers/{UserID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{  \"email\":\"{email_address}\",  \"firstname\":\"{Name}\",  \"lastname\":\"{Name}\" }' ```

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

api_instance = JCAPIv1::SystemusersApi.new

id = 'id_example' # String | 

content_type = 'application/json' # String | 

accept = 'application/json' # String | 

opts = { 
  body: JCAPIv1::Systemuserput.new, # Systemuserput | 
  x_org_id: '' # String | 
}

begin
  #Update a system user
  result = api_instance.systemusers_put(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Systemuserput**](Systemuserput.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Systemuserreturn**](Systemuserreturn.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_resetmfa**
> String systemusers_resetmfa(id, x_api_key, opts)

Reset a system user's MFA token

This endpoint allows you to reset the MFA TOTP token for a specified system user and put them in an MFA enrollment period. This will result in the user being prompted to setup MFA when logging into userportal. Please be aware that if the user does not complete MFA setup before the `exclusionUntil` date, they will be locked out of any resources that require MFA.  Please refer to our [Knowledge Base Article](https://support.jumpcloud.com/customer/en/portal/articles/2959138-using-multifactor-authentication-with-jumpcloud) on setting up MFA for more information.  #### Sample Request ``` curl -X POST \\   https://console.jumpcloud.com/api/systemusers/{UserID}/resetmfa \\   -H 'x-api-key: {API_KEY}' \\   -H 'Content-Type: application/json' \\   -d '{\"exclusion\": true, \"exclusionUntil\": \"{date-time}\"}'   ```

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

api_instance = JCAPIv1::SystemusersApi.new

id = 'id_example' # String | 

x_api_key = 'x_api_key_example' # String | 

opts = { 
  body: JCAPIv1::Body1.new, # Body1 | 
  x_org_id: '' # String | 
}

begin
  #Reset a system user's MFA token
  result = api_instance.systemusers_resetmfa(id, x_api_key, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_resetmfa: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **x_api_key** | **String**|  | 
 **body** | [**Body1**](Body1.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

**String**

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_systems_binding_list**
> Object systemusers_systems_binding_list(id, content_type, accept, opts)

List system user binding

Hidden as Tags is deprecated  Adds or removes a system binding for a user.  This endpoint is only used for users still using JumpCloud Tags. If you are using JumpCloud Groups please refer to the documentation found [here](https://docs.jumpcloud.com/2.0/systems/manage-associations-of-a-system).   List system bindings for a specific system user in a system and user binding format.  ### Examples  #### List system bindings for specific system user  ``` curl \\   -H 'Content-Type: application/json' \\   -H \"x-api-key: [YOUR_API_KEY_HERE]\" \\   \"https://console.jumpcloud.com/api/systemusers/[SYSTEM_USER_ID_HERE]/systems\" ```

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

api_instance = JCAPIv1::SystemusersApi.new

id = 'id_example' # String | 

content_type = 'application/json' # String | 

accept = 'application/json' # String | 

opts = { 
  fields: '', # String | Use a space seperated string of field parameters to include the data in the response. If omitted the default list of fields will be returned. 
  limit: 10, # Integer | The number of records to return at once. Limited to 100.
  skip: 0, # Integer | The offset into the records to return.
  sort: '', # String | Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with `-` to sort descending. 
  filter: 'filter_example' # String | A filter to apply to the query.
  x_org_id: '' # String | 
}

begin
  #List system user binding
  result = api_instance.systemusers_systems_binding_list(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_systems_binding_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **fields** | **String**| Use a space seperated string of field parameters to include the data in the response. If omitted the default list of fields will be returned.  | [optional] [default to ]
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | **String**| Use space separated sort parameters to sort the collection. Default sort is ascending. Prefix with &#x60;-&#x60; to sort descending.  | [optional] [default to ]
 **filter** | **String**| A filter to apply to the query. | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

**Object**

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_systems_binding_put**
> Usersystembinding systemusers_systems_binding_put(id, content_type, accept, opts)

Update a system user binding

Hidden as Tags is deprecated  Adds or removes a system binding for a user.  This endpoint is only used for users still using JumpCloud Tags. If you are using JumpCloud Groups please refer to the documentation found [here](https://docs.jumpcloud.com/2.0/systems/manage-associations-of-a-system).  ### Example  #### Add (or remove) system to system user  ``` curl \\   -d '{ \"add\": [\"[SYSTEM_ID_TO_ADD_HERE]\"], \"remove\": [\"[SYSTEM_ID_TO_REMOVE_HERE]\"] }' \\   -X PUT \\   -H 'Content-Type: application/json' \\   -H 'Accept: application/json' \\   -H \"x-api-key: [YOUR_API_KEY_HERE]\" \\   \"https://console.jumpcloud.com/api/systemusers/[SYSTEM_USER_ID_HERE]/systems\" ```

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

api_instance = JCAPIv1::SystemusersApi.new

id = 'id_example' # String | 

content_type = 'application/json' # String | 

accept = 'application/json' # String | 

opts = { 
  body: JCAPIv1::Usersystembindingsput.new, # Usersystembindingsput | 
  x_org_id: '' # String | 
}

begin
  #Update a system user binding
  result = api_instance.systemusers_systems_binding_put(id, content_type, accept, opts)
  p result
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_systems_binding_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **content_type** | **String**|  | [default to application/json]
 **accept** | **String**|  | [default to application/json]
 **body** | [**Usersystembindingsput**](Usersystembindingsput.md)|  | [optional] 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

[**Usersystembinding**](Usersystembinding.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



# **systemusers_unlock**
> systemusers_unlock(id, opts)

Unlock a system user

This endpoint allows you to unlock a user's account.

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

api_instance = JCAPIv1::SystemusersApi.new

id = 'id_example' # String | 

opts = { 
  x_org_id: '' # String | 
}

begin
  #Unlock a system user
  api_instance.systemusers_unlock(id, opts)
rescue JCAPIv1::ApiError => e
  puts "Exception when calling SystemusersApi->systemusers_unlock: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **x_org_id** | **String**|  | [optional] [default to ]

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json; charset=utf-8



