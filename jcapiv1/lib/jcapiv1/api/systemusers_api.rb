=begin
#JumpCloud API

## Overview  JumpCloud's V1 API. This set of endpoints allows JumpCloud customers to manage commands, systems, and system users.  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/systemusers\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 1.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.32
=end

module JCAPIv1
  class SystemusersApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Delete a system user's Public SSH Keys
    # This endpoint will delete a specific System User's SSH Key.
    # @param systemuser_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id 
    # @return [String]
    def sshkey_delete(systemuser_id, id, opts = {})
      data, _status_code, _headers = sshkey_delete_with_http_info(systemuser_id, id, opts)
      data
    end

    # Delete a system user&#x27;s Public SSH Keys
    # This endpoint will delete a specific System User&#x27;s SSH Key.
    # @param systemuser_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id 
    # @return [Array<(String, Integer, Hash)>] String data, response status code and response headers
    def sshkey_delete_with_http_info(systemuser_id, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.sshkey_delete ...'
      end
      # verify the required parameter 'systemuser_id' is set
      if @api_client.config.client_side_validation && systemuser_id.nil?
        fail ArgumentError, "Missing the required parameter 'systemuser_id' when calling SystemusersApi.sshkey_delete"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling SystemusersApi.sshkey_delete"
      end
      # resource path
      local_var_path = '/systemusers/{systemuser_id}/sshkeys/{id}'.sub('{' + 'systemuser_id' + '}', systemuser_id.to_s).sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'text/plain'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'String' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemusersApi#sshkey_delete\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List a system user's public SSH keys
    # This endpoint will return a specific System User's public SSH key.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id 
    # @return [Array<Sshkeylist>]
    def sshkey_list(id, opts = {})
      data, _status_code, _headers = sshkey_list_with_http_info(id, opts)
      data
    end

    # List a system user&#x27;s public SSH keys
    # This endpoint will return a specific System User&#x27;s public SSH key.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id 
    # @return [Array<(Array<Sshkeylist>, Integer, Hash)>] Array<Sshkeylist> data, response status code and response headers
    def sshkey_list_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.sshkey_list ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling SystemusersApi.sshkey_list"
      end
      # resource path
      local_var_path = '/systemusers/{id}/sshkeys'.sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'Array<Sshkeylist>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemusersApi#sshkey_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create a system user's Public SSH Key
    # This endpoint will create a specific System User's Public SSH Key.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [Sshkeypost] :body 
    # @option opts [String] :x_org_id 
    # @return [Sshkeylist]
    def sshkey_post(id, opts = {})
      data, _status_code, _headers = sshkey_post_with_http_info(id, opts)
      data
    end

    # Create a system user&#x27;s Public SSH Key
    # This endpoint will create a specific System User&#x27;s Public SSH Key.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [Sshkeypost] :body 
    # @option opts [String] :x_org_id 
    # @return [Array<(Sshkeylist, Integer, Hash)>] Sshkeylist data, response status code and response headers
    def sshkey_post_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.sshkey_post ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling SystemusersApi.sshkey_post"
      end
      # resource path
      local_var_path = '/systemusers/{id}/sshkeys'.sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'Sshkeylist' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemusersApi#sshkey_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete a system user
    # This endpoint allows you to delete a particular system user.  #### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/systemusers/{UserID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id 
    # @option opts [String] :cascade_manager This is an optional flag that can be enabled on the DELETE call, DELETE /systemusers/{id}?cascade_manager&#x3D;null. This parameter will clear the Manager attribute on all direct reports and then delete the account.
    # @return [Systemuserreturn]
    def systemusers_delete(id, opts = {})
      data, _status_code, _headers = systemusers_delete_with_http_info(id, opts)
      data
    end

    # Delete a system user
    # This endpoint allows you to delete a particular system user.  #### Sample Request &#x60;&#x60;&#x60; curl -X DELETE https://console.jumpcloud.com/api/systemusers/{UserID} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id 
    # @option opts [String] :cascade_manager This is an optional flag that can be enabled on the DELETE call, DELETE /systemusers/{id}?cascade_manager&#x3D;null. This parameter will clear the Manager attribute on all direct reports and then delete the account.
    # @return [Array<(Systemuserreturn, Integer, Hash)>] Systemuserreturn data, response status code and response headers
    def systemusers_delete_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.systemusers_delete ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling SystemusersApi.systemusers_delete"
      end
      # resource path
      local_var_path = '/systemusers/{id}'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'cascade_manager'] = opts[:'cascade_manager'] if !opts[:'cascade_manager'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Systemuserreturn' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemusersApi#systemusers_delete\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Expire a system user's password
    # This endpoint allows you to expire a user's password.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id 
    # @return [String]
    def systemusers_expire(id, opts = {})
      data, _status_code, _headers = systemusers_expire_with_http_info(id, opts)
      data
    end

    # Expire a system user&#x27;s password
    # This endpoint allows you to expire a user&#x27;s password.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id 
    # @return [Array<(String, Integer, Hash)>] String data, response status code and response headers
    def systemusers_expire_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.systemusers_expire ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling SystemusersApi.systemusers_expire"
      end
      # resource path
      local_var_path = '/systemusers/{id}/expire'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'text/plain'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'String' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemusersApi#systemusers_expire\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List a system user
    # This endpoint returns a particular System User.  #### Sample Request  ``` curl -X GET https://console.jumpcloud.com/api/systemusers/{UserID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @option opts [String] :x_org_id 
    # @return [Systemuserreturn]
    def systemusers_get(id, opts = {})
      data, _status_code, _headers = systemusers_get_with_http_info(id, opts)
      data
    end

    # List a system user
    # This endpoint returns a particular System User.  #### Sample Request  &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/systemusers/{UserID} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @option opts [String] :x_org_id 
    # @return [Array<(Systemuserreturn, Integer, Hash)>] Systemuserreturn data, response status code and response headers
    def systemusers_get_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.systemusers_get ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling SystemusersApi.systemusers_get"
      end
      # resource path
      local_var_path = '/systemusers/{id}'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fields'] = opts[:'fields'] if !opts[:'fields'].nil?
      query_params[:'filter'] = opts[:'filter'] if !opts[:'filter'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Systemuserreturn' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemusersApi#systemusers_get\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List all system users
    # This endpoint returns all systemusers.  #### Sample Request  ``` curl -X GET https://console.jumpcloud.com/api/systemusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :sort The space separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :fields The space separated fields included in the returned records. If omitted the default list of fields will be returned. 
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @option opts [String] :x_org_id 
    # @option opts [String] :search A nested object containing a &#x60;searchTerm&#x60; string or array of strings and a list of &#x60;fields&#x60; to search on.
    # @return [Systemuserslist]
    def systemusers_list(opts = {})
      data, _status_code, _headers = systemusers_list_with_http_info(opts)
      data
    end

    # List all system users
    # This endpoint returns all systemusers.  #### Sample Request  &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/systemusers \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :sort The space separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :fields The space separated fields included in the returned records. If omitted the default list of fields will be returned. 
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @option opts [String] :x_org_id 
    # @option opts [String] :search A nested object containing a &#x60;searchTerm&#x60; string or array of strings and a list of &#x60;fields&#x60; to search on.
    # @return [Array<(Systemuserslist, Integer, Hash)>] Systemuserslist data, response status code and response headers
    def systemusers_list_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.systemusers_list ...'
      end
      # resource path
      local_var_path = '/systemusers'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = opts[:'sort'] if !opts[:'sort'].nil?
      query_params[:'fields'] = opts[:'fields'] if !opts[:'fields'].nil?
      query_params[:'filter'] = opts[:'filter'] if !opts[:'filter'].nil?
      query_params[:'search'] = opts[:'search'] if !opts[:'search'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Systemuserslist' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemusersApi#systemusers_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Sync a systemuser's mfa enrollment status
    # This endpoint allows you to re-sync a user's mfa enrollment status  #### Sample Request ``` curl -X POST \\   https://console.jumpcloud.com/api/systemusers/{UserID}/mfasync \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\  ```
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def systemusers_mfasync(id, opts = {})
      systemusers_mfasync_with_http_info(id, opts)
      nil
    end

    # Sync a systemuser&#x27;s mfa enrollment status
    # This endpoint allows you to re-sync a user&#x27;s mfa enrollment status  #### Sample Request &#x60;&#x60;&#x60; curl -X POST \\   https://console.jumpcloud.com/api/systemusers/{UserID}/mfasync \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\  &#x60;&#x60;&#x60;
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def systemusers_mfasync_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.systemusers_mfasync ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling SystemusersApi.systemusers_mfasync"
      end
      # resource path
      local_var_path = '/systemusers/{id}/mfasync'.sub('{' + 'id' + '}', id.to_s)

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
        @api_client.config.logger.debug "API called: SystemusersApi#systemusers_mfasync\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create a system user
    # \"This endpoint allows you to create a new system user.  #### Default User State The `state` of the user can be explicitly passed in or omitted. If `state` is omitted from the request, then the user will get created using the value returned from the [Get an Organization](https://docs.jumpcloud.com/api/1.0/index.html#operation/organizations_get) endpoint. The default user state for manually created users is stored in `settings.newSystemUserStateDefaults.manualEntry`  These default state values can be changed in the admin portal settings or by using the [Update an Organization](https://docs.jumpcloud.com/api/1.0/index.html#operation/organization_put) endpoint.  #### Sample Request  ``` curl -X POST https://console.jumpcloud.com/api/systemusers \\ -H 'Accept: application/json' \\ -H 'Content-Type: application/json' \\ -H 'x-api-key: {API_KEY}' \\ -d '{       \"username\":\"{username}\",       \"email\":\"{email_address}\",       \"firstname\":\"{Name}\",       \"lastname\":\"{Name}\"     }' ```
    # @param [Hash] opts the optional parameters
    # @option opts [Systemuserputpost] :body 
    # @option opts [String] :x_org_id 
    # @option opts [String] :full_validation_details Pass this query parameter when a client wants all validation errors to be returned with a detailed error response for the form field specified. The current form fields are allowed:  * &#x60;password&#x60;  #### Password validation flag Use the &#x60;password&#x60; validation flag to receive details on a possible bad request response &#x60;&#x60;&#x60; ?fullValidationDetails&#x3D;password &#x60;&#x60;&#x60; Without the flag, default behavior will be a normal 400 with only a single validation string error #### Expected Behavior Clients can expect a list of validation error mappings for the validation query field in the details provided on the response: &#x60;&#x60;&#x60; {   \&quot;code\&quot;: 400,   \&quot;message\&quot;: \&quot;Password validation fail\&quot;,   \&quot;status\&quot;: \&quot;INVALID_ARGUMENT\&quot;,   \&quot;details\&quot;: [       {         \&quot;fieldViolationsList\&quot;: [           {\&quot;field\&quot;: \&quot;password\&quot;, \&quot;description\&quot;: \&quot;specialCharacter\&quot;}         ],         &#x27;@type&#x27;: &#x27;type.googleapis.com/google.rpc.BadRequest&#x27;,       },   ], }, &#x60;&#x60;&#x60;
    # @return [Systemuserreturn]
    def systemusers_post(opts = {})
      data, _status_code, _headers = systemusers_post_with_http_info(opts)
      data
    end

    # Create a system user
    # \&quot;This endpoint allows you to create a new system user.  #### Default User State The &#x60;state&#x60; of the user can be explicitly passed in or omitted. If &#x60;state&#x60; is omitted from the request, then the user will get created using the value returned from the [Get an Organization](https://docs.jumpcloud.com/api/1.0/index.html#operation/organizations_get) endpoint. The default user state for manually created users is stored in &#x60;settings.newSystemUserStateDefaults.manualEntry&#x60;  These default state values can be changed in the admin portal settings or by using the [Update an Organization](https://docs.jumpcloud.com/api/1.0/index.html#operation/organization_put) endpoint.  #### Sample Request  &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/systemusers \\ -H &#x27;Accept: application/json&#x27; \\ -H &#x27;Content-Type: application/json&#x27; \\ -H &#x27;x-api-key: {API_KEY}&#x27; \\ -d &#x27;{       \&quot;username\&quot;:\&quot;{username}\&quot;,       \&quot;email\&quot;:\&quot;{email_address}\&quot;,       \&quot;firstname\&quot;:\&quot;{Name}\&quot;,       \&quot;lastname\&quot;:\&quot;{Name}\&quot;     }&#x27; &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [Systemuserputpost] :body 
    # @option opts [String] :x_org_id 
    # @option opts [String] :full_validation_details Pass this query parameter when a client wants all validation errors to be returned with a detailed error response for the form field specified. The current form fields are allowed:  * &#x60;password&#x60;  #### Password validation flag Use the &#x60;password&#x60; validation flag to receive details on a possible bad request response &#x60;&#x60;&#x60; ?fullValidationDetails&#x3D;password &#x60;&#x60;&#x60; Without the flag, default behavior will be a normal 400 with only a single validation string error #### Expected Behavior Clients can expect a list of validation error mappings for the validation query field in the details provided on the response: &#x60;&#x60;&#x60; {   \&quot;code\&quot;: 400,   \&quot;message\&quot;: \&quot;Password validation fail\&quot;,   \&quot;status\&quot;: \&quot;INVALID_ARGUMENT\&quot;,   \&quot;details\&quot;: [       {         \&quot;fieldViolationsList\&quot;: [           {\&quot;field\&quot;: \&quot;password\&quot;, \&quot;description\&quot;: \&quot;specialCharacter\&quot;}         ],         &#x27;@type&#x27;: &#x27;type.googleapis.com/google.rpc.BadRequest&#x27;,       },   ], }, &#x60;&#x60;&#x60;
    # @return [Array<(Systemuserreturn, Integer, Hash)>] Systemuserreturn data, response status code and response headers
    def systemusers_post_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.systemusers_post ...'
      end
      # resource path
      local_var_path = '/systemusers'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fullValidationDetails'] = opts[:'full_validation_details'] if !opts[:'full_validation_details'].nil?

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

      return_type = opts[:return_type] || 'Systemuserreturn' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemusersApi#systemusers_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Update a system user
    # This endpoint allows you to update a system user.  #### Sample Request  ``` curl -X PUT https://console.jumpcloud.com/api/systemusers/{UserID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{  \"email\":\"{email_address}\",  \"firstname\":\"{Name}\",  \"lastname\":\"{Name}\" }' ```
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [Systemuserput] :body 
    # @option opts [String] :x_org_id 
    # @option opts [String] :full_validation_details This endpoint can take in a query when a client wants all validation errors to be returned with error response for the form field specified, i.e. &#x27;password&#x27; #### Password validation flag Use the \&quot;password\&quot; validation flag to receive details on a possible bad request response Without the &#x60;password&#x60; flag, default behavior will be a normal 400 with only a validation string message &#x60;&#x60;&#x60; ?fullValidationDetails&#x3D;password &#x60;&#x60;&#x60; #### Expected Behavior Clients can expect a list of validation error mappings for the validation query field in the details provided on the response: &#x60;&#x60;&#x60; {   \&quot;code\&quot;: 400,   \&quot;message\&quot;: \&quot;Password validation fail\&quot;,   \&quot;status\&quot;: \&quot;INVALID_ARGUMENT\&quot;,   \&quot;details\&quot;: [       {         \&quot;fieldViolationsList\&quot;: [{ \&quot;field\&quot;: \&quot;password\&quot;, \&quot;description\&quot;: \&quot;passwordHistory\&quot; }],         &#x27;@type&#x27;: &#x27;type.googleapis.com/google.rpc.BadRequest&#x27;,       },   ], }, &#x60;&#x60;&#x60;
    # @return [Systemuserreturn]
    def systemusers_put(id, opts = {})
      data, _status_code, _headers = systemusers_put_with_http_info(id, opts)
      data
    end

    # Update a system user
    # This endpoint allows you to update a system user.  #### Sample Request  &#x60;&#x60;&#x60; curl -X PUT https://console.jumpcloud.com/api/systemusers/{UserID} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{  \&quot;email\&quot;:\&quot;{email_address}\&quot;,  \&quot;firstname\&quot;:\&quot;{Name}\&quot;,  \&quot;lastname\&quot;:\&quot;{Name}\&quot; }&#x27; &#x60;&#x60;&#x60;
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [Systemuserput] :body 
    # @option opts [String] :x_org_id 
    # @option opts [String] :full_validation_details This endpoint can take in a query when a client wants all validation errors to be returned with error response for the form field specified, i.e. &#x27;password&#x27; #### Password validation flag Use the \&quot;password\&quot; validation flag to receive details on a possible bad request response Without the &#x60;password&#x60; flag, default behavior will be a normal 400 with only a validation string message &#x60;&#x60;&#x60; ?fullValidationDetails&#x3D;password &#x60;&#x60;&#x60; #### Expected Behavior Clients can expect a list of validation error mappings for the validation query field in the details provided on the response: &#x60;&#x60;&#x60; {   \&quot;code\&quot;: 400,   \&quot;message\&quot;: \&quot;Password validation fail\&quot;,   \&quot;status\&quot;: \&quot;INVALID_ARGUMENT\&quot;,   \&quot;details\&quot;: [       {         \&quot;fieldViolationsList\&quot;: [{ \&quot;field\&quot;: \&quot;password\&quot;, \&quot;description\&quot;: \&quot;passwordHistory\&quot; }],         &#x27;@type&#x27;: &#x27;type.googleapis.com/google.rpc.BadRequest&#x27;,       },   ], }, &#x60;&#x60;&#x60;
    # @return [Array<(Systemuserreturn, Integer, Hash)>] Systemuserreturn data, response status code and response headers
    def systemusers_put_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.systemusers_put ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling SystemusersApi.systemusers_put"
      end
      # resource path
      local_var_path = '/systemusers/{id}'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fullValidationDetails'] = opts[:'full_validation_details'] if !opts[:'full_validation_details'].nil?

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

      return_type = opts[:return_type] || 'Systemuserreturn' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemusersApi#systemusers_put\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Reset a system user's MFA token
    # This endpoint allows you to reset the TOTP key for a specified system user and put them in an TOTP MFA enrollment period. This will result in the user being prompted to setup TOTP MFA when logging into userportal. Please be aware that if the user does not complete TOTP MFA setup before the `exclusionUntil` date, they will be locked out of any resources that require TOTP MFA.  Please refer to our [Knowledge Base Article](https://support.jumpcloud.com/customer/en/portal/articles/2959138-using-multifactor-authentication-with-jumpcloud) on setting up MFA for more information.  #### Sample Request ``` curl -X POST \\   https://console.jumpcloud.com/api/systemusers/{UserID}/resetmfa \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{\"exclusion\": true, \"exclusionUntil\": \"{date-time}\"}'  ```
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [IdResetmfaBody] :body 
    # @option opts [String] :x_org_id 
    # @return [String]
    def systemusers_resetmfa(id, opts = {})
      data, _status_code, _headers = systemusers_resetmfa_with_http_info(id, opts)
      data
    end

    # Reset a system user&#x27;s MFA token
    # This endpoint allows you to reset the TOTP key for a specified system user and put them in an TOTP MFA enrollment period. This will result in the user being prompted to setup TOTP MFA when logging into userportal. Please be aware that if the user does not complete TOTP MFA setup before the &#x60;exclusionUntil&#x60; date, they will be locked out of any resources that require TOTP MFA.  Please refer to our [Knowledge Base Article](https://support.jumpcloud.com/customer/en/portal/articles/2959138-using-multifactor-authentication-with-jumpcloud) on setting up MFA for more information.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST \\   https://console.jumpcloud.com/api/systemusers/{UserID}/resetmfa \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{\&quot;exclusion\&quot;: true, \&quot;exclusionUntil\&quot;: \&quot;{date-time}\&quot;}&#x27;  &#x60;&#x60;&#x60;
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [IdResetmfaBody] :body 
    # @option opts [String] :x_org_id 
    # @return [Array<(String, Integer, Hash)>] String data, response status code and response headers
    def systemusers_resetmfa_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.systemusers_resetmfa ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling SystemusersApi.systemusers_resetmfa"
      end
      # resource path
      local_var_path = '/systemusers/{id}/resetmfa'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'text/plain'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(opts[:'body']) 

      return_type = opts[:return_type] || 'String' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemusersApi#systemusers_resetmfa\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Activate System User
    # This endpoint changes the state of a STAGED user to ACTIVATED. #### Email Flag Use the \"email\" flag to determine whether or not to send a Welcome or Activation email to the newly activated user. Sending an empty body without the `email` flag, will send an email with default behavior (see the \"Behavior\" section below) ``` {} ``` Sending `email=true` flag will send an email with default behavior (see `Behavior` below) ``` { \"email\": true } ``` Populated email will override the default behavior and send to the specified email value ``` { \"email\": \"example@example.com\" } ``` Sending `email=false` will suppress sending the email ``` { \"email\": false } ``` #### Behavior Users with a password will be sent a Welcome email to:   - The address specified in `email` flag in the request   - If no `email` flag, the user's primary email address (default behavior) Users without a password will be sent an Activation email to:   - The address specified in `email` flag in the request   - If no `email` flag, the user's alternate email address (default behavior)   - If no alternate email address, the user's primary email address (default behavior)  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/systemusers/{id}/state/activate \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: <api-key>' \\   -d '{ \"email\": \"alternate-activation-email@email.com\" }'  ```
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [StateActivateBody] :body 
    # @return [String]
    def systemusers_state_activate(id, opts = {})
      data, _status_code, _headers = systemusers_state_activate_with_http_info(id, opts)
      data
    end

    # Activate System User
    # This endpoint changes the state of a STAGED user to ACTIVATED. #### Email Flag Use the \&quot;email\&quot; flag to determine whether or not to send a Welcome or Activation email to the newly activated user. Sending an empty body without the &#x60;email&#x60; flag, will send an email with default behavior (see the \&quot;Behavior\&quot; section below) &#x60;&#x60;&#x60; {} &#x60;&#x60;&#x60; Sending &#x60;email&#x3D;true&#x60; flag will send an email with default behavior (see &#x60;Behavior&#x60; below) &#x60;&#x60;&#x60; { \&quot;email\&quot;: true } &#x60;&#x60;&#x60; Populated email will override the default behavior and send to the specified email value &#x60;&#x60;&#x60; { \&quot;email\&quot;: \&quot;example@example.com\&quot; } &#x60;&#x60;&#x60; Sending &#x60;email&#x3D;false&#x60; will suppress sending the email &#x60;&#x60;&#x60; { \&quot;email\&quot;: false } &#x60;&#x60;&#x60; #### Behavior Users with a password will be sent a Welcome email to:   - The address specified in &#x60;email&#x60; flag in the request   - If no &#x60;email&#x60; flag, the user&#x27;s primary email address (default behavior) Users without a password will be sent an Activation email to:   - The address specified in &#x60;email&#x60; flag in the request   - If no &#x60;email&#x60; flag, the user&#x27;s alternate email address (default behavior)   - If no alternate email address, the user&#x27;s primary email address (default behavior)  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/systemusers/{id}/state/activate \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: &lt;api-key&gt;&#x27; \\   -d &#x27;{ \&quot;email\&quot;: \&quot;alternate-activation-email@email.com\&quot; }&#x27;  &#x60;&#x60;&#x60;
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [StateActivateBody] :body 
    # @return [Array<(String, Integer, Hash)>] String data, response status code and response headers
    def systemusers_state_activate_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.systemusers_state_activate ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling SystemusersApi.systemusers_state_activate"
      end
      # resource path
      local_var_path = '/systemusers/{id}/state/activate'.sub('{' + 'id' + '}', id.to_s)

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
      post_body = opts[:body] || @api_client.object_to_http_body(opts[:'body']) 

      return_type = opts[:return_type] || 'String' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemusersApi#systemusers_state_activate\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Unlock a system user
    # This endpoint allows you to unlock a user's account.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id 
    # @return [String]
    def systemusers_unlock(id, opts = {})
      data, _status_code, _headers = systemusers_unlock_with_http_info(id, opts)
      data
    end

    # Unlock a system user
    # This endpoint allows you to unlock a user&#x27;s account.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id 
    # @return [Array<(String, Integer, Hash)>] String data, response status code and response headers
    def systemusers_unlock_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemusersApi.systemusers_unlock ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling SystemusersApi.systemusers_unlock"
      end
      # resource path
      local_var_path = '/systemusers/{id}/unlock'.sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'text/plain'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'String' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemusersApi#systemusers_unlock\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
