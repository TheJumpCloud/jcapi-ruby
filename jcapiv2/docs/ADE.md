# JCAPIv2::ADE

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**default_device_group_object_ids** | **Array&lt;String&gt;** | An array of ObjectIDs identifying the default device groups for this specific type (based on the OS family) of automated device enrollment. Currently, only a single DeviceGroupID is supported. | [optional] 
**enable_zero_touch_enrollment** | **BOOLEAN** | A toggle to determine if ADE registered devices should go through JumpCloud Zero Touch Enrollment. | [optional] 
**setup_assistant_options** | [**Array&lt;DEPSetupAssistantOption&gt;**](DEPSetupAssistantOption.md) | A Setup Option wrapped as an object | [optional] 
**setup_options** | [**Array&lt;SetupAssistantOption&gt;**](SetupAssistantOption.md) | A list of configured setup options for this enrollment. | [optional] 
**welcome_screen** | [**DEPWelcomeScreen**](DEPWelcomeScreen.md) |  | [optional] 

