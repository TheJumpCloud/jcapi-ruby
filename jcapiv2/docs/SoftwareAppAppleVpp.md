# JCAPIv2::SoftwareAppAppleVpp

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**app_configuration** | **String** | Text sent to configure the application, the text should be a valid plist.  Returned only by &#x27;GET /softwareapps/{id}&#x27;. | [optional] 
**assigned_licenses** | **Integer** |  | [optional] 
**available_licenses** | **Integer** |  | [optional] 
**details** | **Object** | App details returned by iTunes API. See example. The properties in this field are out of our control and we cannot guarantee consistency, so it should be checked by the client and manage the details accordingly. | [optional] 
**is_config_enabled** | **BOOLEAN** | Denotes if configuration has been enabled for the application.  Returned only by &#x27;&#x27;GET /softwareapps/{id}&#x27;&#x27;. | [optional] 
**supported_device_families** | **Array&lt;String&gt;** | The supported device families for this VPP Application. | [optional] 
**total_licenses** | **Integer** |  | [optional] 

