# JCAPIv1::ApplicationtemplateOidc

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**grant_types** | **Array&lt;String&gt;** | The grant types allowed. | [optional] 
**redirect_uris** | **Array&lt;String&gt;** | List of allowed redirectUris | [optional] 
**sso_url** | **String** | The relying party url to trigger an oidc login. | [optional] 
**token_endpoint_auth_method** | **String** | Method that the client uses to authenticate when requesting a token. If &#x27;none&#x27;, then the client must use PKCE. If &#x27;client_secret_post&#x27;, then the secret is passed in the post body when requesting the token. | [optional] 

