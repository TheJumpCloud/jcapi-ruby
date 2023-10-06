# JCAPIv1::Organizationsettingsput

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**contact_email** | **String** |  | [optional] 
**contact_name** | **String** |  | [optional] 
**device_identification_enabled** | **BOOLEAN** |  | [optional] 
**disable_google_login** | **BOOLEAN** |  | [optional] 
**disable_ldap** | **BOOLEAN** |  | [optional] 
**disable_um** | **BOOLEAN** |  | [optional] 
**duplicate_ldap_groups** | **BOOLEAN** |  | [optional] 
**email_disclaimer** | **String** |  | [optional] 
**enable_managed_uid** | **BOOLEAN** |  | [optional] 
**features** | [**OrganizationsettingsFeatures**](OrganizationsettingsFeatures.md) |  | [optional] 
**growth_data** | **Object** | Object containing Optimizely experimentIds and states corresponding to them | [optional] 
**logo** | **String** |  | [optional] 
**max_system_users** | **Integer** |  | [optional] 
**name** | **String** |  | [optional] 
**new_system_user_state_defaults** | [**OrganizationsettingsputNewSystemUserStateDefaults**](OrganizationsettingsputNewSystemUserStateDefaults.md) |  | [optional] 
**password_compliance** | **String** |  | [optional] 
**password_policy** | [**OrganizationsettingsputPasswordPolicy**](OrganizationsettingsputPasswordPolicy.md) |  | [optional] 
**show_intro** | **BOOLEAN** |  | [optional] 
**system_user_password_expiration_in_days** | **Integer** |  | [optional] 
**system_users_can_edit** | **BOOLEAN** |  | [optional] 
**trusted_app_config** | [**TrustedappConfigPut**](TrustedappConfigPut.md) |  | [optional] 
**user_portal** | [**OrganizationsettingsUserPortal**](OrganizationsettingsUserPortal.md) |  | [optional] 

