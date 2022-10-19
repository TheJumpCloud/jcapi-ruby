=begin
#JumpCloud API

## Overview  JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.  # Directory Objects  This API offers the ability to interact with some of our core features; otherwise known as Directory Objects. The Directory Objects are:  * Commands * Policies * Policy Groups * Applications * Systems * Users * User Groups * System Groups * Radius Servers * Directories: Office 365, LDAP,G-Suite, Active Directory * Duo accounts and applications.  The Directory Object is an important concept to understand in order to successfully use JumpCloud API.  ## JumpCloud Graph  We've also introduced the concept of the JumpCloud Graph along with  Directory Objects. The Graph is a powerful aspect of our platform which will enable you to associate objects with each other, or establish membership for certain objects to become members of other objects.  Specific `GET` endpoints will allow you to traverse the JumpCloud Graph to return all indirect and directly bound objects in your organization.  | ![alt text](https://s3.amazonaws.com/jumpcloud-kb/Knowledge+Base+Photos/API+Docs/jumpcloud_graph.png \"JumpCloud Graph Model Example\") | |:--:| | **This diagram highlights our association and membership model as it relates to Directory Objects.** |  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/v2/systemgroups\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 2.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.32
=end

module JCAPIv2
  class AppleMDMApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Get Apple MDM CSR Plist
    # Retrieves an Apple MDM signed CSR Plist for an organization.  The user must supply the returned plist to Apple for signing, and then provide the certificate provided by Apple back into the PUT API.  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/csr \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param apple_mdm_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [AppleMdmSignedCsrPlist]
    def applemdms_csrget(apple_mdm_id, opts = {})
      data, _status_code, _headers = applemdms_csrget_with_http_info(apple_mdm_id, opts)
      data
    end

    # Get Apple MDM CSR Plist
    # Retrieves an Apple MDM signed CSR Plist for an organization.  The user must supply the returned plist to Apple for signing, and then provide the certificate provided by Apple back into the PUT API.  #### Sample Request &#x60;&#x60;&#x60;   curl -X GET https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/csr \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(AppleMdmSignedCsrPlist, Integer, Hash)>] AppleMdmSignedCsrPlist data, response status code and response headers
    def applemdms_csrget_with_http_info(apple_mdm_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_csrget ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_csrget"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/csr'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/octet-stream'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'AppleMdmSignedCsrPlist' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_csrget\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete an Apple MDM
    # Removes an Apple MDM configuration.  Warning: This is a destructive operation and will remove your Apple Push Certificates.  We will no longer be able to manage your devices and the only recovery option is to re-register all devices into MDM.  #### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/v2/applemdms/{id} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [AppleMDM]
    def applemdms_delete(id, opts = {})
      data, _status_code, _headers = applemdms_delete_with_http_info(id, opts)
      data
    end

    # Delete an Apple MDM
    # Removes an Apple MDM configuration.  Warning: This is a destructive operation and will remove your Apple Push Certificates.  We will no longer be able to manage your devices and the only recovery option is to re-register all devices into MDM.  #### Sample Request &#x60;&#x60;&#x60; curl -X DELETE https://console.jumpcloud.com/api/v2/applemdms/{id} \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(AppleMDM, Integer, Hash)>] AppleMDM data, response status code and response headers
    def applemdms_delete_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_delete ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling AppleMDMApi.applemdms_delete"
      end
      # resource path
      local_var_path = '/applemdms/{id}'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'AppleMDM' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_delete\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Remove an Apple MDM Device's Enrollment
    # Remove a single Apple MDM device from MDM enrollment.  #### Sample Request ```   curl -X DELETE https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id} \\   -H 'accept: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [AppleMdmDevice]
    def applemdms_deletedevice(apple_mdm_id, device_id, opts = {})
      data, _status_code, _headers = applemdms_deletedevice_with_http_info(apple_mdm_id, device_id, opts)
      data
    end

    # Remove an Apple MDM Device&#x27;s Enrollment
    # Remove a single Apple MDM device from MDM enrollment.  #### Sample Request &#x60;&#x60;&#x60;   curl -X DELETE https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id} \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(AppleMdmDevice, Integer, Hash)>] AppleMdmDevice data, response status code and response headers
    def applemdms_deletedevice_with_http_info(apple_mdm_id, device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_deletedevice ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_deletedevice"
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling AppleMDMApi.applemdms_deletedevice"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/devices/{device_id}'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s).sub('{' + 'device_id' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'AppleMdmDevice' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_deletedevice\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get Apple MDM DEP Public Key
    # Retrieves an Apple MDM DEP Public Key.
    # @param apple_mdm_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [AppleMdmPublicKeyCert]
    def applemdms_depkeyget(apple_mdm_id, opts = {})
      data, _status_code, _headers = applemdms_depkeyget_with_http_info(apple_mdm_id, opts)
      data
    end

    # Get Apple MDM DEP Public Key
    # Retrieves an Apple MDM DEP Public Key.
    # @param apple_mdm_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(AppleMdmPublicKeyCert, Integer, Hash)>] AppleMdmPublicKeyCert data, response status code and response headers
    def applemdms_depkeyget_with_http_info(apple_mdm_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_depkeyget ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_depkeyget"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/depkey'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/x-pem-file'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'AppleMdmPublicKeyCert' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_depkeyget\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Clears the Activation Lock for a Device
    # Clears the activation lock on the specified device.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/clearActivationLock \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def applemdms_devices_clear_activation_lock(apple_mdm_id, device_id, opts = {})
      applemdms_devices_clear_activation_lock_with_http_info(apple_mdm_id, device_id, opts)
      nil
    end

    # Clears the Activation Lock for a Device
    # Clears the activation lock on the specified device.  #### Sample Request &#x60;&#x60;&#x60;   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/clearActivationLock \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def applemdms_devices_clear_activation_lock_with_http_info(apple_mdm_id, device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_devices_clear_activation_lock ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_devices_clear_activation_lock"
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling AppleMDMApi.applemdms_devices_clear_activation_lock"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/devices/{device_id}/clearActivationLock'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s).sub('{' + 'device_id' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_devices_clear_activation_lock\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Refresh activation lock information for a device
    # Refreshes the activation lock information for a device  #### Sample Request  ``` curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/refreshActivationLockInformation \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def applemdms_devices_refresh_activation_lock_information(apple_mdm_id, device_id, opts = {})
      applemdms_devices_refresh_activation_lock_information_with_http_info(apple_mdm_id, device_id, opts)
      nil
    end

    # Refresh activation lock information for a device
    # Refreshes the activation lock information for a device  #### Sample Request  &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/refreshActivationLockInformation \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def applemdms_devices_refresh_activation_lock_information_with_http_info(apple_mdm_id, device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_devices_refresh_activation_lock_information ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_devices_refresh_activation_lock_information"
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling AppleMDMApi.applemdms_devices_refresh_activation_lock_information"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/devices/{device_id}/refreshActivationLockInformation'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s).sub('{' + 'device_id' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_devices_refresh_activation_lock_information\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Erase Device
    # Erases a DEP-enrolled device.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/erase \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [DeviceIdEraseBody] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def applemdms_deviceserase(apple_mdm_id, device_id, opts = {})
      applemdms_deviceserase_with_http_info(apple_mdm_id, device_id, opts)
      nil
    end

    # Erase Device
    # Erases a DEP-enrolled device.  #### Sample Request &#x60;&#x60;&#x60;   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/erase \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [DeviceIdEraseBody] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def applemdms_deviceserase_with_http_info(apple_mdm_id, device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_deviceserase ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_deviceserase"
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling AppleMDMApi.applemdms_deviceserase"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/devices/{device_id}/erase'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s).sub('{' + 'device_id' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(opts[:'body']) 

      return_type = opts[:return_type] 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_deviceserase\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List AppleMDM Devices
    # Lists all Apple MDM devices.  The filter and sort queries will allow the following fields: `createdAt` `depRegistered` `enrolled` `id` `osVersion` `serialNumber` `udid`  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices \\   -H 'accept: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```
    # @param apple_mdm_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :x_total_count 
    # @return [Array<AppleMdmDevice>]
    def applemdms_deviceslist(apple_mdm_id, opts = {})
      data, _status_code, _headers = applemdms_deviceslist_with_http_info(apple_mdm_id, opts)
      data
    end

    # List AppleMDM Devices
    # Lists all Apple MDM devices.  The filter and sort queries will allow the following fields: &#x60;createdAt&#x60; &#x60;depRegistered&#x60; &#x60;enrolled&#x60; &#x60;id&#x60; &#x60;osVersion&#x60; &#x60;serialNumber&#x60; &#x60;udid&#x60;  #### Sample Request &#x60;&#x60;&#x60;   curl -X GET https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :x_total_count 
    # @return [Array<(Array<AppleMdmDevice>, Integer, Hash)>] Array<AppleMdmDevice> data, response status code and response headers
    def applemdms_deviceslist_with_http_info(apple_mdm_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_deviceslist ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_deviceslist"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/devices'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?
      header_params[:'x-total-count'] = opts[:'x_total_count'] if !opts[:'x_total_count'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<AppleMdmDevice>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_deviceslist\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Lock Device
    # Locks a DEP-enrolled device.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/lock \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [DeviceIdLockBody] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def applemdms_deviceslock(apple_mdm_id, device_id, opts = {})
      applemdms_deviceslock_with_http_info(apple_mdm_id, device_id, opts)
      nil
    end

    # Lock Device
    # Locks a DEP-enrolled device.  #### Sample Request &#x60;&#x60;&#x60;   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/lock \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [DeviceIdLockBody] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def applemdms_deviceslock_with_http_info(apple_mdm_id, device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_deviceslock ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_deviceslock"
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling AppleMDMApi.applemdms_deviceslock"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/devices/{device_id}/lock'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s).sub('{' + 'device_id' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(opts[:'body']) 

      return_type = opts[:return_type] 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_deviceslock\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Restart Device
    # Restarts a DEP-enrolled device.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/restart \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{\"kextPaths\": [\"Path1\", \"Path2\"]}' ```
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [DeviceIdRestartBody] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def applemdms_devicesrestart(apple_mdm_id, device_id, opts = {})
      applemdms_devicesrestart_with_http_info(apple_mdm_id, device_id, opts)
      nil
    end

    # Restart Device
    # Restarts a DEP-enrolled device.  #### Sample Request &#x60;&#x60;&#x60;   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/restart \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{\&quot;kextPaths\&quot;: [\&quot;Path1\&quot;, \&quot;Path2\&quot;]}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [DeviceIdRestartBody] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def applemdms_devicesrestart_with_http_info(apple_mdm_id, device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_devicesrestart ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_devicesrestart"
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling AppleMDMApi.applemdms_devicesrestart"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/devices/{device_id}/restart'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s).sub('{' + 'device_id' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(opts[:'body']) 

      return_type = opts[:return_type] 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_devicesrestart\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Shut Down Device
    # Shuts down a DEP-enrolled device.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/shutdown \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def applemdms_devicesshutdown(apple_mdm_id, device_id, opts = {})
      applemdms_devicesshutdown_with_http_info(apple_mdm_id, device_id, opts)
      nil
    end

    # Shut Down Device
    # Shuts down a DEP-enrolled device.  #### Sample Request &#x60;&#x60;&#x60;   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/shutdown \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def applemdms_devicesshutdown_with_http_info(apple_mdm_id, device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_devicesshutdown ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_devicesshutdown"
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling AppleMDMApi.applemdms_devicesshutdown"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/devices/{device_id}/shutdown'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s).sub('{' + 'device_id' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_devicesshutdown\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get an Apple MDM Enrollment Profile
    # Get an enrollment profile  Currently only requesting the mobileconfig is supported.  #### Sample Request  ``` curl https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/enrollmentprofiles/{ID} \\   -H 'accept: application/x-apple-aspen-config' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param apple_mdm_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Mobileconfig]
    def applemdms_enrollmentprofilesget(apple_mdm_id, id, opts = {})
      data, _status_code, _headers = applemdms_enrollmentprofilesget_with_http_info(apple_mdm_id, id, opts)
      data
    end

    # Get an Apple MDM Enrollment Profile
    # Get an enrollment profile  Currently only requesting the mobileconfig is supported.  #### Sample Request  &#x60;&#x60;&#x60; curl https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/enrollmentprofiles/{ID} \\   -H &#x27;accept: application/x-apple-aspen-config&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Mobileconfig, Integer, Hash)>] Mobileconfig data, response status code and response headers
    def applemdms_enrollmentprofilesget_with_http_info(apple_mdm_id, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_enrollmentprofilesget ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_enrollmentprofilesget"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling AppleMDMApi.applemdms_enrollmentprofilesget"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/enrollmentprofiles/{id}'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s).sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/x-apple-aspen-config'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Mobileconfig' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_enrollmentprofilesget\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Apple MDM Enrollment Profiles
    # Get a list of enrollment profiles for an apple mdm.  Note: currently only one enrollment profile is supported.  #### Sample Request ```  curl https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/enrollmentprofiles \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param apple_mdm_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<AppleMDM>]
    def applemdms_enrollmentprofileslist(apple_mdm_id, opts = {})
      data, _status_code, _headers = applemdms_enrollmentprofileslist_with_http_info(apple_mdm_id, opts)
      data
    end

    # List Apple MDM Enrollment Profiles
    # Get a list of enrollment profiles for an apple mdm.  Note: currently only one enrollment profile is supported.  #### Sample Request &#x60;&#x60;&#x60;  curl https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/enrollmentprofiles \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<AppleMDM>, Integer, Hash)>] Array<AppleMDM> data, response status code and response headers
    def applemdms_enrollmentprofileslist_with_http_info(apple_mdm_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_enrollmentprofileslist ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_enrollmentprofileslist"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/enrollmentprofiles'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<AppleMDM>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_enrollmentprofileslist\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Details of an AppleMDM Device
    # Gets a single Apple MDM device.  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id} \\   -H 'accept: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [AppleMdmDevice]
    def applemdms_getdevice(apple_mdm_id, device_id, opts = {})
      data, _status_code, _headers = applemdms_getdevice_with_http_info(apple_mdm_id, device_id, opts)
      data
    end

    # Details of an AppleMDM Device
    # Gets a single Apple MDM device.  #### Sample Request &#x60;&#x60;&#x60;   curl -X GET https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id} \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(AppleMdmDevice, Integer, Hash)>] AppleMdmDevice data, response status code and response headers
    def applemdms_getdevice_with_http_info(apple_mdm_id, device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_getdevice ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_getdevice"
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling AppleMDMApi.applemdms_getdevice"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/devices/{device_id}'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s).sub('{' + 'device_id' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'AppleMdmDevice' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_getdevice\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Apple MDMs
    # Get a list of all Apple MDM configurations.  An empty topic indicates that a signed certificate from Apple has not been provided to the PUT endpoint yet.  Note: currently only one MDM configuration per organization is supported.  #### Sample Request ``` curl https://console.jumpcloud.com/api/v2/applemdms \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<AppleMDM>]
    def applemdms_list(opts = {})
      data, _status_code, _headers = applemdms_list_with_http_info(opts)
      data
    end

    # List Apple MDMs
    # Get a list of all Apple MDM configurations.  An empty topic indicates that a signed certificate from Apple has not been provided to the PUT endpoint yet.  Note: currently only one MDM configuration per organization is supported.  #### Sample Request &#x60;&#x60;&#x60; curl https://console.jumpcloud.com/api/v2/applemdms \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<AppleMDM>, Integer, Hash)>] Array<AppleMDM> data, response status code and response headers
    def applemdms_list_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_list ...'
      end
      # resource path
      local_var_path = '/applemdms'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<AppleMDM>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Update an Apple MDM
    # Updates an Apple MDM configuration.  This endpoint is used to supply JumpCloud with a signed certificate from Apple in order to finalize the setup and allow JumpCloud to manage your devices.  It may also be used to update the DEP Settings.  #### Sample Request ```   curl -X PUT https://console.jumpcloud.com/api/v2/applemdms/{ID} \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"name\": \"MDM name\",     \"appleSignedCert\": \"{CERTIFICATE}\",     \"encryptedDepServerToken\": \"{SERVER_TOKEN}\",     \"dep\": {       \"welcomeScreen\": {         \"title\": \"Welcome\",         \"paragraph\": \"In just a few steps, you will be working securely from your Mac.\",         \"button\": \"continue\",       },     },   }' ```
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [AppleMdmPatchInput] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [AppleMDM]
    def applemdms_put(id, opts = {})
      data, _status_code, _headers = applemdms_put_with_http_info(id, opts)
      data
    end

    # Update an Apple MDM
    # Updates an Apple MDM configuration.  This endpoint is used to supply JumpCloud with a signed certificate from Apple in order to finalize the setup and allow JumpCloud to manage your devices.  It may also be used to update the DEP Settings.  #### Sample Request &#x60;&#x60;&#x60;   curl -X PUT https://console.jumpcloud.com/api/v2/applemdms/{ID} \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;name\&quot;: \&quot;MDM name\&quot;,     \&quot;appleSignedCert\&quot;: \&quot;{CERTIFICATE}\&quot;,     \&quot;encryptedDepServerToken\&quot;: \&quot;{SERVER_TOKEN}\&quot;,     \&quot;dep\&quot;: {       \&quot;welcomeScreen\&quot;: {         \&quot;title\&quot;: \&quot;Welcome\&quot;,         \&quot;paragraph\&quot;: \&quot;In just a few steps, you will be working securely from your Mac.\&quot;,         \&quot;button\&quot;: \&quot;continue\&quot;,       },     },   }&#x27; &#x60;&#x60;&#x60;
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [AppleMdmPatchInput] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(AppleMDM, Integer, Hash)>] AppleMDM data, response status code and response headers
    def applemdms_put_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_put ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling AppleMDMApi.applemdms_put"
      end
      # resource path
      local_var_path = '/applemdms/{id}'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(opts[:'body']) 

      return_type = opts[:return_type] || 'AppleMDM' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_put\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Refresh DEP Devices
    # Refreshes the list of devices that a JumpCloud admin has added to their virtual MDM in Apple Business Manager - ABM so that they can be DEP enrolled with JumpCloud.  #### Sample Request ```   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/refreshdepdevices \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{}' ```
    # @param apple_mdm_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def applemdms_refreshdepdevices(apple_mdm_id, opts = {})
      applemdms_refreshdepdevices_with_http_info(apple_mdm_id, opts)
      nil
    end

    # Refresh DEP Devices
    # Refreshes the list of devices that a JumpCloud admin has added to their virtual MDM in Apple Business Manager - ABM so that they can be DEP enrolled with JumpCloud.  #### Sample Request &#x60;&#x60;&#x60;   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/refreshdepdevices \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
    # @param apple_mdm_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def applemdms_refreshdepdevices_with_http_info(apple_mdm_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AppleMDMApi.applemdms_refreshdepdevices ...'
      end
      # verify the required parameter 'apple_mdm_id' is set
      if @api_client.config.client_side_validation && apple_mdm_id.nil?
        fail ArgumentError, "Missing the required parameter 'apple_mdm_id' when calling AppleMDMApi.applemdms_refreshdepdevices"
      end
      # resource path
      local_var_path = '/applemdms/{apple_mdm_id}/refreshdepdevices'.sub('{' + 'apple_mdm_id' + '}', apple_mdm_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AppleMDMApi#applemdms_refreshdepdevices\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
