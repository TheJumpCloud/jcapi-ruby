=begin
#JumpCloud API

## Overview  JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.  ## API Best Practices  Read the linked Help Article below for guidance on retrying failed requests to JumpCloud's REST API, as well as best practices for structuring subsequent retry requests. Customizing retry mechanisms based on these recommendations will increase the reliability and dependability of your API calls.  Covered topics include: 1. Important Considerations 2. Supported HTTP Request Methods 3. Response codes 4. API Key rotation 5. Paginating 6. Error handling 7. Retry rates  [JumpCloud Help Center - API Best Practices](https://support.jumpcloud.com/support/s/article/JumpCloud-API-Best-Practices)  # Directory Objects  This API offers the ability to interact with some of our core features; otherwise known as Directory Objects. The Directory Objects are:  * Commands * Policies * Policy Groups * Applications * Systems * Users * User Groups * System Groups * Radius Servers * Directories: Office 365, LDAP,G-Suite, Active Directory * Duo accounts and applications.  The Directory Object is an important concept to understand in order to successfully use JumpCloud API.  ## JumpCloud Graph  We've also introduced the concept of the JumpCloud Graph along with  Directory Objects. The Graph is a powerful aspect of our platform which will enable you to associate objects with each other, or establish membership for certain objects to become members of other objects.  Specific `GET` endpoints will allow you to traverse the JumpCloud Graph to return all indirect and directly bound objects in your organization.  | ![alt text](https://s3.amazonaws.com/jumpcloud-kb/Knowledge+Base+Photos/API+Docs/jumpcloud_graph.png \"JumpCloud Graph Model Example\") | |:--:| | **This diagram highlights our association and membership model as it relates to Directory Objects.** |  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/v2/systemgroups\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 2.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.47
=end

module JCAPIv2
  class SystemInsightsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # List System Insights ALF
    # Valid filter fields are `system_id` and `global_state`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsAlf>]
    def systeminsights_list_alf(opts = {})
      data, _status_code, _headers = systeminsights_list_alf_with_http_info(opts)
      data
    end

    # List System Insights ALF
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;global_state&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsAlf>, Integer, Hash)>] Array<SystemInsightsAlf> data, response status code and response headers
    def systeminsights_list_alf_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_alf ...'
      end
      # resource path
      local_var_path = '/systeminsights/alf'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsAlf>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_alf\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights ALF Exceptions
    # Valid filter fields are `system_id` and `state`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsAlfExceptions>]
    def systeminsights_list_alf_exceptions(opts = {})
      data, _status_code, _headers = systeminsights_list_alf_exceptions_with_http_info(opts)
      data
    end

    # List System Insights ALF Exceptions
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;state&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsAlfExceptions>, Integer, Hash)>] Array<SystemInsightsAlfExceptions> data, response status code and response headers
    def systeminsights_list_alf_exceptions_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_alf_exceptions ...'
      end
      # resource path
      local_var_path = '/systeminsights/alf_exceptions'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsAlfExceptions>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_alf_exceptions\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights ALF Explicit Authentications
    # Valid filter fields are `system_id` and `process`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsAlfExplicitAuths>]
    def systeminsights_list_alf_explicit_auths(opts = {})
      data, _status_code, _headers = systeminsights_list_alf_explicit_auths_with_http_info(opts)
      data
    end

    # List System Insights ALF Explicit Authentications
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;process&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsAlfExplicitAuths>, Integer, Hash)>] Array<SystemInsightsAlfExplicitAuths> data, response status code and response headers
    def systeminsights_list_alf_explicit_auths_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_alf_explicit_auths ...'
      end
      # resource path
      local_var_path = '/systeminsights/alf_explicit_auths'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsAlfExplicitAuths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_alf_explicit_auths\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Application Compatibility Shims
    # Valid filter fields are `system_id` and `enabled`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsAppcompatShims>]
    def systeminsights_list_appcompat_shims(opts = {})
      data, _status_code, _headers = systeminsights_list_appcompat_shims_with_http_info(opts)
      data
    end

    # List System Insights Application Compatibility Shims
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;enabled&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsAppcompatShims>, Integer, Hash)>] Array<SystemInsightsAppcompatShims> data, response status code and response headers
    def systeminsights_list_appcompat_shims_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_appcompat_shims ...'
      end
      # resource path
      local_var_path = '/systeminsights/appcompat_shims'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsAppcompatShims>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_appcompat_shims\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Apps
    # Lists all apps for macOS devices. For Windows devices, use [List System Insights Programs](#operation/systeminsights_list_programs).  Valid filter fields are `system_id` and `bundle_name`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsApps>]
    def systeminsights_list_apps(opts = {})
      data, _status_code, _headers = systeminsights_list_apps_with_http_info(opts)
      data
    end

    # List System Insights Apps
    # Lists all apps for macOS devices. For Windows devices, use [List System Insights Programs](#operation/systeminsights_list_programs).  Valid filter fields are &#x60;system_id&#x60; and &#x60;bundle_name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsApps>, Integer, Hash)>] Array<SystemInsightsApps> data, response status code and response headers
    def systeminsights_list_apps_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_apps ...'
      end
      # resource path
      local_var_path = '/systeminsights/apps'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsApps>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_apps\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Authorized Keys
    # Valid filter fields are `system_id` and `uid`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsAuthorizedKeys>]
    def systeminsights_list_authorized_keys(opts = {})
      data, _status_code, _headers = systeminsights_list_authorized_keys_with_http_info(opts)
      data
    end

    # List System Insights Authorized Keys
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;uid&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsAuthorizedKeys>, Integer, Hash)>] Array<SystemInsightsAuthorizedKeys> data, response status code and response headers
    def systeminsights_list_authorized_keys_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_authorized_keys ...'
      end
      # resource path
      local_var_path = '/systeminsights/authorized_keys'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsAuthorizedKeys>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_authorized_keys\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Azure Instance Metadata
    # Valid filter fields are `system_id`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsAzureInstanceMetadata>]
    def systeminsights_list_azure_instance_metadata(opts = {})
      data, _status_code, _headers = systeminsights_list_azure_instance_metadata_with_http_info(opts)
      data
    end

    # List System Insights Azure Instance Metadata
    # Valid filter fields are &#x60;system_id&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsAzureInstanceMetadata>, Integer, Hash)>] Array<SystemInsightsAzureInstanceMetadata> data, response status code and response headers
    def systeminsights_list_azure_instance_metadata_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_azure_instance_metadata ...'
      end
      # resource path
      local_var_path = '/systeminsights/azure_instance_metadata'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsAzureInstanceMetadata>' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_azure_instance_metadata\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Azure Instance Tags
    # Valid filter fields are `system_id`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsAzureInstanceTags>]
    def systeminsights_list_azure_instance_tags(opts = {})
      data, _status_code, _headers = systeminsights_list_azure_instance_tags_with_http_info(opts)
      data
    end

    # List System Insights Azure Instance Tags
    # Valid filter fields are &#x60;system_id&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsAzureInstanceTags>, Integer, Hash)>] Array<SystemInsightsAzureInstanceTags> data, response status code and response headers
    def systeminsights_list_azure_instance_tags_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_azure_instance_tags ...'
      end
      # resource path
      local_var_path = '/systeminsights/azure_instance_tags'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsAzureInstanceTags>' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_azure_instance_tags\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Battery
    # Valid filter fields are `system_id` and `health`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsBattery>]
    def systeminsights_list_battery(opts = {})
      data, _status_code, _headers = systeminsights_list_battery_with_http_info(opts)
      data
    end

    # List System Insights Battery
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;health&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsBattery>, Integer, Hash)>] Array<SystemInsightsBattery> data, response status code and response headers
    def systeminsights_list_battery_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_battery ...'
      end
      # resource path
      local_var_path = '/systeminsights/battery'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsBattery>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_battery\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Bitlocker Info
    # Valid filter fields are `system_id` and `protection_status`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsBitlockerInfo>]
    def systeminsights_list_bitlocker_info(opts = {})
      data, _status_code, _headers = systeminsights_list_bitlocker_info_with_http_info(opts)
      data
    end

    # List System Insights Bitlocker Info
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;protection_status&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsBitlockerInfo>, Integer, Hash)>] Array<SystemInsightsBitlockerInfo> data, response status code and response headers
    def systeminsights_list_bitlocker_info_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_bitlocker_info ...'
      end
      # resource path
      local_var_path = '/systeminsights/bitlocker_info'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsBitlockerInfo>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_bitlocker_info\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Browser Plugins
    # Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsBrowserPlugins>]
    def systeminsights_list_browser_plugins(opts = {})
      data, _status_code, _headers = systeminsights_list_browser_plugins_with_http_info(opts)
      data
    end

    # List System Insights Browser Plugins
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsBrowserPlugins>, Integer, Hash)>] Array<SystemInsightsBrowserPlugins> data, response status code and response headers
    def systeminsights_list_browser_plugins_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_browser_plugins ...'
      end
      # resource path
      local_var_path = '/systeminsights/browser_plugins'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsBrowserPlugins>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_browser_plugins\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Certificates
    # Valid filter fields are `system_id` and `common_name`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; Note: You can only filter by &#x60;system_id&#x60; and &#x60;common_name&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsCertificates>]
    def systeminsights_list_certificates(opts = {})
      data, _status_code, _headers = systeminsights_list_certificates_with_http_info(opts)
      data
    end

    # List System Insights Certificates
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;common_name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; Note: You can only filter by &#x60;system_id&#x60; and &#x60;common_name&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsCertificates>, Integer, Hash)>] Array<SystemInsightsCertificates> data, response status code and response headers
    def systeminsights_list_certificates_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_certificates ...'
      end
      # resource path
      local_var_path = '/systeminsights/certificates'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsCertificates>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_certificates\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Chassis Info
    # Valid filter fields are `system_id`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsChassisInfo>]
    def systeminsights_list_chassis_info(opts = {})
      data, _status_code, _headers = systeminsights_list_chassis_info_with_http_info(opts)
      data
    end

    # List System Insights Chassis Info
    # Valid filter fields are &#x60;system_id&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsChassisInfo>, Integer, Hash)>] Array<SystemInsightsChassisInfo> data, response status code and response headers
    def systeminsights_list_chassis_info_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_chassis_info ...'
      end
      # resource path
      local_var_path = '/systeminsights/chassis_info'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsChassisInfo>' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_chassis_info\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Chrome Extensions
    # Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsChromeExtensions>]
    def systeminsights_list_chrome_extensions(opts = {})
      data, _status_code, _headers = systeminsights_list_chrome_extensions_with_http_info(opts)
      data
    end

    # List System Insights Chrome Extensions
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsChromeExtensions>, Integer, Hash)>] Array<SystemInsightsChromeExtensions> data, response status code and response headers
    def systeminsights_list_chrome_extensions_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_chrome_extensions ...'
      end
      # resource path
      local_var_path = '/systeminsights/chrome_extensions'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsChromeExtensions>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_chrome_extensions\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Connectivity
    # The only valid filter field is `system_id`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsConnectivity>]
    def systeminsights_list_connectivity(opts = {})
      data, _status_code, _headers = systeminsights_list_connectivity_with_http_info(opts)
      data
    end

    # List System Insights Connectivity
    # The only valid filter field is &#x60;system_id&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsConnectivity>, Integer, Hash)>] Array<SystemInsightsConnectivity> data, response status code and response headers
    def systeminsights_list_connectivity_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_connectivity ...'
      end
      # resource path
      local_var_path = '/systeminsights/connectivity'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsConnectivity>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_connectivity\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Crashes
    # Valid filter fields are `system_id` and `identifier`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsCrashes>]
    def systeminsights_list_crashes(opts = {})
      data, _status_code, _headers = systeminsights_list_crashes_with_http_info(opts)
      data
    end

    # List System Insights Crashes
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;identifier&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsCrashes>, Integer, Hash)>] Array<SystemInsightsCrashes> data, response status code and response headers
    def systeminsights_list_crashes_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_crashes ...'
      end
      # resource path
      local_var_path = '/systeminsights/crashes'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsCrashes>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_crashes\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights CUPS Destinations
    # Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsCupsDestinations>]
    def systeminsights_list_cups_destinations(opts = {})
      data, _status_code, _headers = systeminsights_list_cups_destinations_with_http_info(opts)
      data
    end

    # List System Insights CUPS Destinations
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsCupsDestinations>, Integer, Hash)>] Array<SystemInsightsCupsDestinations> data, response status code and response headers
    def systeminsights_list_cups_destinations_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_cups_destinations ...'
      end
      # resource path
      local_var_path = '/systeminsights/cups_destinations'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsCupsDestinations>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_cups_destinations\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Disk Encryption
    # Valid filter fields are `system_id` and `encryption_status`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsDiskEncryption>]
    def systeminsights_list_disk_encryption(opts = {})
      data, _status_code, _headers = systeminsights_list_disk_encryption_with_http_info(opts)
      data
    end

    # List System Insights Disk Encryption
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;encryption_status&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsDiskEncryption>, Integer, Hash)>] Array<SystemInsightsDiskEncryption> data, response status code and response headers
    def systeminsights_list_disk_encryption_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_disk_encryption ...'
      end
      # resource path
      local_var_path = '/systeminsights/disk_encryption'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsDiskEncryption>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_disk_encryption\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Disk Info
    # Valid filter fields are `system_id` and `disk_index`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsDiskInfo>]
    def systeminsights_list_disk_info(opts = {})
      data, _status_code, _headers = systeminsights_list_disk_info_with_http_info(opts)
      data
    end

    # List System Insights Disk Info
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;disk_index&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsDiskInfo>, Integer, Hash)>] Array<SystemInsightsDiskInfo> data, response status code and response headers
    def systeminsights_list_disk_info_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_disk_info ...'
      end
      # resource path
      local_var_path = '/systeminsights/disk_info'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsDiskInfo>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_disk_info\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights DNS Resolvers
    # Valid filter fields are `system_id` and `type`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsDnsResolvers>]
    def systeminsights_list_dns_resolvers(opts = {})
      data, _status_code, _headers = systeminsights_list_dns_resolvers_with_http_info(opts)
      data
    end

    # List System Insights DNS Resolvers
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;type&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsDnsResolvers>, Integer, Hash)>] Array<SystemInsightsDnsResolvers> data, response status code and response headers
    def systeminsights_list_dns_resolvers_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_dns_resolvers ...'
      end
      # resource path
      local_var_path = '/systeminsights/dns_resolvers'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsDnsResolvers>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_dns_resolvers\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Etc Hosts
    # Valid filter fields are `system_id` and `address`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsEtcHosts>]
    def systeminsights_list_etc_hosts(opts = {})
      data, _status_code, _headers = systeminsights_list_etc_hosts_with_http_info(opts)
      data
    end

    # List System Insights Etc Hosts
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;address&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsEtcHosts>, Integer, Hash)>] Array<SystemInsightsEtcHosts> data, response status code and response headers
    def systeminsights_list_etc_hosts_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_etc_hosts ...'
      end
      # resource path
      local_var_path = '/systeminsights/etc_hosts'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsEtcHosts>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_etc_hosts\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Firefox Addons
    # Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsFirefoxAddons>]
    def systeminsights_list_firefox_addons(opts = {})
      data, _status_code, _headers = systeminsights_list_firefox_addons_with_http_info(opts)
      data
    end

    # List System Insights Firefox Addons
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsFirefoxAddons>, Integer, Hash)>] Array<SystemInsightsFirefoxAddons> data, response status code and response headers
    def systeminsights_list_firefox_addons_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_firefox_addons ...'
      end
      # resource path
      local_var_path = '/systeminsights/firefox_addons'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsFirefoxAddons>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_firefox_addons\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Groups
    # Valid filter fields are `system_id` and `groupname`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsGroups>]
    def systeminsights_list_groups(opts = {})
      data, _status_code, _headers = systeminsights_list_groups_with_http_info(opts)
      data
    end

    # List System Insights Groups
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;groupname&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsGroups>, Integer, Hash)>] Array<SystemInsightsGroups> data, response status code and response headers
    def systeminsights_list_groups_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_groups ...'
      end
      # resource path
      local_var_path = '/systeminsights/groups'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsGroups>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_groups\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights IE Extensions
    # Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsIeExtensions>]
    def systeminsights_list_ie_extensions(opts = {})
      data, _status_code, _headers = systeminsights_list_ie_extensions_with_http_info(opts)
      data
    end

    # List System Insights IE Extensions
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsIeExtensions>, Integer, Hash)>] Array<SystemInsightsIeExtensions> data, response status code and response headers
    def systeminsights_list_ie_extensions_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_ie_extensions ...'
      end
      # resource path
      local_var_path = '/systeminsights/ie_extensions'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsIeExtensions>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_ie_extensions\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Interface Addresses
    # Valid filter fields are `system_id` and `address`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsInterfaceAddresses>]
    def systeminsights_list_interface_addresses(opts = {})
      data, _status_code, _headers = systeminsights_list_interface_addresses_with_http_info(opts)
      data
    end

    # List System Insights Interface Addresses
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;address&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsInterfaceAddresses>, Integer, Hash)>] Array<SystemInsightsInterfaceAddresses> data, response status code and response headers
    def systeminsights_list_interface_addresses_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_interface_addresses ...'
      end
      # resource path
      local_var_path = '/systeminsights/interface_addresses'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsInterfaceAddresses>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_interface_addresses\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Interface Details
    # Valid filter fields are `system_id` and `interface`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsInterfaceDetails>]
    def systeminsights_list_interface_details(opts = {})
      data, _status_code, _headers = systeminsights_list_interface_details_with_http_info(opts)
      data
    end

    # List System Insights Interface Details
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;interface&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsInterfaceDetails>, Integer, Hash)>] Array<SystemInsightsInterfaceDetails> data, response status code and response headers
    def systeminsights_list_interface_details_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_interface_details ...'
      end
      # resource path
      local_var_path = '/systeminsights/interface_details'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsInterfaceDetails>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_interface_details\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Kernel Info
    # Valid filter fields are `system_id` and `version`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsKernelInfo>]
    def systeminsights_list_kernel_info(opts = {})
      data, _status_code, _headers = systeminsights_list_kernel_info_with_http_info(opts)
      data
    end

    # List System Insights Kernel Info
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;version&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsKernelInfo>, Integer, Hash)>] Array<SystemInsightsKernelInfo> data, response status code and response headers
    def systeminsights_list_kernel_info_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_kernel_info ...'
      end
      # resource path
      local_var_path = '/systeminsights/kernel_info'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsKernelInfo>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_kernel_info\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Launchd
    # Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsLaunchd>]
    def systeminsights_list_launchd(opts = {})
      data, _status_code, _headers = systeminsights_list_launchd_with_http_info(opts)
      data
    end

    # List System Insights Launchd
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsLaunchd>, Integer, Hash)>] Array<SystemInsightsLaunchd> data, response status code and response headers
    def systeminsights_list_launchd_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_launchd ...'
      end
      # resource path
      local_var_path = '/systeminsights/launchd'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsLaunchd>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_launchd\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Linux Packages
    # Lists all programs for Linux devices. For macOS devices, use [List System Insights System Apps](#operation/systeminsights_list_apps). For windows devices, use [List System Insights System Apps](#operation/systeminsights_list_programs).  Valid filter fields are `name` and `package_format`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsLinuxPackages>]
    def systeminsights_list_linux_packages(opts = {})
      data, _status_code, _headers = systeminsights_list_linux_packages_with_http_info(opts)
      data
    end

    # List System Insights Linux Packages
    # Lists all programs for Linux devices. For macOS devices, use [List System Insights System Apps](#operation/systeminsights_list_apps). For windows devices, use [List System Insights System Apps](#operation/systeminsights_list_programs).  Valid filter fields are &#x60;name&#x60; and &#x60;package_format&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsLinuxPackages>, Integer, Hash)>] Array<SystemInsightsLinuxPackages> data, response status code and response headers
    def systeminsights_list_linux_packages_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_linux_packages ...'
      end
      # resource path
      local_var_path = '/systeminsights/linux_packages'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsLinuxPackages>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_linux_packages\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Logged-In Users
    # Valid filter fields are `system_id` and `user`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsLoggedInUsers>]
    def systeminsights_list_logged_in_users(opts = {})
      data, _status_code, _headers = systeminsights_list_logged_in_users_with_http_info(opts)
      data
    end

    # List System Insights Logged-In Users
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;user&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsLoggedInUsers>, Integer, Hash)>] Array<SystemInsightsLoggedInUsers> data, response status code and response headers
    def systeminsights_list_logged_in_users_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_logged_in_users ...'
      end
      # resource path
      local_var_path = '/systeminsights/logged_in_users'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsLoggedInUsers>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_logged_in_users\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Logical Drives
    # Valid filter fields are `system_id` and `device_id`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsLogicalDrives>]
    def systeminsights_list_logical_drives(opts = {})
      data, _status_code, _headers = systeminsights_list_logical_drives_with_http_info(opts)
      data
    end

    # List System Insights Logical Drives
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;device_id&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsLogicalDrives>, Integer, Hash)>] Array<SystemInsightsLogicalDrives> data, response status code and response headers
    def systeminsights_list_logical_drives_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_logical_drives ...'
      end
      # resource path
      local_var_path = '/systeminsights/logical_drives'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsLogicalDrives>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_logical_drives\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Managed Policies
    # Valid filter fields are `system_id` and `domain`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsManagedPolicies>]
    def systeminsights_list_managed_policies(opts = {})
      data, _status_code, _headers = systeminsights_list_managed_policies_with_http_info(opts)
      data
    end

    # List System Insights Managed Policies
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;domain&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsManagedPolicies>, Integer, Hash)>] Array<SystemInsightsManagedPolicies> data, response status code and response headers
    def systeminsights_list_managed_policies_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_managed_policies ...'
      end
      # resource path
      local_var_path = '/systeminsights/managed_policies'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsManagedPolicies>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_managed_policies\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Mounts
    # Valid filter fields are `system_id` and `path`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsMounts>]
    def systeminsights_list_mounts(opts = {})
      data, _status_code, _headers = systeminsights_list_mounts_with_http_info(opts)
      data
    end

    # List System Insights Mounts
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;path&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsMounts>, Integer, Hash)>] Array<SystemInsightsMounts> data, response status code and response headers
    def systeminsights_list_mounts_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_mounts ...'
      end
      # resource path
      local_var_path = '/systeminsights/mounts'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsMounts>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_mounts\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights OS Version
    # Valid filter fields are `system_id` and `version`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsOsVersion>]
    def systeminsights_list_os_version(opts = {})
      data, _status_code, _headers = systeminsights_list_os_version_with_http_info(opts)
      data
    end

    # List System Insights OS Version
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;version&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsOsVersion>, Integer, Hash)>] Array<SystemInsightsOsVersion> data, response status code and response headers
    def systeminsights_list_os_version_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_os_version ...'
      end
      # resource path
      local_var_path = '/systeminsights/os_version'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsOsVersion>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_os_version\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Patches
    # Valid filter fields are `system_id` and `hotfix_id`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsPatches>]
    def systeminsights_list_patches(opts = {})
      data, _status_code, _headers = systeminsights_list_patches_with_http_info(opts)
      data
    end

    # List System Insights Patches
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;hotfix_id&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsPatches>, Integer, Hash)>] Array<SystemInsightsPatches> data, response status code and response headers
    def systeminsights_list_patches_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_patches ...'
      end
      # resource path
      local_var_path = '/systeminsights/patches'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsPatches>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_patches\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Programs
    # Lists all programs for Windows devices. For macOS devices, use [List System Insights Apps](#operation/systeminsights_list_apps).  Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsPrograms>]
    def systeminsights_list_programs(opts = {})
      data, _status_code, _headers = systeminsights_list_programs_with_http_info(opts)
      data
    end

    # List System Insights Programs
    # Lists all programs for Windows devices. For macOS devices, use [List System Insights Apps](#operation/systeminsights_list_apps).  Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsPrograms>, Integer, Hash)>] Array<SystemInsightsPrograms> data, response status code and response headers
    def systeminsights_list_programs_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_programs ...'
      end
      # resource path
      local_var_path = '/systeminsights/programs'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsPrograms>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_programs\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Python Packages
    # Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsPythonPackages>]
    def systeminsights_list_python_packages(opts = {})
      data, _status_code, _headers = systeminsights_list_python_packages_with_http_info(opts)
      data
    end

    # List System Insights Python Packages
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsPythonPackages>, Integer, Hash)>] Array<SystemInsightsPythonPackages> data, response status code and response headers
    def systeminsights_list_python_packages_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_python_packages ...'
      end
      # resource path
      local_var_path = '/systeminsights/python_packages'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsPythonPackages>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_python_packages\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Safari Extensions
    # Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsSafariExtensions>]
    def systeminsights_list_safari_extensions(opts = {})
      data, _status_code, _headers = systeminsights_list_safari_extensions_with_http_info(opts)
      data
    end

    # List System Insights Safari Extensions
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsSafariExtensions>, Integer, Hash)>] Array<SystemInsightsSafariExtensions> data, response status code and response headers
    def systeminsights_list_safari_extensions_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_safari_extensions ...'
      end
      # resource path
      local_var_path = '/systeminsights/safari_extensions'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsSafariExtensions>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_safari_extensions\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Scheduled Tasks
    # Valid filter fields are `system_id` and `enabled`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsScheduledTasks>]
    def systeminsights_list_scheduled_tasks(opts = {})
      data, _status_code, _headers = systeminsights_list_scheduled_tasks_with_http_info(opts)
      data
    end

    # List System Insights Scheduled Tasks
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;enabled&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsScheduledTasks>, Integer, Hash)>] Array<SystemInsightsScheduledTasks> data, response status code and response headers
    def systeminsights_list_scheduled_tasks_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_scheduled_tasks ...'
      end
      # resource path
      local_var_path = '/systeminsights/scheduled_tasks'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsScheduledTasks>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_scheduled_tasks\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Secure Boot
    # Valid filter fields are `system_id`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsSecureboot>]
    def systeminsights_list_secureboot(opts = {})
      data, _status_code, _headers = systeminsights_list_secureboot_with_http_info(opts)
      data
    end

    # List System Insights Secure Boot
    # Valid filter fields are &#x60;system_id&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsSecureboot>, Integer, Hash)>] Array<SystemInsightsSecureboot> data, response status code and response headers
    def systeminsights_list_secureboot_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_secureboot ...'
      end
      # resource path
      local_var_path = '/systeminsights/secureboot'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsSecureboot>' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_secureboot\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Services
    # Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsServices>]
    def systeminsights_list_services(opts = {})
      data, _status_code, _headers = systeminsights_list_services_with_http_info(opts)
      data
    end

    # List System Insights Services
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsServices>, Integer, Hash)>] Array<SystemInsightsServices> data, response status code and response headers
    def systeminsights_list_services_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_services ...'
      end
      # resource path
      local_var_path = '/systeminsights/services'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsServices>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_services\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # LIst System Insights Shadow
    # Valid filter fields are `system_id` and `username`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsShadow>]
    def systeminsights_list_shadow(opts = {})
      data, _status_code, _headers = systeminsights_list_shadow_with_http_info(opts)
      data
    end

    # LIst System Insights Shadow
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;username&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsShadow>, Integer, Hash)>] Array<SystemInsightsShadow> data, response status code and response headers
    def systeminsights_list_shadow_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_shadow ...'
      end
      # resource path
      local_var_path = '/systeminsights/shadow'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsShadow>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_shadow\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Shared Folders
    # Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsSharedFolders>]
    def systeminsights_list_shared_folders(opts = {})
      data, _status_code, _headers = systeminsights_list_shared_folders_with_http_info(opts)
      data
    end

    # List System Insights Shared Folders
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsSharedFolders>, Integer, Hash)>] Array<SystemInsightsSharedFolders> data, response status code and response headers
    def systeminsights_list_shared_folders_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_shared_folders ...'
      end
      # resource path
      local_var_path = '/systeminsights/shared_folders'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsSharedFolders>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_shared_folders\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Shared Resources
    # Valid filter fields are `system_id` and `type`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsSharedResources>]
    def systeminsights_list_shared_resources(opts = {})
      data, _status_code, _headers = systeminsights_list_shared_resources_with_http_info(opts)
      data
    end

    # List System Insights Shared Resources
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;type&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsSharedResources>, Integer, Hash)>] Array<SystemInsightsSharedResources> data, response status code and response headers
    def systeminsights_list_shared_resources_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_shared_resources ...'
      end
      # resource path
      local_var_path = '/systeminsights/shared_resources'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsSharedResources>' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_shared_resources\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Sharing Preferences
    # Only valid filed field is `system_id`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsSharingPreferences>]
    def systeminsights_list_sharing_preferences(opts = {})
      data, _status_code, _headers = systeminsights_list_sharing_preferences_with_http_info(opts)
      data
    end

    # List System Insights Sharing Preferences
    # Only valid filed field is &#x60;system_id&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsSharingPreferences>, Integer, Hash)>] Array<SystemInsightsSharingPreferences> data, response status code and response headers
    def systeminsights_list_sharing_preferences_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_sharing_preferences ...'
      end
      # resource path
      local_var_path = '/systeminsights/sharing_preferences'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsSharingPreferences>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_sharing_preferences\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights SIP Config
    # Valid filter fields are `system_id` and `enabled`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsSipConfig>]
    def systeminsights_list_sip_config(opts = {})
      data, _status_code, _headers = systeminsights_list_sip_config_with_http_info(opts)
      data
    end

    # List System Insights SIP Config
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;enabled&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsSipConfig>, Integer, Hash)>] Array<SystemInsightsSipConfig> data, response status code and response headers
    def systeminsights_list_sip_config_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_sip_config ...'
      end
      # resource path
      local_var_path = '/systeminsights/sip_config'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsSipConfig>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_sip_config\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Startup Items
    # Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsStartupItems>]
    def systeminsights_list_startup_items(opts = {})
      data, _status_code, _headers = systeminsights_list_startup_items_with_http_info(opts)
      data
    end

    # List System Insights Startup Items
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsStartupItems>, Integer, Hash)>] Array<SystemInsightsStartupItems> data, response status code and response headers
    def systeminsights_list_startup_items_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_startup_items ...'
      end
      # resource path
      local_var_path = '/systeminsights/startup_items'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsStartupItems>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_startup_items\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights System Control
    # Valid filter fields are `system_id` and `name`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; Note: You can only filter by &#x60;system_id&#x60; and &#x60;name&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsSystemControls>]
    def systeminsights_list_system_controls(opts = {})
      data, _status_code, _headers = systeminsights_list_system_controls_with_http_info(opts)
      data
    end

    # List System Insights System Control
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;name&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; Note: You can only filter by &#x60;system_id&#x60; and &#x60;name&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsSystemControls>, Integer, Hash)>] Array<SystemInsightsSystemControls> data, response status code and response headers
    def systeminsights_list_system_controls_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_system_controls ...'
      end
      # resource path
      local_var_path = '/systeminsights/system_controls'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsSystemControls>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_system_controls\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights System Info
    # Valid filter fields are `system_id` and `cpu_subtype`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsSystemInfo>]
    def systeminsights_list_system_info(opts = {})
      data, _status_code, _headers = systeminsights_list_system_info_with_http_info(opts)
      data
    end

    # List System Insights System Info
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;cpu_subtype&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsSystemInfo>, Integer, Hash)>] Array<SystemInsightsSystemInfo> data, response status code and response headers
    def systeminsights_list_system_info_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_system_info ...'
      end
      # resource path
      local_var_path = '/systeminsights/system_info'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsSystemInfo>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_system_info\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights TPM Info
    # Valid filter fields are `system_id`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsTpmInfo>]
    def systeminsights_list_tpm_info(opts = {})
      data, _status_code, _headers = systeminsights_list_tpm_info_with_http_info(opts)
      data
    end

    # List System Insights TPM Info
    # Valid filter fields are &#x60;system_id&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsTpmInfo>, Integer, Hash)>] Array<SystemInsightsTpmInfo> data, response status code and response headers
    def systeminsights_list_tpm_info_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_tpm_info ...'
      end
      # resource path
      local_var_path = '/systeminsights/tpm_info'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['text/html'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsTpmInfo>' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_tpm_info\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Uptime
    # Valid filter fields are `system_id` and `days`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, gte, in. e.g: Filter for single value: &#x60;filter&#x3D;field:gte:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsUptime>]
    def systeminsights_list_uptime(opts = {})
      data, _status_code, _headers = systeminsights_list_uptime_with_http_info(opts)
      data
    end

    # List System Insights Uptime
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;days&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, gte, in. e.g: Filter for single value: &#x60;filter&#x3D;field:gte:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsUptime>, Integer, Hash)>] Array<SystemInsightsUptime> data, response status code and response headers
    def systeminsights_list_uptime_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_uptime ...'
      end
      # resource path
      local_var_path = '/systeminsights/uptime'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsUptime>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_uptime\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights USB Devices
    # Valid filter fields are `system_id` and `model`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsUsbDevices>]
    def systeminsights_list_usb_devices(opts = {})
      data, _status_code, _headers = systeminsights_list_usb_devices_with_http_info(opts)
      data
    end

    # List System Insights USB Devices
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;model&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsUsbDevices>, Integer, Hash)>] Array<SystemInsightsUsbDevices> data, response status code and response headers
    def systeminsights_list_usb_devices_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_usb_devices ...'
      end
      # resource path
      local_var_path = '/systeminsights/usb_devices'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsUsbDevices>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_usb_devices\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights User Groups
    # Only valid filter field is `system_id`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsUserGroups>]
    def systeminsights_list_user_groups(opts = {})
      data, _status_code, _headers = systeminsights_list_user_groups_with_http_info(opts)
      data
    end

    # List System Insights User Groups
    # Only valid filter field is &#x60;system_id&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsUserGroups>, Integer, Hash)>] Array<SystemInsightsUserGroups> data, response status code and response headers
    def systeminsights_list_user_groups_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_user_groups ...'
      end
      # resource path
      local_var_path = '/systeminsights/user_groups'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsUserGroups>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_user_groups\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights User SSH Keys
    # Valid filter fields are `system_id` and `uid`.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsUserSshKeys>]
    def systeminsights_list_user_ssh_keys(opts = {})
      data, _status_code, _headers = systeminsights_list_user_ssh_keys_with_http_info(opts)
      data
    end

    # List System Insights User SSH Keys
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;uid&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsUserSshKeys>, Integer, Hash)>] Array<SystemInsightsUserSshKeys> data, response status code and response headers
    def systeminsights_list_user_ssh_keys_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_user_ssh_keys ...'
      end
      # resource path
      local_var_path = '/systeminsights/user_ssh_keys'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsUserSshKeys>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_user_ssh_keys\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights User Assist
    # Valid filter fields are `system_id`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsUserassist>]
    def systeminsights_list_userassist(opts = {})
      data, _status_code, _headers = systeminsights_list_userassist_with_http_info(opts)
      data
    end

    # List System Insights User Assist
    # Valid filter fields are &#x60;system_id&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsUserassist>, Integer, Hash)>] Array<SystemInsightsUserassist> data, response status code and response headers
    def systeminsights_list_userassist_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_userassist ...'
      end
      # resource path
      local_var_path = '/systeminsights/userassist'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsUserassist>' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_userassist\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Users
    # Valid filter fields are `system_id` and `username`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsUsers>]
    def systeminsights_list_users(opts = {})
      data, _status_code, _headers = systeminsights_list_users_with_http_info(opts)
      data
    end

    # List System Insights Users
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;username&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsUsers>, Integer, Hash)>] Array<SystemInsightsUsers> data, response status code and response headers
    def systeminsights_list_users_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_users ...'
      end
      # resource path
      local_var_path = '/systeminsights/users'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsUsers>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_users\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights WiFi Networks
    # Valid filter fields are `system_id` and `security_type`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsWifiNetworks>]
    def systeminsights_list_wifi_networks(opts = {})
      data, _status_code, _headers = systeminsights_list_wifi_networks_with_http_info(opts)
      data
    end

    # List System Insights WiFi Networks
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;security_type&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsWifiNetworks>, Integer, Hash)>] Array<SystemInsightsWifiNetworks> data, response status code and response headers
    def systeminsights_list_wifi_networks_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_wifi_networks ...'
      end
      # resource path
      local_var_path = '/systeminsights/wifi_networks'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsWifiNetworks>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_wifi_networks\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights WiFi Status
    # Valid filter fields are `system_id` and `security_type`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsWifiStatus>]
    def systeminsights_list_wifi_status(opts = {})
      data, _status_code, _headers = systeminsights_list_wifi_status_with_http_info(opts)
      data
    end

    # List System Insights WiFi Status
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;security_type&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsWifiStatus>, Integer, Hash)>] Array<SystemInsightsWifiStatus> data, response status code and response headers
    def systeminsights_list_wifi_status_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_wifi_status ...'
      end
      # resource path
      local_var_path = '/systeminsights/wifi_status'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsWifiStatus>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_wifi_status\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Windows Security Center
    # Valid filter fields are `system_id`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsWindowsSecurityCenter>]
    def systeminsights_list_windows_security_center(opts = {})
      data, _status_code, _headers = systeminsights_list_windows_security_center_with_http_info(opts)
      data
    end

    # List System Insights Windows Security Center
    # Valid filter fields are &#x60;system_id&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsWindowsSecurityCenter>, Integer, Hash)>] Array<SystemInsightsWindowsSecurityCenter> data, response status code and response headers
    def systeminsights_list_windows_security_center_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_windows_security_center ...'
      end
      # resource path
      local_var_path = '/systeminsights/windows_security_center'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsWindowsSecurityCenter>' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_windows_security_center\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List System Insights Windows Security Products
    # Valid filter fields are `system_id` and `state`.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit  (default to 10)
    # @return [Array<SystemInsightsWindowsSecurityProducts>]
    def systeminsights_list_windows_security_products(opts = {})
      data, _status_code, _headers = systeminsights_list_windows_security_products_with_http_info(opts)
      data
    end

    # List System Insights Windows Security Products
    # Valid filter fields are &#x60;system_id&#x60; and &#x60;state&#x60;.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. e.g: Sort by single field: &#x60;sort&#x3D;field&#x60; Sort descending by single field: &#x60;sort&#x3D;-field&#x60; Sort by multiple fields: &#x60;sort&#x3D;field1,-field2,field3&#x60; 
    # @option opts [Array<String>] :filter Supported operators are: eq, in. e.g: Filter for single value: &#x60;filter&#x3D;field:eq:value&#x60; Filter for any value in a list: (note \&quot;pipe\&quot; character: &#x60;|&#x60; separating values) &#x60;filter&#x3D;field:in:value1|value2|value3&#x60; 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :limit 
    # @return [Array<(Array<SystemInsightsWindowsSecurityProducts>, Integer, Hash)>] Array<SystemInsightsWindowsSecurityProducts> data, response status code and response headers
    def systeminsights_list_windows_security_products_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemInsightsApi.systeminsights_list_windows_security_products ...'
      end
      # resource path
      local_var_path = '/systeminsights/windows_security_products'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<SystemInsightsWindowsSecurityProducts>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemInsightsApi#systeminsights_list_windows_security_products\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
