# JCAPIv2::AppleMdmPatch

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**ades** | [**ADES**](ADES.md) |  | [optional] 
**allow_mobile_user_enrollment** | **BOOLEAN** | A toggle to allow mobile device enrollment for an organization. | [optional] 
**apple_cert_creator_apple_id** | **String** | The Apple ID of the admin who created the Apple signed certificate. | [optional] 
**apple_signed_cert** | **String** | A signed certificate obtained from Apple after providing Apple with the plist file provided on POST. | [optional] 
**default_ios_user_enrollment_device_group_id** | **String** | ObjectId uniquely identifying the MDM default iOS user enrollment device group. | [optional] 
**default_system_group_id** | **String** | ObjectId uniquely identifying the MDM default System Group. | [optional] 
**dep** | [**DEP**](DEP.md) |  | [optional] 
**encrypted_dep_server_token** | **String** | The S/MIME encoded DEP Server Token returned by Apple Business Manager when creating an MDM instance. | [optional] 
**name** | **String** | A new name for the Apple MDM configuration. | [optional] 

