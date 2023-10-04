=begin
#JumpCloud API

## Overview  JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.  ## API Best Practices  Read the linked Help Article below for guidance on retrying failed requests to JumpCloud's REST API, as well as best practices for structuring subsequent retry requests. Customizing retry mechanisms based on these recommendations will increase the reliability and dependability of your API calls.  Covered topics include: 1. Important Considerations 2. Supported HTTP Request Methods 3. Response codes 4. API Key rotation 5. Paginating 6. Error handling 7. Retry rates  [JumpCloud Help Center - API Best Practices](https://support.jumpcloud.com/support/s/article/JumpCloud-API-Best-Practices)  # Directory Objects  This API offers the ability to interact with some of our core features; otherwise known as Directory Objects. The Directory Objects are:  * Commands * Policies * Policy Groups * Applications * Systems * Users * User Groups * System Groups * Radius Servers * Directories: Office 365, LDAP,G-Suite, Active Directory * Duo accounts and applications.  The Directory Object is an important concept to understand in order to successfully use JumpCloud API.  ## JumpCloud Graph  We've also introduced the concept of the JumpCloud Graph along with  Directory Objects. The Graph is a powerful aspect of our platform which will enable you to associate objects with each other, or establish membership for certain objects to become members of other objects.  Specific `GET` endpoints will allow you to traverse the JumpCloud Graph to return all indirect and directly bound objects in your organization.  | ![alt text](https://s3.amazonaws.com/jumpcloud-kb/Knowledge+Base+Photos/API+Docs/jumpcloud_graph.png \"JumpCloud Graph Model Example\") | |:--:| | **This diagram highlights our association and membership model as it relates to Directory Objects.** |  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/v2/systemgroups\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 2.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.47
=end

module JCAPIv2
  class GoogleEMMApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Erase the Android Device
    # Removes the work profile and all policies from a personal/company-owned Android 8.0+ device. Company owned devices will be relinquished for personal use. Apps and data associated with the personal profile(s) are preserved.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/erase-device \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```
    # @param body 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGoogleEmmCommandResponse]
    def devices_erase_device(body, device_id, opts = {})
      data, _status_code, _headers = devices_erase_device_with_http_info(body, device_id, opts)
      data
    end

    # Erase the Android Device
    # Removes the work profile and all policies from a personal/company-owned Android 8.0+ device. Company owned devices will be relinquished for personal use. Apps and data associated with the personal profile(s) are preserved.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/erase-device \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\ &#x60;&#x60;&#x60;
    # @param body 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGoogleEmmCommandResponse, Integer, Hash)>] JumpcloudGoogleEmmCommandResponse data, response status code and response headers
    def devices_erase_device_with_http_info(body, device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.devices_erase_device ...'
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling GoogleEMMApi.devices_erase_device"
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling GoogleEMMApi.devices_erase_device"
      end
      # resource path
      local_var_path = '/google-emm/devices/{deviceId}/erase-device'.sub('{' + 'deviceId' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(body) 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmCommandResponse' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#devices_erase_device\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get device
    # Gets a Google EMM enrolled device details.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGoogleEmmDevice]
    def devices_get_device(device_id, opts = {})
      data, _status_code, _headers = devices_get_device_with_http_info(device_id, opts)
      data
    end

    # Get device
    # Gets a Google EMM enrolled device details.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\ &#x60;&#x60;&#x60;
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGoogleEmmDevice, Integer, Hash)>] JumpcloudGoogleEmmDevice data, response status code and response headers
    def devices_get_device_with_http_info(device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.devices_get_device ...'
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling GoogleEMMApi.devices_get_device"
      end
      # resource path
      local_var_path = '/google-emm/devices/{deviceId}'.sub('{' + 'deviceId' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmDevice' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#devices_get_device\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get the policy JSON of a device
    # Gets an android JSON policy for a Google EMM enrolled device.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/policy_results \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGoogleEmmDeviceAndroidPolicy]
    def devices_get_device_android_policy(device_id, opts = {})
      data, _status_code, _headers = devices_get_device_android_policy_with_http_info(device_id, opts)
      data
    end

    # Get the policy JSON of a device
    # Gets an android JSON policy for a Google EMM enrolled device.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/policy_results \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\ &#x60;&#x60;&#x60;
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGoogleEmmDeviceAndroidPolicy, Integer, Hash)>] JumpcloudGoogleEmmDeviceAndroidPolicy data, response status code and response headers
    def devices_get_device_android_policy_with_http_info(device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.devices_get_device_android_policy ...'
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling GoogleEMMApi.devices_get_device_android_policy"
      end
      # resource path
      local_var_path = '/google-emm/devices/{deviceId}/policy_results'.sub('{' + 'deviceId' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmDeviceAndroidPolicy' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#devices_get_device_android_policy\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List devices
    # Lists google EMM enrolled devices.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/google-emm/enterprises/{enterprise_object_id}/devices \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```
    # @param enterprise_object_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :limit The number of records to return at once. Limited to 100. (default to 100)
    # @option opts [String] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter 
    # @return [JumpcloudGoogleEmmListDevicesResponse]
    def devices_list_devices(enterprise_object_id, opts = {})
      data, _status_code, _headers = devices_list_devices_with_http_info(enterprise_object_id, opts)
      data
    end

    # List devices
    # Lists google EMM enrolled devices.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/google-emm/enterprises/{enterprise_object_id}/devices \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\ &#x60;&#x60;&#x60;
    # @param enterprise_object_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter 
    # @return [Array<(JumpcloudGoogleEmmListDevicesResponse, Integer, Hash)>] JumpcloudGoogleEmmListDevicesResponse data, response status code and response headers
    def devices_list_devices_with_http_info(enterprise_object_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.devices_list_devices ...'
      end
      # verify the required parameter 'enterprise_object_id' is set
      if @api_client.config.client_side_validation && enterprise_object_id.nil?
        fail ArgumentError, "Missing the required parameter 'enterprise_object_id' when calling GoogleEMMApi.devices_list_devices"
      end
      # resource path
      local_var_path = '/google-emm/enterprises/{enterpriseObjectId}/devices'.sub('{' + 'enterpriseObjectId' + '}', enterprise_object_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :multi) if !opts[:'filter'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmListDevicesResponse' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#devices_list_devices\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Lock device
    # Locks a Google EMM enrolled device, as if the lock screen timeout had expired.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/lock \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```
    # @param body 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGoogleEmmCommandResponse]
    def devices_lock_device(body, device_id, opts = {})
      data, _status_code, _headers = devices_lock_device_with_http_info(body, device_id, opts)
      data
    end

    # Lock device
    # Locks a Google EMM enrolled device, as if the lock screen timeout had expired.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/lock \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\ &#x60;&#x60;&#x60;
    # @param body 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGoogleEmmCommandResponse, Integer, Hash)>] JumpcloudGoogleEmmCommandResponse data, response status code and response headers
    def devices_lock_device_with_http_info(body, device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.devices_lock_device ...'
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling GoogleEMMApi.devices_lock_device"
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling GoogleEMMApi.devices_lock_device"
      end
      # resource path
      local_var_path = '/google-emm/devices/{deviceId}/lock'.sub('{' + 'deviceId' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(body) 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmCommandResponse' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#devices_lock_device\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Reboot device
    # Reboots a Google EMM enrolled device. Only supported on fully managed devices running Android 7.0 or higher.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/reboot \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```
    # @param body 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGoogleEmmCommandResponse]
    def devices_reboot_device(body, device_id, opts = {})
      data, _status_code, _headers = devices_reboot_device_with_http_info(body, device_id, opts)
      data
    end

    # Reboot device
    # Reboots a Google EMM enrolled device. Only supported on fully managed devices running Android 7.0 or higher.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/reboot \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\ &#x60;&#x60;&#x60;
    # @param body 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGoogleEmmCommandResponse, Integer, Hash)>] JumpcloudGoogleEmmCommandResponse data, response status code and response headers
    def devices_reboot_device_with_http_info(body, device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.devices_reboot_device ...'
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling GoogleEMMApi.devices_reboot_device"
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling GoogleEMMApi.devices_reboot_device"
      end
      # resource path
      local_var_path = '/google-emm/devices/{deviceId}/reboot'.sub('{' + 'deviceId' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(body) 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmCommandResponse' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#devices_reboot_device\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Reset Password of a device
    # Reset the user's password of a Google EMM enrolled device.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/resetpassword \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{ 'new_password' : 'string' }' \\ ```
    # @param body 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGoogleEmmCommandResponse]
    def devices_reset_password(body, device_id, opts = {})
      data, _status_code, _headers = devices_reset_password_with_http_info(body, device_id, opts)
      data
    end

    # Reset Password of a device
    # Reset the user&#x27;s password of a Google EMM enrolled device.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/google-emm/devices/{deviceId}/resetpassword \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{ &#x27;new_password&#x27; : &#x27;string&#x27; }&#x27; \\ &#x60;&#x60;&#x60;
    # @param body 
    # @param device_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGoogleEmmCommandResponse, Integer, Hash)>] JumpcloudGoogleEmmCommandResponse data, response status code and response headers
    def devices_reset_password_with_http_info(body, device_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.devices_reset_password ...'
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling GoogleEMMApi.devices_reset_password"
      end
      # verify the required parameter 'device_id' is set
      if @api_client.config.client_side_validation && device_id.nil?
        fail ArgumentError, "Missing the required parameter 'device_id' when calling GoogleEMMApi.devices_reset_password"
      end
      # resource path
      local_var_path = '/google-emm/devices/{deviceId}/resetpassword'.sub('{' + 'deviceId' + '}', device_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(body) 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmCommandResponse' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#devices_reset_password\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create an enrollment token
    # Gets an enrollment token to enroll a device into Google EMM.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/enrollment-tokens \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```
    # @param body 
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGoogleEmmCreateEnrollmentTokenResponse]
    def enrollment_tokens_create_enrollment_token(body, opts = {})
      data, _status_code, _headers = enrollment_tokens_create_enrollment_token_with_http_info(body, opts)
      data
    end

    # Create an enrollment token
    # Gets an enrollment token to enroll a device into Google EMM.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/google-emm/enrollment-tokens \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\ &#x60;&#x60;&#x60;
    # @param body 
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGoogleEmmCreateEnrollmentTokenResponse, Integer, Hash)>] JumpcloudGoogleEmmCreateEnrollmentTokenResponse data, response status code and response headers
    def enrollment_tokens_create_enrollment_token_with_http_info(body, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.enrollment_tokens_create_enrollment_token ...'
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling GoogleEMMApi.enrollment_tokens_create_enrollment_token"
      end
      # resource path
      local_var_path = '/google-emm/enrollment-tokens'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(body) 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmCreateEnrollmentTokenResponse' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#enrollment_tokens_create_enrollment_token\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create a Google Enterprise
    # Creates a Google EMM enterprise.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/enterprises \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{ 'signupUrlName': 'string', 'enrollmentToken': 'string' }' \\ ```
    # @param body 
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGoogleEmmEnterprise]
    def enterprises_create_enterprise(body, opts = {})
      data, _status_code, _headers = enterprises_create_enterprise_with_http_info(body, opts)
      data
    end

    # Create a Google Enterprise
    # Creates a Google EMM enterprise.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/google-emm/enterprises \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{ &#x27;signupUrlName&#x27;: &#x27;string&#x27;, &#x27;enrollmentToken&#x27;: &#x27;string&#x27; }&#x27; \\ &#x60;&#x60;&#x60;
    # @param body 
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGoogleEmmEnterprise, Integer, Hash)>] JumpcloudGoogleEmmEnterprise data, response status code and response headers
    def enterprises_create_enterprise_with_http_info(body, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.enterprises_create_enterprise ...'
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling GoogleEMMApi.enterprises_create_enterprise"
      end
      # resource path
      local_var_path = '/google-emm/enterprises'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(body) 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmEnterprise' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#enterprises_create_enterprise\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete a Google Enterprise
    # Removes a Google EMM enterprise.   Warning: This is a destructive operation and will remove all data associated with Google EMM enterprise from JumpCloud including devices and applications associated with the given enterprise.  #### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/v2/google-emm/devices/{enterpriseId} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```
    # @param enterprise_id 
    # @param [Hash] opts the optional parameters
    # @return [Object]
    def enterprises_delete_enterprise(enterprise_id, opts = {})
      data, _status_code, _headers = enterprises_delete_enterprise_with_http_info(enterprise_id, opts)
      data
    end

    # Delete a Google Enterprise
    # Removes a Google EMM enterprise.   Warning: This is a destructive operation and will remove all data associated with Google EMM enterprise from JumpCloud including devices and applications associated with the given enterprise.  #### Sample Request &#x60;&#x60;&#x60; curl -X DELETE https://console.jumpcloud.com/api/v2/google-emm/devices/{enterpriseId} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\ &#x60;&#x60;&#x60;
    # @param enterprise_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Object, Integer, Hash)>] Object data, response status code and response headers
    def enterprises_delete_enterprise_with_http_info(enterprise_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.enterprises_delete_enterprise ...'
      end
      # verify the required parameter 'enterprise_id' is set
      if @api_client.config.client_side_validation && enterprise_id.nil?
        fail ArgumentError, "Missing the required parameter 'enterprise_id' when calling GoogleEMMApi.enterprises_delete_enterprise"
      end
      # resource path
      local_var_path = '/google-emm/enterprises/{enterpriseId}'.sub('{' + 'enterpriseId' + '}', enterprise_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Object' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#enterprises_delete_enterprise\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Test connection with Google
    # Gives a connection status between JumpCloud and Google.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/google-emm/devices/{enterpriseId}/connection-status \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```
    # @param enterprise_id 
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGoogleEmmConnectionStatus]
    def enterprises_get_connection_status(enterprise_id, opts = {})
      data, _status_code, _headers = enterprises_get_connection_status_with_http_info(enterprise_id, opts)
      data
    end

    # Test connection with Google
    # Gives a connection status between JumpCloud and Google.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/google-emm/devices/{enterpriseId}/connection-status \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\ &#x60;&#x60;&#x60;
    # @param enterprise_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGoogleEmmConnectionStatus, Integer, Hash)>] JumpcloudGoogleEmmConnectionStatus data, response status code and response headers
    def enterprises_get_connection_status_with_http_info(enterprise_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.enterprises_get_connection_status ...'
      end
      # verify the required parameter 'enterprise_id' is set
      if @api_client.config.client_side_validation && enterprise_id.nil?
        fail ArgumentError, "Missing the required parameter 'enterprise_id' when calling GoogleEMMApi.enterprises_get_connection_status"
      end
      # resource path
      local_var_path = '/google-emm/enterprises/{enterpriseId}/connection-status'.sub('{' + 'enterpriseId' + '}', enterprise_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmConnectionStatus' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#enterprises_get_connection_status\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Google Enterprises
    # Lists all Google EMM enterprises. An empty list indicates that the Organization is not configured with a Google EMM enterprise yet.    Note: Currently only one Google Enterprise per Organization is supported.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/google-emm/enterprises \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```
    # @param [Hash] opts the optional parameters
    # @option opts [String] :limit The number of records to return at once. Limited to 100. (default to 100)
    # @option opts [String] :skip The offset into the records to return. (default to 0)
    # @return [JumpcloudGoogleEmmListEnterprisesResponse]
    def enterprises_list_enterprises(opts = {})
      data, _status_code, _headers = enterprises_list_enterprises_with_http_info(opts)
      data
    end

    # List Google Enterprises
    # Lists all Google EMM enterprises. An empty list indicates that the Organization is not configured with a Google EMM enterprise yet.    Note: Currently only one Google Enterprise per Organization is supported.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/google-emm/enterprises \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\ &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [String] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :skip The offset into the records to return.
    # @return [Array<(JumpcloudGoogleEmmListEnterprisesResponse, Integer, Hash)>] JumpcloudGoogleEmmListEnterprisesResponse data, response status code and response headers
    def enterprises_list_enterprises_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.enterprises_list_enterprises ...'
      end
      # resource path
      local_var_path = '/google-emm/enterprises'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmListEnterprisesResponse' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#enterprises_list_enterprises\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Update a Google Enterprise
    # Updates a Google EMM enterprise details.  #### Sample Request ``` curl -X PATCH https://console.jumpcloud.com/api/v2/google-emm/enterprises \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{ 'allowDeviceEnrollment': true, 'deviceGroupId': 'string' }' \\ ```
    # @param body 
    # @param enterprise_id 
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGoogleEmmEnterprise]
    def enterprises_patch_enterprise(body, enterprise_id, opts = {})
      data, _status_code, _headers = enterprises_patch_enterprise_with_http_info(body, enterprise_id, opts)
      data
    end

    # Update a Google Enterprise
    # Updates a Google EMM enterprise details.  #### Sample Request &#x60;&#x60;&#x60; curl -X PATCH https://console.jumpcloud.com/api/v2/google-emm/enterprises \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{ &#x27;allowDeviceEnrollment&#x27;: true, &#x27;deviceGroupId&#x27;: &#x27;string&#x27; }&#x27; \\ &#x60;&#x60;&#x60;
    # @param body 
    # @param enterprise_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGoogleEmmEnterprise, Integer, Hash)>] JumpcloudGoogleEmmEnterprise data, response status code and response headers
    def enterprises_patch_enterprise_with_http_info(body, enterprise_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.enterprises_patch_enterprise ...'
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling GoogleEMMApi.enterprises_patch_enterprise"
      end
      # verify the required parameter 'enterprise_id' is set
      if @api_client.config.client_side_validation && enterprise_id.nil?
        fail ArgumentError, "Missing the required parameter 'enterprise_id' when calling GoogleEMMApi.enterprises_patch_enterprise"
      end
      # resource path
      local_var_path = '/google-emm/enterprises/{enterpriseId}'.sub('{' + 'enterpriseId' + '}', enterprise_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(body) 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmEnterprise' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#enterprises_patch_enterprise\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get a Signup URL to enroll Google enterprise
    # Creates a Google EMM enterprise signup URL.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/signup-urls \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGoogleEmmSignupURL]
    def signup_urls_create(opts = {})
      data, _status_code, _headers = signup_urls_create_with_http_info(opts)
      data
    end

    # Get a Signup URL to enroll Google enterprise
    # Creates a Google EMM enterprise signup URL.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/google-emm/signup-urls \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\ &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGoogleEmmSignupURL, Integer, Hash)>] JumpcloudGoogleEmmSignupURL data, response status code and response headers
    def signup_urls_create_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.signup_urls_create ...'
      end
      # resource path
      local_var_path = '/google-emm/signup-urls'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmSignupURL' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#signup_urls_create\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get a web token to render Google Play iFrame
    # Creates a web token to access an embeddable managed Google Play web UI for a given Google EMM enterprise.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/google-emm/web-tokens \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\ ```
    # @param body 
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGoogleEmmWebToken]
    def web_tokens_create_web_token(body, opts = {})
      data, _status_code, _headers = web_tokens_create_web_token_with_http_info(body, opts)
      data
    end

    # Get a web token to render Google Play iFrame
    # Creates a web token to access an embeddable managed Google Play web UI for a given Google EMM enterprise.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/google-emm/web-tokens \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\ &#x60;&#x60;&#x60;
    # @param body 
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGoogleEmmWebToken, Integer, Hash)>] JumpcloudGoogleEmmWebToken data, response status code and response headers
    def web_tokens_create_web_token_with_http_info(body, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GoogleEMMApi.web_tokens_create_web_token ...'
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling GoogleEMMApi.web_tokens_create_web_token"
      end
      # resource path
      local_var_path = '/google-emm/web-tokens'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(body) 

      return_type = opts[:return_type] || 'JumpcloudGoogleEmmWebToken' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GoogleEMMApi#web_tokens_create_web_token\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
