# JCAPIv2::SoftwareAppGoogleAndroid

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**app_pricing** | **String** | Whether this app is free, free with in-app purchases, or paid. | [optional] 
**app_version** | **String** | Latest version currently available for this app. | [optional] 
**author** | **String** | The name of the author of this app. | [optional] 
**auto_update_mode** | **String** | Controls the auto-update mode for the app. | [optional] 
**category** | **String** | The app category (e.g. COMMUNICATION, SOCIAL, etc.). | [optional] 
**content_rating** | **String** | The content rating for this app. | [optional] 
**display_mode** | **String** | The display mode of the web app. | [optional] 
**distribution_channel** | **String** | How and to whom the package is made available. | [optional] 
**full_description** | **String** | Full app description, if available. | [optional] 
**icon_url** | **String** | A link to an image that can be used as an icon for the app. | [optional] 
**install_type** | **String** | The type of installation to perform for an app. | [optional] 
**managed_configuration_template_id** | **String** | The managed configurations template for the app. | [optional] 
**managed_properties** | **BOOLEAN** | Indicates whether this app has managed properties or not. | [optional] 
**min_sdk_version** | **Integer** | The minimum Android SDK necessary to run the app. | [optional] 
**name** | **String** | The name of the app in the form enterprises/{enterprise}/applications/{packageName}. | [optional] 
**permission_grants** | [**Array&lt;SoftwareAppPermissionGrants&gt;**](SoftwareAppPermissionGrants.md) |  | [optional] 
**runtime_permission** | **String** | The policy for granting permission requests to apps. | [optional] 
**start_url** | **String** | The start URL, i.e. the URL that should load when the user opens the application. Applicable only for webapps. | [optional] 
**type** | **String** | Type of this android application. | [optional] 
**update_time** | **String** | The approximate time (within 7 days) the app was last published. | [optional] 
**version_code** | **Integer** | The current version of the web app. | [optional] 

