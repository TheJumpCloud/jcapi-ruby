# JCAPIv2::SoftwareAppSettings

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**allow_update_delay** | **BOOLEAN** |  | [optional] [default to false]
**apple_vpp** | [**SoftwareAppAppleVpp**](SoftwareAppAppleVpp.md) |  | [optional] 
**asset_kind** | **String** | The manifest asset kind (ex: software). | [optional] 
**asset_sha256_size** | **Integer** | The incremental size to use for summing the package as it is downloaded. | [optional] 
**asset_sha256_strings** | **Array&lt;String&gt;** | The array of checksums, one each for the hash size up to the total size of the package. | [optional] 
**auto_update** | **BOOLEAN** |  | [optional] [default to false]
**description** | **String** | The software app description. | [optional] 
**desired_state** | **String** | State of Install or Uninstall | [optional] 
**location** | **String** | Repository where the app is located within the package manager | [optional] 
**location_object_id** | **String** | ID of the repository where the app is located within the package manager | [optional] 
**package_id** | **String** |  | [optional] 
**package_kind** | **String** | The package manifest kind (ex: software-package). | [optional] 
**package_manager** | **String** | App store serving the app: APPLE_VPP, CHOCOLATEY, etc. | [optional] 
**package_subtitle** | **String** | The package manifest subtitle. | [optional] 
**package_version** | **String** | The package manifest version. | [optional] 

