=begin
#JumpCloud API

## Overview  JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.  # Directory Objects  This API offers the ability to interact with some of our core features; otherwise known as Directory Objects. The Directory Objects are:  * Commands * Policies * Policy Groups * Applications * Systems * Users * User Groups * System Groups * Radius Servers * Directories: Office 365, LDAP,G-Suite, Active Directory * Duo accounts and applications.  The Directory Object is an important concept to understand in order to successfully use JumpCloud API.  ## JumpCloud Graph  We've also introduced the concept of the JumpCloud Graph along with  Directory Objects. The Graph is a powerful aspect of our platform which will enable you to associate objects with each other, or establish membership for certain objects to become members of other objects.  Specific `GET` endpoints will allow you to traverse the JumpCloud Graph to return all indirect and directly bound objects in your organization.  | ![alt text](https://s3.amazonaws.com/jumpcloud-kb/Knowledge+Base+Photos/API+Docs/jumpcloud_graph.png \"JumpCloud Graph Model Example\") | |:--:| | **This diagram highlights our association and membership model as it relates to Directory Objects.** |  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/v2/systemgroups\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 2.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.32
=end

module JCAPIv2
  class WorkdayImportApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Authorize Workday
    # This endpoint adds an authorization method to a workday instance.  You must supply a username and password for `Basic Authentication` that is the same as your WorkDay Integrator System User.  Failure to provide these credentials  will result in the request being rejected.  Currently `O-Auth` isn't a supported authentication protocol for WorkDay, but will be in the future.  #### Sample Request  ``` curl -X POST https://console.jumpcloud.com/api/v2/workdays/{WorkDayID}/auth \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{  \"auth\":{    \"basic\": {   \"username\": \"someDeveloper\",      \"password\": \"notTheRealPassword\"     }  } }'  ```
    # @param workday_id 
    # @param [Hash] opts the optional parameters
    # @option opts [AuthInputObject] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def workdays_authorize(workday_id, opts = {})
      workdays_authorize_with_http_info(workday_id, opts)
      nil
    end

    # Authorize Workday
    # This endpoint adds an authorization method to a workday instance.  You must supply a username and password for &#x60;Basic Authentication&#x60; that is the same as your WorkDay Integrator System User.  Failure to provide these credentials  will result in the request being rejected.  Currently &#x60;O-Auth&#x60; isn&#x27;t a supported authentication protocol for WorkDay, but will be in the future.  #### Sample Request  &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/workdays/{WorkDayID}/auth \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{  \&quot;auth\&quot;:{    \&quot;basic\&quot;: {   \&quot;username\&quot;: \&quot;someDeveloper\&quot;,      \&quot;password\&quot;: \&quot;notTheRealPassword\&quot;     }  } }&#x27;  &#x60;&#x60;&#x60;
    # @param workday_id 
    # @param [Hash] opts the optional parameters
    # @option opts [AuthInputObject] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def workdays_authorize_with_http_info(workday_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: WorkdayImportApi.workdays_authorize ...'
      end
      # verify the required parameter 'workday_id' is set
      if @api_client.config.client_side_validation && workday_id.nil?
        fail ArgumentError, "Missing the required parameter 'workday_id' when calling WorkdayImportApi.workdays_authorize"
      end
      # resource path
      local_var_path = '/workdays/{workday_id}/auth'.sub('{' + 'workday_id' + '}', workday_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
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
        @api_client.config.logger.debug "API called: WorkdayImportApi#workdays_authorize\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Deauthorize Workday
    # Removes any and all authorization methods from the workday instance  ##### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/v2/workdays/{WorkDayID}/auth \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param workday_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def workdays_deauthorize(workday_id, opts = {})
      workdays_deauthorize_with_http_info(workday_id, opts)
      nil
    end

    # Deauthorize Workday
    # Removes any and all authorization methods from the workday instance  ##### Sample Request &#x60;&#x60;&#x60; curl -X DELETE https://console.jumpcloud.com/api/v2/workdays/{WorkDayID}/auth \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param workday_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def workdays_deauthorize_with_http_info(workday_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: WorkdayImportApi.workdays_deauthorize ...'
      end
      # verify the required parameter 'workday_id' is set
      if @api_client.config.client_side_validation && workday_id.nil?
        fail ArgumentError, "Missing the required parameter 'workday_id' when calling WorkdayImportApi.workdays_deauthorize"
      end
      # resource path
      local_var_path = '/workdays/{workday_id}/auth'.sub('{' + 'workday_id' + '}', workday_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayImportApi#workdays_deauthorize\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get Workday
    # This endpoint will return  all the available information about an instance of Workday.  #### Sample Request  ``` curl -X GET https://console.jumpcloud.com/api/v2/workdays/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [WorkdayOutput]
    def workdays_get(id, opts = {})
      data, _status_code, _headers = workdays_get_with_http_info(id, opts)
      data
    end

    # Get Workday
    # This endpoint will return  all the available information about an instance of Workday.  #### Sample Request  &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/workdays/ \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;   &#x60;&#x60;&#x60;
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(WorkdayOutput, Integer, Hash)>] WorkdayOutput data, response status code and response headers
    def workdays_get_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: WorkdayImportApi.workdays_get ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling WorkdayImportApi.workdays_get"
      end
      # resource path
      local_var_path = '/workdays/{id}'.sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'WorkdayOutput' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayImportApi#workdays_get\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Workday Import
    # The endpoint allows you to create a Workday Import request.  #### Sample Request  ``` curl -X POST https://console.jumpcloud.com/api/v2/workdays/{WorkdayID}/import \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '[  {   \"email\":\"{email}\",   \"firstname\":\"{firstname}\",   \"lastname\":\"{firstname}\",   \"username\":\"{username}\",   \"attributes\":[    {\"name\":\"EmployeeID\",\"value\":\"0000\"},    {\"name\":\"WorkdayID\",\"value\":\"name.name\"}    ]     } ] ```
    # @param workday_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Array<BulkUserCreate>] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [JobId]
    def workdays_import(workday_id, opts = {})
      data, _status_code, _headers = workdays_import_with_http_info(workday_id, opts)
      data
    end

    # Workday Import
    # The endpoint allows you to create a Workday Import request.  #### Sample Request  &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/workdays/{WorkdayID}/import \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;[  {   \&quot;email\&quot;:\&quot;{email}\&quot;,   \&quot;firstname\&quot;:\&quot;{firstname}\&quot;,   \&quot;lastname\&quot;:\&quot;{firstname}\&quot;,   \&quot;username\&quot;:\&quot;{username}\&quot;,   \&quot;attributes\&quot;:[    {\&quot;name\&quot;:\&quot;EmployeeID\&quot;,\&quot;value\&quot;:\&quot;0000\&quot;},    {\&quot;name\&quot;:\&quot;WorkdayID\&quot;,\&quot;value\&quot;:\&quot;name.name\&quot;}    ]     } ] &#x60;&#x60;&#x60;
    # @param workday_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Array<BulkUserCreate>] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(JobId, Integer, Hash)>] JobId data, response status code and response headers
    def workdays_import_with_http_info(workday_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: WorkdayImportApi.workdays_import ...'
      end
      # verify the required parameter 'workday_id' is set
      if @api_client.config.client_side_validation && workday_id.nil?
        fail ArgumentError, "Missing the required parameter 'workday_id' when calling WorkdayImportApi.workdays_import"
      end
      # resource path
      local_var_path = '/workdays/{workday_id}/import'.sub('{' + 'workday_id' + '}', workday_id.to_s)

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

      return_type = opts[:return_type] || 'JobId' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayImportApi#workdays_import\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Import Results
    # This endpoint provides a list of job results from the workday import and will contain all imported data from Workday.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/workdays/{WorkdayID}/import/{ImportJobID}/results \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param id 
    # @param job_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<JobWorkresult>]
    def workdays_importresults(id, job_id, opts = {})
      data, _status_code, _headers = workdays_importresults_with_http_info(id, job_id, opts)
      data
    end

    # List Import Results
    # This endpoint provides a list of job results from the workday import and will contain all imported data from Workday.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/workdays/{WorkdayID}/import/{ImportJobID}/results \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param id 
    # @param job_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<JobWorkresult>, Integer, Hash)>] Array<JobWorkresult> data, response status code and response headers
    def workdays_importresults_with_http_info(id, job_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: WorkdayImportApi.workdays_importresults ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling WorkdayImportApi.workdays_importresults"
      end
      # verify the required parameter 'job_id' is set
      if @api_client.config.client_side_validation && job_id.nil?
        fail ArgumentError, "Missing the required parameter 'job_id' when calling WorkdayImportApi.workdays_importresults"
      end
      # resource path
      local_var_path = '/workdays/{id}/import/{job_id}/results'.sub('{' + 'id' + '}', id.to_s).sub('{' + 'job_id' + '}', job_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<JobWorkresult>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayImportApi#workdays_importresults\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Workdays
    # This endpoint will return  all the available information about all your instances of Workday.  ##### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/workdays/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<WorkdayOutput>]
    def workdays_list(opts = {})
      data, _status_code, _headers = workdays_list_with_http_info(opts)
      data
    end

    # List Workdays
    # This endpoint will return  all the available information about all your instances of Workday.  ##### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/workdays/ \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;   &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<WorkdayOutput>, Integer, Hash)>] Array<WorkdayOutput> data, response status code and response headers
    def workdays_list_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: WorkdayImportApi.workdays_list ...'
      end
      # resource path
      local_var_path = '/workdays'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fields'] = @api_client.build_collection_param(opts[:'fields'], :csv) if !opts[:'fields'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<WorkdayOutput>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayImportApi#workdays_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create new Workday
    # This endpoint allows you to create a new workday instance.  You must supply a username and password for `Basic Authentication` that is the same as your WorkDay Integrator System User.  Failure to provide these credentials  will result in the request being rejected.  Currently `O-Auth` isn't a supported authentication protocol for WorkDay, but will be in the future.  Currently, only one instance is allowed and it must be `Workday Import`.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/workdays/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"name\": \"Workday2\",     \"reportUrl\":\"https://workday.com/ccx/service/customreport2/gms/user/reportname?format=json\",     \"auth\": {       \"basic\": {         \"username\": \"someDeveloper\",         \"password\": \"notTheRealPassword\"       }     }   }' ```
    # @param [Hash] opts the optional parameters
    # @option opts [WorkdayInput] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [WorkdayOutput]
    def workdays_post(opts = {})
      data, _status_code, _headers = workdays_post_with_http_info(opts)
      data
    end

    # Create new Workday
    # This endpoint allows you to create a new workday instance.  You must supply a username and password for &#x60;Basic Authentication&#x60; that is the same as your WorkDay Integrator System User.  Failure to provide these credentials  will result in the request being rejected.  Currently &#x60;O-Auth&#x60; isn&#x27;t a supported authentication protocol for WorkDay, but will be in the future.  Currently, only one instance is allowed and it must be &#x60;Workday Import&#x60;.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/workdays/ \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;name\&quot;: \&quot;Workday2\&quot;,     \&quot;reportUrl\&quot;:\&quot;https://workday.com/ccx/service/customreport2/gms/user/reportname?format&#x3D;json\&quot;,     \&quot;auth\&quot;: {       \&quot;basic\&quot;: {         \&quot;username\&quot;: \&quot;someDeveloper\&quot;,         \&quot;password\&quot;: \&quot;notTheRealPassword\&quot;       }     }   }&#x27; &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [WorkdayInput] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(WorkdayOutput, Integer, Hash)>] WorkdayOutput data, response status code and response headers
    def workdays_post_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: WorkdayImportApi.workdays_post ...'
      end
      # resource path
      local_var_path = '/workdays'

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

      return_type = opts[:return_type] || 'WorkdayOutput' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayImportApi#workdays_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Update Workday
    # This endpoint allows you to update the name and Custom Report URL for a Workday Instance.  Currently, the name can not be changed from the default of `Workday Import`.  ##### Sample Request ``` curl -X PUT https://console.jumpcloud.com/api/v2/workdays/{WorkdayID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{  \"reportUrl\":\"{Report_URL}\",  \"name\":\"{Name}\" } ' ```
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [WorkdayFields] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [WorkdayOutput]
    def workdays_put(id, opts = {})
      data, _status_code, _headers = workdays_put_with_http_info(id, opts)
      data
    end

    # Update Workday
    # This endpoint allows you to update the name and Custom Report URL for a Workday Instance.  Currently, the name can not be changed from the default of &#x60;Workday Import&#x60;.  ##### Sample Request &#x60;&#x60;&#x60; curl -X PUT https://console.jumpcloud.com/api/v2/workdays/{WorkdayID} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{  \&quot;reportUrl\&quot;:\&quot;{Report_URL}\&quot;,  \&quot;name\&quot;:\&quot;{Name}\&quot; } &#x27; &#x60;&#x60;&#x60;
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [WorkdayFields] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(WorkdayOutput, Integer, Hash)>] WorkdayOutput data, response status code and response headers
    def workdays_put_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: WorkdayImportApi.workdays_put ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling WorkdayImportApi.workdays_put"
      end
      # resource path
      local_var_path = '/workdays/{id}'.sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'WorkdayOutput' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayImportApi#workdays_put\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Workday Workers
    # This endpoint will return all of the data in your WorkDay Custom Report that has been associated with your WorkDay Instance in JumpCloud.  ##### Sample Request  ``` curl -X GET https://console.jumpcloud.com/api/v2/workdays/{WorkDayID}/workers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```
    # @param workday_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<WorkdayWorker>]
    def workdays_workers(workday_id, opts = {})
      data, _status_code, _headers = workdays_workers_with_http_info(workday_id, opts)
      data
    end

    # List Workday Workers
    # This endpoint will return all of the data in your WorkDay Custom Report that has been associated with your WorkDay Instance in JumpCloud.  ##### Sample Request  &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/workdays/{WorkDayID}/workers \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;   &#x60;&#x60;&#x60;
    # @param workday_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<WorkdayWorker>, Integer, Hash)>] Array<WorkdayWorker> data, response status code and response headers
    def workdays_workers_with_http_info(workday_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: WorkdayImportApi.workdays_workers ...'
      end
      # verify the required parameter 'workday_id' is set
      if @api_client.config.client_side_validation && workday_id.nil?
        fail ArgumentError, "Missing the required parameter 'workday_id' when calling WorkdayImportApi.workdays_workers"
      end
      # resource path
      local_var_path = '/workdays/{workday_id}/workers'.sub('{' + 'workday_id' + '}', workday_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<WorkdayWorker>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayImportApi#workdays_workers\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
