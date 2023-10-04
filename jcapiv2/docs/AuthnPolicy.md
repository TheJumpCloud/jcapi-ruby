# JCAPIv2::AuthnPolicy

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**conditions** | **Object** | Conditions may be added to an authentication policy using the following conditional language:  &#x60;&#x60;&#x60; &lt;conditions&gt; ::&#x3D; &lt;expression&gt; &lt;expression&gt; ::&#x3D; &lt;deviceEncrypted&gt; | &lt;deviceManaged&gt; | &lt;ipAddressIn&gt; |                  &lt;locationIn&gt; | &lt;notExpression&gt; | &lt;allExpression&gt; |                  &lt;anyExpression&gt; &lt;deviceEncrypted&gt; ::&#x3D; { \&quot;deviceEncrypted\&quot;: &lt;boolean&gt; } &lt;deviceManaged&gt; ::&#x3D; { \&quot;deviceManaged\&quot;: &lt;boolean&gt; } &lt;ipAddressIn&gt; ::&#x3D; { \&quot;ipAddressIn\&quot;: [ &lt;objectId&gt;, ... ] } &lt;locationIn&gt; ::&#x3D; { \&quot;locationIn\&quot;: {                      \&quot;countries\&quot;: [                        &lt;iso_3166_country_code&gt;, ...                      ]                    }                  } &lt;notExpression&gt; ::&#x3D; { \&quot;not\&quot;: &lt;expression&gt; } &lt;allExpression&gt; ::&#x3D; { \&quot;all\&quot;: [ &lt;expression&gt;, ... ] } &lt;anyExpression&gt; ::&#x3D; { \&quot;any\&quot;: [ &lt;expression&gt;, ... ] } &#x60;&#x60;&#x60;  For example, to add a condition that applies to IP addresses in a given list, the following condition can be added:  &#x60;&#x60;&#x60; {\&quot;ipAddressIn\&quot;: [ &lt;ip_list_object_id&gt; ]} &#x60;&#x60;&#x60;  If you would rather exclude IP addresses in the given lists, the following condition could be added:  &#x60;&#x60;&#x60; {   \&quot;not\&quot;: {     \&quot;ipAddressIn\&quot;: [ &lt;ip_list_object_id_1&gt;, &lt;ip_list_object_id_2&gt; ]   } } &#x60;&#x60;&#x60;  You may also include more than one condition and choose whether \&quot;all\&quot; or \&quot;any\&quot; of them must be met for the policy to apply:  &#x60;&#x60;&#x60; {   \&quot;all\&quot;: [     {       \&quot;ipAddressIn\&quot;: [ &lt;ip_list_object_id&gt;, ... ]     },     {       \&quot;deviceManaged\&quot;: true     },     {       \&quot;locationIn\&quot;: {         countries: [ &lt;iso_3166_country_code&gt;, ... ]       }     }   ] } &#x60;&#x60;&#x60; | [optional] 
**description** | **String** |  | [optional] 
**disabled** | **BOOLEAN** |  | [optional] 
**effect** | [**AuthnPolicyEffect**](AuthnPolicyEffect.md) |  | [optional] 
**id** | **String** |  | [optional] 
**name** | **String** |  | [optional] 
**targets** | [**AuthnPolicyTargets**](AuthnPolicyTargets.md) |  | [optional] 
**type** | [**AuthnPolicyType**](AuthnPolicyType.md) |  | [optional] 

