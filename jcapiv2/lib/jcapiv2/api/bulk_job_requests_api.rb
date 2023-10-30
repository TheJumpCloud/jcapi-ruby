=begin
#JumpCloud API

## Overview  JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.  # Directory Objects  This API offers the ability to interact with some of our core features; otherwise known as Directory Objects. The Directory Objects are:  * Commands * Policies * Policy Groups * Applications * Systems * Users * User Groups * System Groups * Radius Servers * Directories: Office 365, LDAP,G-Suite, Active Directory * Duo accounts and applications.  The Directory Object is an important concept to understand in order to successfully use JumpCloud API.  ## JumpCloud Graph  We've also introduced the concept of the JumpCloud Graph along with  Directory Objects. The Graph is a powerful aspect of our platform which will enable you to associate objects with each other, or establish membership for certain objects to become members of other objects.  Specific `GET` endpoints will allow you to traverse the JumpCloud Graph to return all indirect and directly bound objects in your organization.  | ![alt text](https://s3.amazonaws.com/jumpcloud-kb/Knowledge+Base+Photos/API+Docs/jumpcloud_graph.png \"JumpCloud Graph Model Example\") | |:--:| | **This diagram highlights our association and membership model as it relates to Directory Objects.** |  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/v2/systemgroups\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 2.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.32
=end

module JCAPIv2
  class BulkJobRequestsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Create Scheduled Userstate Job
    # This endpoint allows you to create scheduled statechange jobs. #### Sample Request ``` curl -X POST \"https://console.jumpcloud.com/api/v2/bulk/userstates\" \\   -H 'x-api-key: {API_KEY}' \\   -H 'Content-Type: application/json' \\   -H 'Accept: application/json' \\   -d '{     \"user_ids\": [\"{User_ID_1}\", \"{User_ID_2}\", \"{User_ID_3}\"],     \"state\": \"SUSPENDED\",     \"start_date\": \"2000-01-01T00:00:00.000Z\"   }' ```
    # @param [Hash] opts the optional parameters
    # @option opts [BulkScheduledStatechangeCreate] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<ScheduledUserstateResult>]
    def bulk_user_states_create(opts = {})
      data, _status_code, _headers = bulk_user_states_create_with_http_info(opts)
      data
    end

    # Create Scheduled Userstate Job
    # This endpoint allows you to create scheduled statechange jobs. #### Sample Request &#x60;&#x60;&#x60; curl -X POST \&quot;https://console.jumpcloud.com/api/v2/bulk/userstates\&quot; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;Accept: application/json&#x27; \\   -d &#x27;{     \&quot;user_ids\&quot;: [\&quot;{User_ID_1}\&quot;, \&quot;{User_ID_2}\&quot;, \&quot;{User_ID_3}\&quot;],     \&quot;state\&quot;: \&quot;SUSPENDED\&quot;,     \&quot;start_date\&quot;: \&quot;2000-01-01T00:00:00.000Z\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [BulkScheduledStatechangeCreate] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<ScheduledUserstateResult>, Integer, Hash)>] Array<ScheduledUserstateResult> data, response status code and response headers
    def bulk_user_states_create_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: BulkJobRequestsApi.bulk_user_states_create ...'
      end
      # resource path
      local_var_path = '/bulk/userstates'

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

      return_type = opts[:return_type] || 'Array<ScheduledUserstateResult>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: BulkJobRequestsApi#bulk_user_states_create\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete Scheduled Userstate Job
    # This endpoint deletes a scheduled statechange job. #### Sample Request ``` curl -X DELETE \"https://console.jumpcloud.com/api/v2/bulk/userstates/{ScheduledJob_ID}\" \\   -H 'x-api-key: {API_KEY}' \\   -H 'Content-Type: application/json' \\   -H 'Accept: application/json' ```
    # @param id Unique identifier of the scheduled statechange job.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def bulk_user_states_delete(id, opts = {})
      bulk_user_states_delete_with_http_info(id, opts)
      nil
    end

    # Delete Scheduled Userstate Job
    # This endpoint deletes a scheduled statechange job. #### Sample Request &#x60;&#x60;&#x60; curl -X DELETE \&quot;https://console.jumpcloud.com/api/v2/bulk/userstates/{ScheduledJob_ID}\&quot; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;Accept: application/json&#x27; &#x60;&#x60;&#x60;
    # @param id Unique identifier of the scheduled statechange job.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def bulk_user_states_delete_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: BulkJobRequestsApi.bulk_user_states_delete ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling BulkJobRequestsApi.bulk_user_states_delete"
      end
      # resource path
      local_var_path = '/bulk/userstates/{id}'.sub('{' + 'id' + '}', id.to_s)

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
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: BulkJobRequestsApi#bulk_user_states_delete\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Gets the next scheduled state change for each user in a list of system users
    # This endpoint is used to lookup the next upcoming scheduled state change for each user in the given list. The users parameter is limited to 100 items per request. #### Sample Request ``` curl -X GET \"https://console.jumpcloud.com/api/v2/bulk/userstates/eventlist/next?users={UserID1},{UserID2},{UserID3}\" \\   -H 'x-api-key: {API_KEY}' \\   -H 'Content-Type: application/json' \\   -H 'Accept: application/json' ```
    # @param users A list of system user IDs
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @return [InlineResponse200]
    def bulk_user_states_get_next_scheduled(users, opts = {})
      data, _status_code, _headers = bulk_user_states_get_next_scheduled_with_http_info(users, opts)
      data
    end

    # Gets the next scheduled state change for each user in a list of system users
    # This endpoint is used to lookup the next upcoming scheduled state change for each user in the given list. The users parameter is limited to 100 items per request. #### Sample Request &#x60;&#x60;&#x60; curl -X GET \&quot;https://console.jumpcloud.com/api/v2/bulk/userstates/eventlist/next?users&#x3D;{UserID1},{UserID2},{UserID3}\&quot; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;Accept: application/json&#x27; &#x60;&#x60;&#x60;
    # @param users A list of system user IDs
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @return [Array<(InlineResponse200, Integer, Hash)>] InlineResponse200 data, response status code and response headers
    def bulk_user_states_get_next_scheduled_with_http_info(users, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: BulkJobRequestsApi.bulk_user_states_get_next_scheduled ...'
      end
      # verify the required parameter 'users' is set
      if @api_client.config.client_side_validation && users.nil?
        fail ArgumentError, "Missing the required parameter 'users' when calling BulkJobRequestsApi.bulk_user_states_get_next_scheduled"
      end
      # resource path
      local_var_path = '/bulk/userstates/eventlist/next'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'users'] = @api_client.build_collection_param(users, :csv)
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

      return_type = opts[:return_type] || 'InlineResponse200' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: BulkJobRequestsApi#bulk_user_states_get_next_scheduled\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Scheduled Userstate Change Jobs
    # The endpoint allows you to list scheduled statechange jobs. #### Sample Request ``` curl -X GET \"https://console.jumpcloud.com/api/v2/bulk/userstates\" \\   -H 'x-api-key: {API_KEY}' \\   -H 'Content-Type: application/json' \\   -H 'Accept: application/json' ```
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [String] :userid The systemuser id to filter by.
    # @return [Array<ScheduledUserstateResult>]
    def bulk_user_states_list(opts = {})
      data, _status_code, _headers = bulk_user_states_list_with_http_info(opts)
      data
    end

    # List Scheduled Userstate Change Jobs
    # The endpoint allows you to list scheduled statechange jobs. #### Sample Request &#x60;&#x60;&#x60; curl -X GET \&quot;https://console.jumpcloud.com/api/v2/bulk/userstates\&quot; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;Accept: application/json&#x27; &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [String] :userid The systemuser id to filter by.
    # @return [Array<(Array<ScheduledUserstateResult>, Integer, Hash)>] Array<ScheduledUserstateResult> data, response status code and response headers
    def bulk_user_states_list_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: BulkJobRequestsApi.bulk_user_states_list ...'
      end
      # resource path
      local_var_path = '/bulk/userstates'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'userid'] = opts[:'userid'] if !opts[:'userid'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<ScheduledUserstateResult>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: BulkJobRequestsApi#bulk_user_states_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Bulk Users Create
    # The endpoint allows you to create a bulk job to asynchronously create users. See [Create a System User](https://docs.jumpcloud.com/api/1.0/index.html#operation/systemusers_post) for the full list of attributes.  #### Default User State The `state` of each user in the request can be explicitly passed in or omitted. If `state` is omitted, then the user will get created using the value returned from the [Get an Organization](https://docs.jumpcloud.com/api/1.0/index.html#operation/organizations_get) endpoint. The default user state for bulk created users depends on the `creation-source` header. For `creation-source:jumpcloud:bulk` the default state is stored in `settings.newSystemUserStateDefaults.csvImport`. For other `creation-source` header values, the default state is stored in `settings.newSystemUserStateDefaults.applicationImport`  These default state values can be changed in the admin portal settings or by using the [Update an Organization](https://docs.jumpcloud.com/api/1.0/index.html#operation/organization_put) endpoint.  #### Sample Request  ``` curl -X POST https://console.jumpcloud.com/api/v2/bulk/users \\ -H 'Accept: application/json' \\ -H 'Content-Type: application/json' \\ -H 'x-api-key: {API_KEY}' \\ -d '[   {     \"email\":\"{email}\",     \"firstname\":\"{firstname}\",     \"lastname\":\"{firstname}\",     \"username\":\"{username}\",     \"attributes\":[       {         \"name\":\"EmployeeID\",         \"value\":\"0000\"       },       {         \"name\":\"Custom\",         \"value\":\"attribute\"       }     ]   } ]' ```
    # @param [Hash] opts the optional parameters
    # @option opts [Array<BulkUserCreate>] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [String] :creation_source Defines the creation-source header for gapps, o365 and workdays requests. If the header isn&#x27;t sent, the default value is &#x60;jumpcloud:bulk&#x60;, if you send the header with a malformed value you receive a 400 error.  (default to jumpcloud:bulk)
    # @return [JobId]
    def bulk_users_create(opts = {})
      data, _status_code, _headers = bulk_users_create_with_http_info(opts)
      data
    end

    # Bulk Users Create
    # The endpoint allows you to create a bulk job to asynchronously create users. See [Create a System User](https://docs.jumpcloud.com/api/1.0/index.html#operation/systemusers_post) for the full list of attributes.  #### Default User State The &#x60;state&#x60; of each user in the request can be explicitly passed in or omitted. If &#x60;state&#x60; is omitted, then the user will get created using the value returned from the [Get an Organization](https://docs.jumpcloud.com/api/1.0/index.html#operation/organizations_get) endpoint. The default user state for bulk created users depends on the &#x60;creation-source&#x60; header. For &#x60;creation-source:jumpcloud:bulk&#x60; the default state is stored in &#x60;settings.newSystemUserStateDefaults.csvImport&#x60;. For other &#x60;creation-source&#x60; header values, the default state is stored in &#x60;settings.newSystemUserStateDefaults.applicationImport&#x60;  These default state values can be changed in the admin portal settings or by using the [Update an Organization](https://docs.jumpcloud.com/api/1.0/index.html#operation/organization_put) endpoint.  #### Sample Request  &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/bulk/users \\ -H &#x27;Accept: application/json&#x27; \\ -H &#x27;Content-Type: application/json&#x27; \\ -H &#x27;x-api-key: {API_KEY}&#x27; \\ -d &#x27;[   {     \&quot;email\&quot;:\&quot;{email}\&quot;,     \&quot;firstname\&quot;:\&quot;{firstname}\&quot;,     \&quot;lastname\&quot;:\&quot;{firstname}\&quot;,     \&quot;username\&quot;:\&quot;{username}\&quot;,     \&quot;attributes\&quot;:[       {         \&quot;name\&quot;:\&quot;EmployeeID\&quot;,         \&quot;value\&quot;:\&quot;0000\&quot;       },       {         \&quot;name\&quot;:\&quot;Custom\&quot;,         \&quot;value\&quot;:\&quot;attribute\&quot;       }     ]   } ]&#x27; &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [Array<BulkUserCreate>] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [String] :creation_source Defines the creation-source header for gapps, o365 and workdays requests. If the header isn&#x27;t sent, the default value is &#x60;jumpcloud:bulk&#x60;, if you send the header with a malformed value you receive a 400 error. 
    # @return [Array<(JobId, Integer, Hash)>] JobId data, response status code and response headers
    def bulk_users_create_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: BulkJobRequestsApi.bulk_users_create ...'
      end
      if @api_client.config.client_side_validation && opts[:'creation_source'] && !['jumpcloud:gapps', 'jumpcloud:o365', 'jumpcloud:workday', 'jumpcloud:scim', 'jumpcloud:bulk', 'jumpcloud:custom_integration'].include?(opts[:'creation_source'])
        fail ArgumentError, 'invalid value for "creation_source", must be one of jumpcloud:gapps, jumpcloud:o365, jumpcloud:workday, jumpcloud:scim, jumpcloud:bulk, jumpcloud:custom_integration'
      end
      # resource path
      local_var_path = '/bulk/users'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?
      header_params[:'creation-source'] = opts[:'creation_source'] if !opts[:'creation_source'].nil?

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
        @api_client.config.logger.debug "API called: BulkJobRequestsApi#bulk_users_create\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Bulk Users Results
    # This endpoint will return the results of particular user import or update job request.  #### Sample Request ``` curl -X GET \\   https://console.jumpcloud.com/api/v2/bulk/users/{ImportJobID}/results \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```
    # @param job_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<JobWorkresult>]
    def bulk_users_create_results(job_id, opts = {})
      data, _status_code, _headers = bulk_users_create_results_with_http_info(job_id, opts)
      data
    end

    # List Bulk Users Results
    # This endpoint will return the results of particular user import or update job request.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET \\   https://console.jumpcloud.com/api/v2/bulk/users/{ImportJobID}/results \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;   &#x60;&#x60;&#x60;
    # @param job_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<JobWorkresult>, Integer, Hash)>] Array<JobWorkresult> data, response status code and response headers
    def bulk_users_create_results_with_http_info(job_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: BulkJobRequestsApi.bulk_users_create_results ...'
      end
      # verify the required parameter 'job_id' is set
      if @api_client.config.client_side_validation && job_id.nil?
        fail ArgumentError, "Missing the required parameter 'job_id' when calling BulkJobRequestsApi.bulk_users_create_results"
      end
      # resource path
      local_var_path = '/bulk/users/{job_id}/results'.sub('{' + 'job_id' + '}', job_id.to_s)

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
        @api_client.config.logger.debug "API called: BulkJobRequestsApi#bulk_users_create_results\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Bulk Users Update
    # The endpoint allows you to create a bulk job to asynchronously update users. See [Update a System User](https://docs.jumpcloud.com/api/1.0/index.html#operation/systemusers_put) for full list of attributes.  #### Sample Request  ``` curl -X PATCH https://console.jumpcloud.com/api/v2/bulk/users \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '[  {    \"id\":\"5be9fb4ddb01290001e85109\",   \"firstname\":\"{UPDATED_FIRSTNAME}\",   \"department\":\"{UPDATED_DEPARTMENT}\",   \"attributes\":[    {\"name\":\"Custom\",\"value\":\"{ATTRIBUTE_VALUE}\"}   ]  },  {    \"id\":\"5be9fb4ddb01290001e85109\",   \"firstname\":\"{UPDATED_FIRSTNAME}\",   \"costCenter\":\"{UPDATED_COST_CENTER}\",   \"phoneNumbers\":[    {\"type\":\"home\",\"number\":\"{HOME_PHONE_NUMBER}\"},    {\"type\":\"work\",\"number\":\"{WORK_PHONE_NUMBER}\"}   ]  } ] ```
    # @param [Hash] opts the optional parameters
    # @option opts [Array<BulkUserUpdate>] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [JobId]
    def bulk_users_update(opts = {})
      data, _status_code, _headers = bulk_users_update_with_http_info(opts)
      data
    end

    # Bulk Users Update
    # The endpoint allows you to create a bulk job to asynchronously update users. See [Update a System User](https://docs.jumpcloud.com/api/1.0/index.html#operation/systemusers_put) for full list of attributes.  #### Sample Request  &#x60;&#x60;&#x60; curl -X PATCH https://console.jumpcloud.com/api/v2/bulk/users \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;[  {    \&quot;id\&quot;:\&quot;5be9fb4ddb01290001e85109\&quot;,   \&quot;firstname\&quot;:\&quot;{UPDATED_FIRSTNAME}\&quot;,   \&quot;department\&quot;:\&quot;{UPDATED_DEPARTMENT}\&quot;,   \&quot;attributes\&quot;:[    {\&quot;name\&quot;:\&quot;Custom\&quot;,\&quot;value\&quot;:\&quot;{ATTRIBUTE_VALUE}\&quot;}   ]  },  {    \&quot;id\&quot;:\&quot;5be9fb4ddb01290001e85109\&quot;,   \&quot;firstname\&quot;:\&quot;{UPDATED_FIRSTNAME}\&quot;,   \&quot;costCenter\&quot;:\&quot;{UPDATED_COST_CENTER}\&quot;,   \&quot;phoneNumbers\&quot;:[    {\&quot;type\&quot;:\&quot;home\&quot;,\&quot;number\&quot;:\&quot;{HOME_PHONE_NUMBER}\&quot;},    {\&quot;type\&quot;:\&quot;work\&quot;,\&quot;number\&quot;:\&quot;{WORK_PHONE_NUMBER}\&quot;}   ]  } ] &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [Array<BulkUserUpdate>] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(JobId, Integer, Hash)>] JobId data, response status code and response headers
    def bulk_users_update_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: BulkJobRequestsApi.bulk_users_update ...'
      end
      # resource path
      local_var_path = '/bulk/users'

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
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: BulkJobRequestsApi#bulk_users_update\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
