# JCAPIv2::ImportUsersRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**allow_user_reactivation** | **BOOLEAN** | A boolean value to allow the reactivation of suspended users | [optional] [default to true]
**operations** | [**Array&lt;ImportOperation&gt;**](ImportOperation.md) | Operations to be performed on the user list returned from the application | [optional] 
**query_string** | **String** | Query string to filter and sort the user list returned from the application.  The supported filtering and sorting varies by application.  If no value is sent, all users are returned. **Example:** \&quot;location&#x3D;Chicago&amp;department&#x3D;IT\&quot;Query string used to retrieve users from service | [optional] [default to &#x27;&#x27;]

