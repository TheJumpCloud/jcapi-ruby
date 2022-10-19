# JCAPIv2::PolicyGroupMembersMembershipApi

All URIs are relative to *https://console.jumpcloud.com/api/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**graph_policy_group_members_list**](PolicyGroupMembersMembershipApi.md#graph_policy_group_members_list) | **GET** /policygroups/{group_id}/members | List the members of a Policy Group
[**graph_policy_group_members_post**](PolicyGroupMembersMembershipApi.md#graph_policy_group_members_post) | **POST** /policygroups/{group_id}/members | Manage the members of a Policy Group
[**graph_policy_group_membership**](PolicyGroupMembersMembershipApi.md#graph_policy_group_membership) | **GET** /policygroups/{group_id}/membership | List the Policy Group&#x27;s membership

# **graph_policy_group_members_list**
> Array&lt;GraphConnection&gt; graph_policy_group_members_list(group_id, opts)

List the members of a Policy Group

This endpoint returns the Policy members of a Policy Group.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/members \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

### Example
```ruby
# load the gem
require 'jcapiv2'
# setup authorization
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
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the Policy Group. | 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**Array&lt;GraphConnection&gt;**](GraphConnection.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **graph_policy_group_members_post**
> graph_policy_group_members_post(group_id, opts)

Manage the members of a Policy Group

This endpoint allows you to manage the Policy members of a Policy Group.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/members \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"policy\",     \"id\": \"{Policy_ID}\"   }' ```

### Example
```ruby
# load the gem
require 'jcapiv2'
# setup authorization
JCAPIv2.configure do |config|
  # Configure API key authorization: x-api-key
  config.api_key['x-api-key'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['x-api-key'] = 'Bearer'
end

api_instance = JCAPIv2::PolicyGroupMembersMembershipApi.new
group_id = 'group_id_example' # String | ObjectID of the Policy Group.
opts = { 
  body: JCAPIv2::GraphOperationPolicyGroupMember.new # GraphOperationPolicyGroupMember | 
  x_org_id: 'x_org_id_example' # String | Organization identifier that can be obtained from console settings.
}

begin
  #Manage the members of a Policy Group
  api_instance.graph_policy_group_members_post(group_id, opts)
rescue JCAPIv2::ApiError => e
  puts "Exception when calling PolicyGroupMembersMembershipApi->graph_policy_group_members_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the Policy Group. | 
 **body** | [**GraphOperationPolicyGroupMember**](GraphOperationPolicyGroupMember.md)|  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

nil (empty response body)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined



# **graph_policy_group_membership**
> Array&lt;GraphObjectWithPaths&gt; graph_policy_group_membership(group_id, opts)

List the Policy Group's membership

This endpoint returns all Policy members that are a member of this Policy Group.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/membership \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```

### Example
```ruby
# load the gem
require 'jcapiv2'
# setup authorization
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
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group_id** | **String**| ObjectID of the Policy Group. | 
 **filter** | [**Array&lt;String&gt;**](String.md)| A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60; | [optional] 
 **limit** | **Integer**| The number of records to return at once. Limited to 100. | [optional] [default to 10]
 **skip** | **Integer**| The offset into the records to return. | [optional] [default to 0]
 **sort** | [**Array&lt;String&gt;**](String.md)| The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  | [optional] 
 **x_org_id** | **String**| Organization identifier that can be obtained from console settings. | [optional] 

### Return type

[**Array&lt;GraphObjectWithPaths&gt;**](GraphObjectWithPaths.md)

### Authorization

[x-api-key](../README.md#x-api-key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



