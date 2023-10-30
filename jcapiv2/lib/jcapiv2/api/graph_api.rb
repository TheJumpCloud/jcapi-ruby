=begin
#JumpCloud API

## Overview  JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.  # Directory Objects  This API offers the ability to interact with some of our core features; otherwise known as Directory Objects. The Directory Objects are:  * Commands * Policies * Policy Groups * Applications * Systems * Users * User Groups * System Groups * Radius Servers * Directories: Office 365, LDAP,G-Suite, Active Directory * Duo accounts and applications.  The Directory Object is an important concept to understand in order to successfully use JumpCloud API.  ## JumpCloud Graph  We've also introduced the concept of the JumpCloud Graph along with  Directory Objects. The Graph is a powerful aspect of our platform which will enable you to associate objects with each other, or establish membership for certain objects to become members of other objects.  Specific `GET` endpoints will allow you to traverse the JumpCloud Graph to return all indirect and directly bound objects in your organization.  | ![alt text](https://s3.amazonaws.com/jumpcloud-kb/Knowledge+Base+Photos/API+Docs/jumpcloud_graph.png \"JumpCloud Graph Model Example\") | |:--:| | **This diagram highlights our association and membership model as it relates to Directory Objects.** |  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/v2/systemgroups\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 2.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.32
=end

module JCAPIv2
  class GraphApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # List the associations of an Active Directory instance
    # This endpoint returns the direct associations of this Active Directory instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Active Directory and Users.   #### Sample Request ``` curl -X GET 'https://console.jumpcloud.com/api/v2/activedirectories/{ActiveDirectory_ID}/associations?targets=user \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param activedirectory_id 
    # @param targets Targets which a \&quot;active_directory\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_active_directory_associations_list(activedirectory_id, targets, opts = {})
      data, _status_code, _headers = graph_active_directory_associations_list_with_http_info(activedirectory_id, targets, opts)
      data
    end

    # List the associations of an Active Directory instance
    # This endpoint returns the direct associations of this Active Directory instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Active Directory and Users.   #### Sample Request &#x60;&#x60;&#x60; curl -X GET &#x27;https://console.jumpcloud.com/api/v2/activedirectories/{ActiveDirectory_ID}/associations?targets&#x3D;user \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param activedirectory_id 
    # @param targets Targets which a \&quot;active_directory\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_active_directory_associations_list_with_http_info(activedirectory_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_active_directory_associations_list ...'
      end
      # verify the required parameter 'activedirectory_id' is set
      if @api_client.config.client_side_validation && activedirectory_id.nil?
        fail ArgumentError, "Missing the required parameter 'activedirectory_id' when calling GraphApi.graph_active_directory_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_active_directory_associations_list"
      end
      # resource path
      local_var_path = '/activedirectories/{activedirectory_id}/associations'.sub('{' + 'activedirectory_id' + '}', activedirectory_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_active_directory_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of an Active Directory instance
    # This endpoint allows you to manage the _direct_ associations of an Active Directory instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Active Directory and Users.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/activedirectories/{AD_Instance_ID}/associations \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"user\",     \"id\": \"{User_ID}\"   }' ```
    # @param activedirectory_id 
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationActiveDirectory] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_active_directory_associations_post(activedirectory_id, opts = {})
      graph_active_directory_associations_post_with_http_info(activedirectory_id, opts)
      nil
    end

    # Manage the associations of an Active Directory instance
    # This endpoint allows you to manage the _direct_ associations of an Active Directory instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Active Directory and Users.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/activedirectories/{AD_Instance_ID}/associations \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;user\&quot;,     \&quot;id\&quot;: \&quot;{User_ID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param activedirectory_id 
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationActiveDirectory] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_active_directory_associations_post_with_http_info(activedirectory_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_active_directory_associations_post ...'
      end
      # verify the required parameter 'activedirectory_id' is set
      if @api_client.config.client_side_validation && activedirectory_id.nil?
        fail ArgumentError, "Missing the required parameter 'activedirectory_id' when calling GraphApi.graph_active_directory_associations_post"
      end
      # resource path
      local_var_path = '/activedirectories/{activedirectory_id}/associations'.sub('{' + 'activedirectory_id' + '}', activedirectory_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_active_directory_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Users bound to an Active Directory instance
    # This endpoint will return all Users bound to an Active Directory instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Active Directory instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this Active Directory instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/activedirectories/{ActiveDirectory_ID}/users \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param activedirectory_id ObjectID of the Active Directory instance.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @return [Array<GraphObjectWithPaths>]
    def graph_active_directory_traverse_user(activedirectory_id, opts = {})
      data, _status_code, _headers = graph_active_directory_traverse_user_with_http_info(activedirectory_id, opts)
      data
    end

    # List the Users bound to an Active Directory instance
    # This endpoint will return all Users bound to an Active Directory instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Active Directory instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this Active Directory instance.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/activedirectories/{ActiveDirectory_ID}/users \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param activedirectory_id ObjectID of the Active Directory instance.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_active_directory_traverse_user_with_http_info(activedirectory_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_active_directory_traverse_user ...'
      end
      # verify the required parameter 'activedirectory_id' is set
      if @api_client.config.client_side_validation && activedirectory_id.nil?
        fail ArgumentError, "Missing the required parameter 'activedirectory_id' when calling GraphApi.graph_active_directory_traverse_user"
      end
      # resource path
      local_var_path = '/activedirectories/{activedirectory_id}/users'.sub('{' + 'activedirectory_id' + '}', activedirectory_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_active_directory_traverse_user\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the User Groups bound to an Active Directory instance
    # This endpoint will return all Users Groups bound to an Active Directory instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Active Directory instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this Active Directory instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/activedirectories/{ActiveDirectory_ID}/usergroups \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param activedirectory_id ObjectID of the Active Directory instance.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_active_directory_traverse_user_group(activedirectory_id, opts = {})
      data, _status_code, _headers = graph_active_directory_traverse_user_group_with_http_info(activedirectory_id, opts)
      data
    end

    # List the User Groups bound to an Active Directory instance
    # This endpoint will return all Users Groups bound to an Active Directory instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group&#x27;s type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Active Directory instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this Active Directory instance.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/activedirectories/{ActiveDirectory_ID}/usergroups \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param activedirectory_id ObjectID of the Active Directory instance.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_active_directory_traverse_user_group_with_http_info(activedirectory_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_active_directory_traverse_user_group ...'
      end
      # verify the required parameter 'activedirectory_id' is set
      if @api_client.config.client_side_validation && activedirectory_id.nil?
        fail ArgumentError, "Missing the required parameter 'activedirectory_id' when calling GraphApi.graph_active_directory_traverse_user_group"
      end
      # resource path
      local_var_path = '/activedirectories/{activedirectory_id}/usergroups'.sub('{' + 'activedirectory_id' + '}', activedirectory_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_active_directory_traverse_user_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of an Application
    # This endpoint will return the _direct_ associations of an Application. A direct association can be a non-homogeneous relationship between 2 different objects, for example Applications and User Groups.   #### Sample Request ``` curl -X GET 'https://console.jumpcloud.com/api/v2/applications/{Application_ID}/associations?targets=user_group \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param application_id ObjectID of the Application.
    # @param targets Targets which a \&quot;application\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_application_associations_list(application_id, targets, opts = {})
      data, _status_code, _headers = graph_application_associations_list_with_http_info(application_id, targets, opts)
      data
    end

    # List the associations of an Application
    # This endpoint will return the _direct_ associations of an Application. A direct association can be a non-homogeneous relationship between 2 different objects, for example Applications and User Groups.   #### Sample Request &#x60;&#x60;&#x60; curl -X GET &#x27;https://console.jumpcloud.com/api/v2/applications/{Application_ID}/associations?targets&#x3D;user_group \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param application_id ObjectID of the Application.
    # @param targets Targets which a \&quot;application\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_application_associations_list_with_http_info(application_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_application_associations_list ...'
      end
      # verify the required parameter 'application_id' is set
      if @api_client.config.client_side_validation && application_id.nil?
        fail ArgumentError, "Missing the required parameter 'application_id' when calling GraphApi.graph_application_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_application_associations_list"
      end
      # resource path
      local_var_path = '/applications/{application_id}/associations'.sub('{' + 'application_id' + '}', application_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_application_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of an Application
    # This endpoint allows you to manage the _direct_ associations of an Application. A direct association can be a non-homogeneous relationship between 2 different objects, for example Application and User Groups.  #### Sample Request ``` curl -X POST 'https://console.jumpcloud.com/api/v2/applications/{Application_ID}/associations' \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"user_group\",     \"id\": \"{Group_ID}\"   }' ```
    # @param application_id ObjectID of the Application.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationApplication] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_application_associations_post(application_id, opts = {})
      graph_application_associations_post_with_http_info(application_id, opts)
      nil
    end

    # Manage the associations of an Application
    # This endpoint allows you to manage the _direct_ associations of an Application. A direct association can be a non-homogeneous relationship between 2 different objects, for example Application and User Groups.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST &#x27;https://console.jumpcloud.com/api/v2/applications/{Application_ID}/associations&#x27; \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;user_group\&quot;,     \&quot;id\&quot;: \&quot;{Group_ID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param application_id ObjectID of the Application.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationApplication] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_application_associations_post_with_http_info(application_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_application_associations_post ...'
      end
      # verify the required parameter 'application_id' is set
      if @api_client.config.client_side_validation && application_id.nil?
        fail ArgumentError, "Missing the required parameter 'application_id' when calling GraphApi.graph_application_associations_post"
      end
      # resource path
      local_var_path = '/applications/{application_id}/associations'.sub('{' + 'application_id' + '}', application_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_application_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Users bound to an Application
    # This endpoint will return all Users bound to an Application, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Application to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this Application.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/applications/{Application_ID}/users \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param application_id ObjectID of the Application.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_application_traverse_user(application_id, opts = {})
      data, _status_code, _headers = graph_application_traverse_user_with_http_info(application_id, opts)
      data
    end

    # List the Users bound to an Application
    # This endpoint will return all Users bound to an Application, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Application to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this Application.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/applications/{Application_ID}/users \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param application_id ObjectID of the Application.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_application_traverse_user_with_http_info(application_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_application_traverse_user ...'
      end
      # verify the required parameter 'application_id' is set
      if @api_client.config.client_side_validation && application_id.nil?
        fail ArgumentError, "Missing the required parameter 'application_id' when calling GraphApi.graph_application_traverse_user"
      end
      # resource path
      local_var_path = '/applications/{application_id}/users'.sub('{' + 'application_id' + '}', application_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_application_traverse_user\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the User Groups bound to an Application
    # This endpoint will return all Users Groups bound to an Application, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates  each path from this Application to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this Application.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/applications/{Application_ID}/usergroups \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param application_id ObjectID of the Application.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_application_traverse_user_group(application_id, opts = {})
      data, _status_code, _headers = graph_application_traverse_user_group_with_http_info(application_id, opts)
      data
    end

    # List the User Groups bound to an Application
    # This endpoint will return all Users Groups bound to an Application, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group&#x27;s type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates  each path from this Application to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this Application.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/applications/{Application_ID}/usergroups \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param application_id ObjectID of the Application.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_application_traverse_user_group_with_http_info(application_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_application_traverse_user_group ...'
      end
      # verify the required parameter 'application_id' is set
      if @api_client.config.client_side_validation && application_id.nil?
        fail ArgumentError, "Missing the required parameter 'application_id' when calling GraphApi.graph_application_traverse_user_group"
      end
      # resource path
      local_var_path = '/applications/{application_id}/usergroups'.sub('{' + 'application_id' + '}', application_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_application_traverse_user_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of a Command
    # This endpoint will return the _direct_ associations of this Command.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Commands and User Groups.   #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/commands/{Command_ID}/associations?targets=system_group \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param command_id ObjectID of the Command.
    # @param targets Targets which a \&quot;command\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_command_associations_list(command_id, targets, opts = {})
      data, _status_code, _headers = graph_command_associations_list_with_http_info(command_id, targets, opts)
      data
    end

    # List the associations of a Command
    # This endpoint will return the _direct_ associations of this Command.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Commands and User Groups.   #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/commands/{Command_ID}/associations?targets&#x3D;system_group \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param command_id ObjectID of the Command.
    # @param targets Targets which a \&quot;command\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_command_associations_list_with_http_info(command_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_command_associations_list ...'
      end
      # verify the required parameter 'command_id' is set
      if @api_client.config.client_side_validation && command_id.nil?
        fail ArgumentError, "Missing the required parameter 'command_id' when calling GraphApi.graph_command_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_command_associations_list"
      end
      # resource path
      local_var_path = '/commands/{command_id}/associations'.sub('{' + 'command_id' + '}', command_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_command_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of a Command
    # This endpoint will allow you to manage the _direct_ associations of this Command.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Commands and User Groups.   #### Sample Request ```  curl -X POST https://console.jumpcloud.com/api/v2/commands/{Command_ID}/associations \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"system_group\",     \"id\": \"Group_ID\"   }' ```
    # @param command_id ObjectID of the Command.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationCommand] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_command_associations_post(command_id, opts = {})
      graph_command_associations_post_with_http_info(command_id, opts)
      nil
    end

    # Manage the associations of a Command
    # This endpoint will allow you to manage the _direct_ associations of this Command.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Commands and User Groups.   #### Sample Request &#x60;&#x60;&#x60;  curl -X POST https://console.jumpcloud.com/api/v2/commands/{Command_ID}/associations \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;system_group\&quot;,     \&quot;id\&quot;: \&quot;Group_ID\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param command_id ObjectID of the Command.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationCommand] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_command_associations_post_with_http_info(command_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_command_associations_post ...'
      end
      # verify the required parameter 'command_id' is set
      if @api_client.config.client_side_validation && command_id.nil?
        fail ArgumentError, "Missing the required parameter 'command_id' when calling GraphApi.graph_command_associations_post"
      end
      # resource path
      local_var_path = '/commands/{command_id}/associations'.sub('{' + 'command_id' + '}', command_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_command_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Systems bound to a Command
    # This endpoint will return all Systems bound to a Command, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Command to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this Command.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/commands/{Command_ID}/systems \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param command_id ObjectID of the Command.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_command_traverse_system(command_id, opts = {})
      data, _status_code, _headers = graph_command_traverse_system_with_http_info(command_id, opts)
      data
    end

    # List the Systems bound to a Command
    # This endpoint will return all Systems bound to a Command, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Command to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this Command.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/commands/{Command_ID}/systems \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param command_id ObjectID of the Command.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_command_traverse_system_with_http_info(command_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_command_traverse_system ...'
      end
      # verify the required parameter 'command_id' is set
      if @api_client.config.client_side_validation && command_id.nil?
        fail ArgumentError, "Missing the required parameter 'command_id' when calling GraphApi.graph_command_traverse_system"
      end
      # resource path
      local_var_path = '/commands/{command_id}/systems'.sub('{' + 'command_id' + '}', command_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_command_traverse_system\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the System Groups bound to a Command
    # This endpoint will return all System Groups bound to a Command, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Command to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this Command.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/commands/{Command_ID}/systemgroups \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param command_id ObjectID of the Command.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_command_traverse_system_group(command_id, opts = {})
      data, _status_code, _headers = graph_command_traverse_system_group_with_http_info(command_id, opts)
      data
    end

    # List the System Groups bound to a Command
    # This endpoint will return all System Groups bound to a Command, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group&#x27;s type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Command to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this Command.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/commands/{Command_ID}/systemgroups \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param command_id ObjectID of the Command.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_command_traverse_system_group_with_http_info(command_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_command_traverse_system_group ...'
      end
      # verify the required parameter 'command_id' is set
      if @api_client.config.client_side_validation && command_id.nil?
        fail ArgumentError, "Missing the required parameter 'command_id' when calling GraphApi.graph_command_traverse_system_group"
      end
      # resource path
      local_var_path = '/commands/{command_id}/systemgroups'.sub('{' + 'command_id' + '}', command_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_command_traverse_system_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of a G Suite instance
    # This endpoint returns the _direct_ associations of this G Suite instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example G Suite and Users.   #### Sample Request ``` curl -X GET 'https://console.jumpcloud.com/api/v2/gsuites/{Gsuite_ID}/associations?targets=user_group \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param gsuite_id ObjectID of the G Suite instance.
    # @param targets Targets which a \&quot;g_suite\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_g_suite_associations_list(gsuite_id, targets, opts = {})
      data, _status_code, _headers = graph_g_suite_associations_list_with_http_info(gsuite_id, targets, opts)
      data
    end

    # List the associations of a G Suite instance
    # This endpoint returns the _direct_ associations of this G Suite instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example G Suite and Users.   #### Sample Request &#x60;&#x60;&#x60; curl -X GET &#x27;https://console.jumpcloud.com/api/v2/gsuites/{Gsuite_ID}/associations?targets&#x3D;user_group \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param gsuite_id ObjectID of the G Suite instance.
    # @param targets Targets which a \&quot;g_suite\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_g_suite_associations_list_with_http_info(gsuite_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_g_suite_associations_list ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GraphApi.graph_g_suite_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_g_suite_associations_list"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/associations'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_g_suite_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of a G Suite instance
    # This endpoint returns the _direct_ associations of this G Suite instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example G Suite and Users.   #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/gsuites/{Gsuite_ID}/associations \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"user_group\",     \"id\": \"{Group_ID}\"   }' ```
    # @param gsuite_id ObjectID of the G Suite instance.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationGSuite] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_g_suite_associations_post(gsuite_id, opts = {})
      graph_g_suite_associations_post_with_http_info(gsuite_id, opts)
      nil
    end

    # Manage the associations of a G Suite instance
    # This endpoint returns the _direct_ associations of this G Suite instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example G Suite and Users.   #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/gsuites/{Gsuite_ID}/associations \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;user_group\&quot;,     \&quot;id\&quot;: \&quot;{Group_ID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param gsuite_id ObjectID of the G Suite instance.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationGSuite] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_g_suite_associations_post_with_http_info(gsuite_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_g_suite_associations_post ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GraphApi.graph_g_suite_associations_post"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/associations'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_g_suite_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Users bound to a G Suite instance
    # This endpoint will return all Users bound to a G Suite instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this G Suite instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this G Suite instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{Gsuite_ID}/users \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param gsuite_id ObjectID of the G Suite instance.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_g_suite_traverse_user(gsuite_id, opts = {})
      data, _status_code, _headers = graph_g_suite_traverse_user_with_http_info(gsuite_id, opts)
      data
    end

    # List the Users bound to a G Suite instance
    # This endpoint will return all Users bound to a G Suite instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this G Suite instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this G Suite instance.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60;   curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{Gsuite_ID}/users \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param gsuite_id ObjectID of the G Suite instance.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_g_suite_traverse_user_with_http_info(gsuite_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_g_suite_traverse_user ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GraphApi.graph_g_suite_traverse_user"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/users'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_g_suite_traverse_user\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the User Groups bound to a G Suite instance
    # This endpoint will return all User Groups bound to an G Suite instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this G Suite instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this G Suite instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{GSuite_ID}/usergroups \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param gsuite_id ObjectID of the G Suite instance.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_g_suite_traverse_user_group(gsuite_id, opts = {})
      data, _status_code, _headers = graph_g_suite_traverse_user_group_with_http_info(gsuite_id, opts)
      data
    end

    # List the User Groups bound to a G Suite instance
    # This endpoint will return all User Groups bound to an G Suite instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group&#x27;s type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this G Suite instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this G Suite instance.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60;   curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{GSuite_ID}/usergroups \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param gsuite_id ObjectID of the G Suite instance.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_g_suite_traverse_user_group_with_http_info(gsuite_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_g_suite_traverse_user_group ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GraphApi.graph_g_suite_traverse_user_group"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/usergroups'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_g_suite_traverse_user_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of a LDAP Server
    # This endpoint returns the _direct_ associations of this LDAP Server.  A direct association can be a non-homogeneous relationship between 2 different objects, for example LDAP and Users.  #### Sample Request  ```  curl -X GET 'https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/associations?targets=user_group \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param ldapserver_id ObjectID of the LDAP Server.
    # @param targets Targets which a \&quot;ldap_server\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_ldap_server_associations_list(ldapserver_id, targets, opts = {})
      data, _status_code, _headers = graph_ldap_server_associations_list_with_http_info(ldapserver_id, targets, opts)
      data
    end

    # List the associations of a LDAP Server
    # This endpoint returns the _direct_ associations of this LDAP Server.  A direct association can be a non-homogeneous relationship between 2 different objects, for example LDAP and Users.  #### Sample Request  &#x60;&#x60;&#x60;  curl -X GET &#x27;https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/associations?targets&#x3D;user_group \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param ldapserver_id ObjectID of the LDAP Server.
    # @param targets Targets which a \&quot;ldap_server\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_ldap_server_associations_list_with_http_info(ldapserver_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_ldap_server_associations_list ...'
      end
      # verify the required parameter 'ldapserver_id' is set
      if @api_client.config.client_side_validation && ldapserver_id.nil?
        fail ArgumentError, "Missing the required parameter 'ldapserver_id' when calling GraphApi.graph_ldap_server_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_ldap_server_associations_list"
      end
      # resource path
      local_var_path = '/ldapservers/{ldapserver_id}/associations'.sub('{' + 'ldapserver_id' + '}', ldapserver_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_ldap_server_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of a LDAP Server
    # This endpoint allows you to manage the _direct_ associations of a LDAP Server.  A direct association can be a non-homogeneous relationship between 2 different objects, for example LDAP and Users.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/associations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"user\",     \"id\": \"{User_ID}\"   }' ```
    # @param ldapserver_id ObjectID of the LDAP Server.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationLdapServer] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_ldap_server_associations_post(ldapserver_id, opts = {})
      graph_ldap_server_associations_post_with_http_info(ldapserver_id, opts)
      nil
    end

    # Manage the associations of a LDAP Server
    # This endpoint allows you to manage the _direct_ associations of a LDAP Server.  A direct association can be a non-homogeneous relationship between 2 different objects, for example LDAP and Users.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/associations \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;user\&quot;,     \&quot;id\&quot;: \&quot;{User_ID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param ldapserver_id ObjectID of the LDAP Server.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationLdapServer] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_ldap_server_associations_post_with_http_info(ldapserver_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_ldap_server_associations_post ...'
      end
      # verify the required parameter 'ldapserver_id' is set
      if @api_client.config.client_side_validation && ldapserver_id.nil?
        fail ArgumentError, "Missing the required parameter 'ldapserver_id' when calling GraphApi.graph_ldap_server_associations_post"
      end
      # resource path
      local_var_path = '/ldapservers/{ldapserver_id}/associations'.sub('{' + 'ldapserver_id' + '}', ldapserver_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_ldap_server_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Users bound to a LDAP Server
    # This endpoint will return all Users bound to an LDAP Server, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this LDAP server instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this LDAP server instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/users \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param ldapserver_id ObjectID of the LDAP Server.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_ldap_server_traverse_user(ldapserver_id, opts = {})
      data, _status_code, _headers = graph_ldap_server_traverse_user_with_http_info(ldapserver_id, opts)
      data
    end

    # List the Users bound to a LDAP Server
    # This endpoint will return all Users bound to an LDAP Server, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this LDAP server instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this LDAP server instance.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/users \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param ldapserver_id ObjectID of the LDAP Server.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_ldap_server_traverse_user_with_http_info(ldapserver_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_ldap_server_traverse_user ...'
      end
      # verify the required parameter 'ldapserver_id' is set
      if @api_client.config.client_side_validation && ldapserver_id.nil?
        fail ArgumentError, "Missing the required parameter 'ldapserver_id' when calling GraphApi.graph_ldap_server_traverse_user"
      end
      # resource path
      local_var_path = '/ldapservers/{ldapserver_id}/users'.sub('{' + 'ldapserver_id' + '}', ldapserver_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_ldap_server_traverse_user\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the User Groups bound to a LDAP Server
    # This endpoint will return all Users Groups bound to a LDAP Server, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this LDAP server instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this LDAP server instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/usergroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param ldapserver_id ObjectID of the LDAP Server.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_ldap_server_traverse_user_group(ldapserver_id, opts = {})
      data, _status_code, _headers = graph_ldap_server_traverse_user_group_with_http_info(ldapserver_id, opts)
      data
    end

    # List the User Groups bound to a LDAP Server
    # This endpoint will return all Users Groups bound to a LDAP Server, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group&#x27;s type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this LDAP server instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this LDAP server instance.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/usergroups \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param ldapserver_id ObjectID of the LDAP Server.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_ldap_server_traverse_user_group_with_http_info(ldapserver_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_ldap_server_traverse_user_group ...'
      end
      # verify the required parameter 'ldapserver_id' is set
      if @api_client.config.client_side_validation && ldapserver_id.nil?
        fail ArgumentError, "Missing the required parameter 'ldapserver_id' when calling GraphApi.graph_ldap_server_traverse_user_group"
      end
      # resource path
      local_var_path = '/ldapservers/{ldapserver_id}/usergroups'.sub('{' + 'ldapserver_id' + '}', ldapserver_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_ldap_server_traverse_user_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of an Office 365 instance
    # This endpoint returns _direct_ associations of an Office 365 instance.   A direct association can be a non-homogeneous relationship between 2 different objects, for example Office 365 and Users.  #### Sample Request ``` curl -X GET 'https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID}/associations?targets=user_group' \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param office365_id ObjectID of the Office 365 instance.
    # @param targets Targets which a \&quot;office_365\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_office365_associations_list(office365_id, targets, opts = {})
      data, _status_code, _headers = graph_office365_associations_list_with_http_info(office365_id, targets, opts)
      data
    end

    # List the associations of an Office 365 instance
    # This endpoint returns _direct_ associations of an Office 365 instance.   A direct association can be a non-homogeneous relationship between 2 different objects, for example Office 365 and Users.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET &#x27;https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID}/associations?targets&#x3D;user_group&#x27; \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param office365_id ObjectID of the Office 365 instance.
    # @param targets Targets which a \&quot;office_365\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_office365_associations_list_with_http_info(office365_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_office365_associations_list ...'
      end
      # verify the required parameter 'office365_id' is set
      if @api_client.config.client_side_validation && office365_id.nil?
        fail ArgumentError, "Missing the required parameter 'office365_id' when calling GraphApi.graph_office365_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_office365_associations_list"
      end
      # resource path
      local_var_path = '/office365s/{office365_id}/associations'.sub('{' + 'office365_id' + '}', office365_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_office365_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of an Office 365 instance
    # This endpoint allows you to manage the _direct_ associations of a Office 365 instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Office 365 and Users.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID}/associations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"user_group\",     \"id\": \"{Group_ID}\"   }' ```
    # @param office365_id ObjectID of the Office 365 instance.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationOffice365] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_office365_associations_post(office365_id, opts = {})
      graph_office365_associations_post_with_http_info(office365_id, opts)
      nil
    end

    # Manage the associations of an Office 365 instance
    # This endpoint allows you to manage the _direct_ associations of a Office 365 instance.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Office 365 and Users.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID}/associations \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;user_group\&quot;,     \&quot;id\&quot;: \&quot;{Group_ID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param office365_id ObjectID of the Office 365 instance.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationOffice365] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_office365_associations_post_with_http_info(office365_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_office365_associations_post ...'
      end
      # verify the required parameter 'office365_id' is set
      if @api_client.config.client_side_validation && office365_id.nil?
        fail ArgumentError, "Missing the required parameter 'office365_id' when calling GraphApi.graph_office365_associations_post"
      end
      # resource path
      local_var_path = '/office365s/{office365_id}/associations'.sub('{' + 'office365_id' + '}', office365_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_office365_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Users bound to an Office 365 instance
    # This endpoint will return all Users bound to an Office 365 instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Office 365 instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this Office 365 instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID}/users \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param office365_id ObjectID of the Office 365 suite.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_office365_traverse_user(office365_id, opts = {})
      data, _status_code, _headers = graph_office365_traverse_user_with_http_info(office365_id, opts)
      data
    end

    # List the Users bound to an Office 365 instance
    # This endpoint will return all Users bound to an Office 365 instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Office 365 instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this Office 365 instance.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID}/users \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param office365_id ObjectID of the Office 365 suite.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_office365_traverse_user_with_http_info(office365_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_office365_traverse_user ...'
      end
      # verify the required parameter 'office365_id' is set
      if @api_client.config.client_side_validation && office365_id.nil?
        fail ArgumentError, "Missing the required parameter 'office365_id' when calling GraphApi.graph_office365_traverse_user"
      end
      # resource path
      local_var_path = '/office365s/{office365_id}/users'.sub('{' + 'office365_id' + '}', office365_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_office365_traverse_user\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the User Groups bound to an Office 365 instance
    # This endpoint will return all Users Groups bound to an Office 365 instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Office 365 instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this Office 365 instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ```   curl -X GET https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID/usergroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param office365_id ObjectID of the Office 365 suite.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_office365_traverse_user_group(office365_id, opts = {})
      data, _status_code, _headers = graph_office365_traverse_user_group_with_http_info(office365_id, opts)
      data
    end

    # List the User Groups bound to an Office 365 instance
    # This endpoint will return all Users Groups bound to an Office 365 instance, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group&#x27;s type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Office 365 instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this Office 365 instance.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60;   curl -X GET https://console.jumpcloud.com/api/v2/office365s/{OFFICE365_ID/usergroups \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param office365_id ObjectID of the Office 365 suite.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_office365_traverse_user_group_with_http_info(office365_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_office365_traverse_user_group ...'
      end
      # verify the required parameter 'office365_id' is set
      if @api_client.config.client_side_validation && office365_id.nil?
        fail ArgumentError, "Missing the required parameter 'office365_id' when calling GraphApi.graph_office365_traverse_user_group"
      end
      # resource path
      local_var_path = '/office365s/{office365_id}/usergroups'.sub('{' + 'office365_id' + '}', office365_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_office365_traverse_user_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of a Policy
    # This endpoint returns the _direct_ associations of a Policy.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Policies and Systems.  #### Sample Request ``` curl -X GET 'https://console.jumpcloud.com/api/v2/policies/{Policy_ID}/associations?targets=system_group \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param policy_id ObjectID of the Policy.
    # @param targets Targets which a \&quot;policy\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_policy_associations_list(policy_id, targets, opts = {})
      data, _status_code, _headers = graph_policy_associations_list_with_http_info(policy_id, targets, opts)
      data
    end

    # List the associations of a Policy
    # This endpoint returns the _direct_ associations of a Policy.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Policies and Systems.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET &#x27;https://console.jumpcloud.com/api/v2/policies/{Policy_ID}/associations?targets&#x3D;system_group \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param policy_id ObjectID of the Policy.
    # @param targets Targets which a \&quot;policy\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_policy_associations_list_with_http_info(policy_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_policy_associations_list ...'
      end
      # verify the required parameter 'policy_id' is set
      if @api_client.config.client_side_validation && policy_id.nil?
        fail ArgumentError, "Missing the required parameter 'policy_id' when calling GraphApi.graph_policy_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_policy_associations_list"
      end
      # resource path
      local_var_path = '/policies/{policy_id}/associations'.sub('{' + 'policy_id' + '}', policy_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_policy_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of a Policy
    # This endpoint allows you to manage the _direct_ associations of a Policy.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Policies and Systems.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/policies/{Policy_ID}/associations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"system_group\",     \"id\": \"{Group_ID}\"   }' ```
    # @param policy_id ObjectID of the Policy.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationPolicy] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_policy_associations_post(policy_id, opts = {})
      graph_policy_associations_post_with_http_info(policy_id, opts)
      nil
    end

    # Manage the associations of a Policy
    # This endpoint allows you to manage the _direct_ associations of a Policy.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Policies and Systems.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/policies/{Policy_ID}/associations/ \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;system_group\&quot;,     \&quot;id\&quot;: \&quot;{Group_ID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param policy_id ObjectID of the Policy.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationPolicy] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_policy_associations_post_with_http_info(policy_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_policy_associations_post ...'
      end
      # verify the required parameter 'policy_id' is set
      if @api_client.config.client_side_validation && policy_id.nil?
        fail ArgumentError, "Missing the required parameter 'policy_id' when calling GraphApi.graph_policy_associations_post"
      end
      # resource path
      local_var_path = '/policies/{policy_id}/associations'.sub('{' + 'policy_id' + '}', policy_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_policy_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of a Policy Group.
    # This endpoint returns the _direct_ associations of this Policy Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Policy Groups and Policies.   #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/associations?targets=system \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the Policy Group.
    # @param targets Targets which a \&quot;policy_group\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_policy_group_associations_list(group_id, targets, opts = {})
      data, _status_code, _headers = graph_policy_group_associations_list_with_http_info(group_id, targets, opts)
      data
    end

    # List the associations of a Policy Group.
    # This endpoint returns the _direct_ associations of this Policy Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Policy Groups and Policies.   #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/associations?targets&#x3D;system \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the Policy Group.
    # @param targets Targets which a \&quot;policy_group\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_policy_group_associations_list_with_http_info(group_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_policy_group_associations_list ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_policy_group_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_policy_group_associations_list"
      end
      # resource path
      local_var_path = '/policygroups/{group_id}/associations'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_policy_group_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of a Policy Group
    # This endpoint manages the _direct_ associations of this Policy Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Policy Groups and Policies.   #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/associations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"system\",     \"id\": \"{SystemID}\"   }' ```
    # @param group_id ObjectID of the Policy Group.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationPolicyGroup] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_policy_group_associations_post(group_id, opts = {})
      graph_policy_group_associations_post_with_http_info(group_id, opts)
      nil
    end

    # Manage the associations of a Policy Group
    # This endpoint manages the _direct_ associations of this Policy Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Policy Groups and Policies.   #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/associations \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;system\&quot;,     \&quot;id\&quot;: \&quot;{SystemID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the Policy Group.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationPolicyGroup] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_policy_group_associations_post_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_policy_group_associations_post ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_policy_group_associations_post"
      end
      # resource path
      local_var_path = '/policygroups/{group_id}/associations'.sub('{' + 'group_id' + '}', group_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_policy_group_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the members of a Policy Group
    # This endpoint returns the Policy members of a Policy Group.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/members \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the Policy Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_policy_group_members_list(group_id, opts = {})
      data, _status_code, _headers = graph_policy_group_members_list_with_http_info(group_id, opts)
      data
    end

    # List the members of a Policy Group
    # This endpoint returns the Policy members of a Policy Group.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/members \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the Policy Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_policy_group_members_list_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_policy_group_members_list ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_policy_group_members_list"
      end
      # resource path
      local_var_path = '/policygroups/{group_id}/members'.sub('{' + 'group_id' + '}', group_id.to_s)

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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_policy_group_members_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the members of a Policy Group
    # This endpoint allows you to manage the Policy members of a Policy Group.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/members \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"policy\",     \"id\": \"{Policy_ID}\"   }' ```
    # @param group_id ObjectID of the Policy Group.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationPolicyGroupMember] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_policy_group_members_post(group_id, opts = {})
      graph_policy_group_members_post_with_http_info(group_id, opts)
      nil
    end

    # Manage the members of a Policy Group
    # This endpoint allows you to manage the Policy members of a Policy Group.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/members \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;policy\&quot;,     \&quot;id\&quot;: \&quot;{Policy_ID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the Policy Group.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationPolicyGroupMember] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_policy_group_members_post_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_policy_group_members_post ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_policy_group_members_post"
      end
      # resource path
      local_var_path = '/policygroups/{group_id}/members'.sub('{' + 'group_id' + '}', group_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_policy_group_members_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Policy Group's membership
    # This endpoint returns all Policy members that are a member of this Policy Group.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/membership \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the Policy Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphObjectWithPaths>]
    def graph_policy_group_membership(group_id, opts = {})
      data, _status_code, _headers = graph_policy_group_membership_with_http_info(group_id, opts)
      data
    end

    # List the Policy Group&#x27;s membership
    # This endpoint returns all Policy members that are a member of this Policy Group.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/membership \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the Policy Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_policy_group_membership_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_policy_group_membership ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_policy_group_membership"
      end
      # resource path
      local_var_path = '/policygroups/{group_id}/membership'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_policy_group_membership\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Systems bound to a Policy Group
    # This endpoint will return all Systems bound to a Policy Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Policy Group to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this Policy Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the Policy Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_policy_group_traverse_system(group_id, opts = {})
      data, _status_code, _headers = graph_policy_group_traverse_system_with_http_info(group_id, opts)
      data
    end

    # List the Systems bound to a Policy Group
    # This endpoint will return all Systems bound to a Policy Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Policy Group to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this Policy Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/systems \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the Policy Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_policy_group_traverse_system_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_policy_group_traverse_system ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_policy_group_traverse_system"
      end
      # resource path
      local_var_path = '/policygroups/{group_id}/systems'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_policy_group_traverse_system\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the System Groups bound to Policy Groups
    # This endpoint will return all System Groups bound to a Policy Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Policy Group to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this Policy Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/systemgroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the Policy Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_policy_group_traverse_system_group(group_id, opts = {})
      data, _status_code, _headers = graph_policy_group_traverse_system_group_with_http_info(group_id, opts)
      data
    end

    # List the System Groups bound to Policy Groups
    # This endpoint will return all System Groups bound to a Policy Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Policy Group to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this Policy Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/policygroups/{GroupID}/systemgroups \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the Policy Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_policy_group_traverse_system_group_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_policy_group_traverse_system_group ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_policy_group_traverse_system_group"
      end
      # resource path
      local_var_path = '/policygroups/{group_id}/systemgroups'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_policy_group_traverse_system_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the parent Groups of a Policy
    # This endpoint returns all the Policy Groups a Policy is a member of.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/policies/{Policy_ID}/memberof \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param policy_id ObjectID of the Policy.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphObjectWithPaths>]
    def graph_policy_member_of(policy_id, opts = {})
      data, _status_code, _headers = graph_policy_member_of_with_http_info(policy_id, opts)
      data
    end

    # List the parent Groups of a Policy
    # This endpoint returns all the Policy Groups a Policy is a member of.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/policies/{Policy_ID}/memberof \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param policy_id ObjectID of the Policy.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_policy_member_of_with_http_info(policy_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_policy_member_of ...'
      end
      # verify the required parameter 'policy_id' is set
      if @api_client.config.client_side_validation && policy_id.nil?
        fail ArgumentError, "Missing the required parameter 'policy_id' when calling GraphApi.graph_policy_member_of"
      end
      # resource path
      local_var_path = '/policies/{policy_id}/memberof'.sub('{' + 'policy_id' + '}', policy_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'Date'] = opts[:'date'] if !opts[:'date'].nil?
      header_params[:'Authorization'] = opts[:'authorization'] if !opts[:'authorization'].nil?
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_policy_member_of\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Systems bound to a Policy
    # This endpoint will return all Systems bound to a Policy, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Policy to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this Policy.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/policies/{Policy_ID}/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param policy_id ObjectID of the Command.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_policy_traverse_system(policy_id, opts = {})
      data, _status_code, _headers = graph_policy_traverse_system_with_http_info(policy_id, opts)
      data
    end

    # List the Systems bound to a Policy
    # This endpoint will return all Systems bound to a Policy, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Policy to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this Policy.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/policies/{Policy_ID}/systems \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param policy_id ObjectID of the Command.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_policy_traverse_system_with_http_info(policy_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_policy_traverse_system ...'
      end
      # verify the required parameter 'policy_id' is set
      if @api_client.config.client_side_validation && policy_id.nil?
        fail ArgumentError, "Missing the required parameter 'policy_id' when calling GraphApi.graph_policy_traverse_system"
      end
      # resource path
      local_var_path = '/policies/{policy_id}/systems'.sub('{' + 'policy_id' + '}', policy_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_policy_traverse_system\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the System Groups bound to a Policy
    # This endpoint will return all Systems Groups bound to a Policy, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Policy to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this Policy.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET  https://console.jumpcloud.com/api/v2/policies/{Policy_ID}/systemgroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param policy_id ObjectID of the Command.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_policy_traverse_system_group(policy_id, opts = {})
      data, _status_code, _headers = graph_policy_traverse_system_group_with_http_info(policy_id, opts)
      data
    end

    # List the System Groups bound to a Policy
    # This endpoint will return all Systems Groups bound to a Policy, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group&#x27;s type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Policy to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this Policy.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET  https://console.jumpcloud.com/api/v2/policies/{Policy_ID}/systemgroups \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param policy_id ObjectID of the Command.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_policy_traverse_system_group_with_http_info(policy_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_policy_traverse_system_group ...'
      end
      # verify the required parameter 'policy_id' is set
      if @api_client.config.client_side_validation && policy_id.nil?
        fail ArgumentError, "Missing the required parameter 'policy_id' when calling GraphApi.graph_policy_traverse_system_group"
      end
      # resource path
      local_var_path = '/policies/{policy_id}/systemgroups'.sub('{' + 'policy_id' + '}', policy_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_policy_traverse_system_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of a RADIUS  Server
    # This endpoint returns the _direct_ associations of a Radius Server.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Radius Servers and Users.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/radiusservers/{RADIUS_ID}/associations?targets=user_group \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param radiusserver_id ObjectID of the Radius Server.
    # @param targets Targets which a \&quot;radius_server\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_radius_server_associations_list(radiusserver_id, targets, opts = {})
      data, _status_code, _headers = graph_radius_server_associations_list_with_http_info(radiusserver_id, targets, opts)
      data
    end

    # List the associations of a RADIUS  Server
    # This endpoint returns the _direct_ associations of a Radius Server.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Radius Servers and Users.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/radiusservers/{RADIUS_ID}/associations?targets&#x3D;user_group \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param radiusserver_id ObjectID of the Radius Server.
    # @param targets Targets which a \&quot;radius_server\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_radius_server_associations_list_with_http_info(radiusserver_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_radius_server_associations_list ...'
      end
      # verify the required parameter 'radiusserver_id' is set
      if @api_client.config.client_side_validation && radiusserver_id.nil?
        fail ArgumentError, "Missing the required parameter 'radiusserver_id' when calling GraphApi.graph_radius_server_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_radius_server_associations_list"
      end
      # resource path
      local_var_path = '/radiusservers/{radiusserver_id}/associations'.sub('{' + 'radiusserver_id' + '}', radiusserver_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_radius_server_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of a RADIUS Server
    # This endpoint allows you to manage the _direct_ associations of a Radius Server.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Radius Servers and Users.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/radiusservers/{RADIUS_ID}/associations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"type\":\"user\",  \"id\":\"{USER_ID}\",  \"op\":\"add\"   }' ```
    # @param radiusserver_id ObjectID of the Radius Server.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationRadiusServer] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_radius_server_associations_post(radiusserver_id, opts = {})
      graph_radius_server_associations_post_with_http_info(radiusserver_id, opts)
      nil
    end

    # Manage the associations of a RADIUS Server
    # This endpoint allows you to manage the _direct_ associations of a Radius Server.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Radius Servers and Users.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/radiusservers/{RADIUS_ID}/associations \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;type\&quot;:\&quot;user\&quot;,  \&quot;id\&quot;:\&quot;{USER_ID}\&quot;,  \&quot;op\&quot;:\&quot;add\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param radiusserver_id ObjectID of the Radius Server.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationRadiusServer] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_radius_server_associations_post_with_http_info(radiusserver_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_radius_server_associations_post ...'
      end
      # verify the required parameter 'radiusserver_id' is set
      if @api_client.config.client_side_validation && radiusserver_id.nil?
        fail ArgumentError, "Missing the required parameter 'radiusserver_id' when calling GraphApi.graph_radius_server_associations_post"
      end
      # resource path
      local_var_path = '/radiusservers/{radiusserver_id}/associations'.sub('{' + 'radiusserver_id' + '}', radiusserver_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_radius_server_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Users bound to a RADIUS  Server
    # This endpoint will return all Users bound to a RADIUS Server, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this RADIUS server instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this RADIUS server instance.  See `/members` and `/associations` endpoints to manage those collections.   #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/users \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```
    # @param radiusserver_id ObjectID of the Radius Server.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_radius_server_traverse_user(radiusserver_id, opts = {})
      data, _status_code, _headers = graph_radius_server_traverse_user_with_http_info(radiusserver_id, opts)
      data
    end

    # List the Users bound to a RADIUS  Server
    # This endpoint will return all Users bound to a RADIUS Server, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this RADIUS server instance to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this RADIUS server instance.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.   #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/ldapservers/{LDAP_ID}/users \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;   &#x60;&#x60;&#x60;
    # @param radiusserver_id ObjectID of the Radius Server.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_radius_server_traverse_user_with_http_info(radiusserver_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_radius_server_traverse_user ...'
      end
      # verify the required parameter 'radiusserver_id' is set
      if @api_client.config.client_side_validation && radiusserver_id.nil?
        fail ArgumentError, "Missing the required parameter 'radiusserver_id' when calling GraphApi.graph_radius_server_traverse_user"
      end
      # resource path
      local_var_path = '/radiusservers/{radiusserver_id}/users'.sub('{' + 'radiusserver_id' + '}', radiusserver_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_radius_server_traverse_user\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the User Groups bound to a RADIUS  Server
    # This endpoint will return all Users Groups bound to a RADIUS Server, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this RADIUS server instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this RADIUS server instance.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/radiusservers/{RADIUS_ID}/usergroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param radiusserver_id ObjectID of the Radius Server.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_radius_server_traverse_user_group(radiusserver_id, opts = {})
      data, _status_code, _headers = graph_radius_server_traverse_user_group_with_http_info(radiusserver_id, opts)
      data
    end

    # List the User Groups bound to a RADIUS  Server
    # This endpoint will return all Users Groups bound to a RADIUS Server, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group&#x27;s type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this RADIUS server instance to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this RADIUS server instance.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/radiusservers/{RADIUS_ID}/usergroups \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param radiusserver_id ObjectID of the Radius Server.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_radius_server_traverse_user_group_with_http_info(radiusserver_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_radius_server_traverse_user_group ...'
      end
      # verify the required parameter 'radiusserver_id' is set
      if @api_client.config.client_side_validation && radiusserver_id.nil?
        fail ArgumentError, "Missing the required parameter 'radiusserver_id' when calling GraphApi.graph_radius_server_traverse_user_group"
      end
      # resource path
      local_var_path = '/radiusservers/{radiusserver_id}/usergroups'.sub('{' + 'radiusserver_id' + '}', radiusserver_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_radius_server_traverse_user_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of a Software Application
    # This endpoint will return the _direct_ associations of a Software Application. A direct association can be a non-homogeneous relationship between 2 different objects, for example Software Application and System Groups.   #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/associations?targets=system_group \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param software_app_id ObjectID of the Software App.
    # @param targets Targets which a \&quot;software_app\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_softwareapps_associations_list(software_app_id, targets, opts = {})
      data, _status_code, _headers = graph_softwareapps_associations_list_with_http_info(software_app_id, targets, opts)
      data
    end

    # List the associations of a Software Application
    # This endpoint will return the _direct_ associations of a Software Application. A direct association can be a non-homogeneous relationship between 2 different objects, for example Software Application and System Groups.   #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/associations?targets&#x3D;system_group \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param software_app_id ObjectID of the Software App.
    # @param targets Targets which a \&quot;software_app\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_softwareapps_associations_list_with_http_info(software_app_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_softwareapps_associations_list ...'
      end
      # verify the required parameter 'software_app_id' is set
      if @api_client.config.client_side_validation && software_app_id.nil?
        fail ArgumentError, "Missing the required parameter 'software_app_id' when calling GraphApi.graph_softwareapps_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_softwareapps_associations_list"
      end
      # resource path
      local_var_path = '/softwareapps/{software_app_id}/associations'.sub('{' + 'software_app_id' + '}', software_app_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_softwareapps_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of a software application.
    # This endpoint allows you to associate or disassociate a software application to a system or system group.  #### Sample Request ``` $ curl -X POST https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/associations \\ -H 'Accept: application/json' \\ -H 'Content-Type: application/json' \\ -H 'x-api-key: {API_KEY}' \\ -d '{   \"id\": \"<object_id>\",   \"op\": \"add\",   \"type\": \"system\"  }' ```
    # @param software_app_id ObjectID of the Software App.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationSoftwareApp] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_softwareapps_associations_post(software_app_id, opts = {})
      graph_softwareapps_associations_post_with_http_info(software_app_id, opts)
      nil
    end

    # Manage the associations of a software application.
    # This endpoint allows you to associate or disassociate a software application to a system or system group.  #### Sample Request &#x60;&#x60;&#x60; $ curl -X POST https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/associations \\ -H &#x27;Accept: application/json&#x27; \\ -H &#x27;Content-Type: application/json&#x27; \\ -H &#x27;x-api-key: {API_KEY}&#x27; \\ -d &#x27;{   \&quot;id\&quot;: \&quot;&lt;object_id&gt;\&quot;,   \&quot;op\&quot;: \&quot;add\&quot;,   \&quot;type\&quot;: \&quot;system\&quot;  }&#x27; &#x60;&#x60;&#x60;
    # @param software_app_id ObjectID of the Software App.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationSoftwareApp] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_softwareapps_associations_post_with_http_info(software_app_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_softwareapps_associations_post ...'
      end
      # verify the required parameter 'software_app_id' is set
      if @api_client.config.client_side_validation && software_app_id.nil?
        fail ArgumentError, "Missing the required parameter 'software_app_id' when calling GraphApi.graph_softwareapps_associations_post"
      end
      # resource path
      local_var_path = '/softwareapps/{software_app_id}/associations'.sub('{' + 'software_app_id' + '}', software_app_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_softwareapps_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Systems bound to a Software App.
    # This endpoint will return all Systems bound to a Software App, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Software App to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this Software App.  See `/associations` endpoint to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param software_app_id ObjectID of the Software App.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_softwareapps_traverse_system(software_app_id, opts = {})
      data, _status_code, _headers = graph_softwareapps_traverse_system_with_http_info(software_app_id, opts)
      data
    end

    # List the Systems bound to a Software App.
    # This endpoint will return all Systems bound to a Software App, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Software App to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this Software App.  See &#x60;/associations&#x60; endpoint to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/systems \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param software_app_id ObjectID of the Software App.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_softwareapps_traverse_system_with_http_info(software_app_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_softwareapps_traverse_system ...'
      end
      # verify the required parameter 'software_app_id' is set
      if @api_client.config.client_side_validation && software_app_id.nil?
        fail ArgumentError, "Missing the required parameter 'software_app_id' when calling GraphApi.graph_softwareapps_traverse_system"
      end
      # resource path
      local_var_path = '/softwareapps/{software_app_id}/systems'.sub('{' + 'software_app_id' + '}', software_app_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_softwareapps_traverse_system\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the System Groups bound to a Software App.
    # This endpoint will return all Systems Groups bound to a Software App, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this Software App to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this Software App.  See `/associations` endpoint to manage those collections.  #### Sample Request ``` curl -X GET  https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/systemgroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param software_app_id ObjectID of the Software App.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_softwareapps_traverse_system_group(software_app_id, opts = {})
      data, _status_code, _headers = graph_softwareapps_traverse_system_group_with_http_info(software_app_id, opts)
      data
    end

    # List the System Groups bound to a Software App.
    # This endpoint will return all Systems Groups bound to a Software App, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group&#x27;s type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this Software App to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this Software App.  See &#x60;/associations&#x60; endpoint to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET  https://console.jumpcloud.com/api/v2/softwareapps/{software_app_id}/systemgroups \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param software_app_id ObjectID of the Software App.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_softwareapps_traverse_system_group_with_http_info(software_app_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_softwareapps_traverse_system_group ...'
      end
      # verify the required parameter 'software_app_id' is set
      if @api_client.config.client_side_validation && software_app_id.nil?
        fail ArgumentError, "Missing the required parameter 'software_app_id' when calling GraphApi.graph_softwareapps_traverse_system_group"
      end
      # resource path
      local_var_path = '/softwareapps/{software_app_id}/systemgroups'.sub('{' + 'software_app_id' + '}', software_app_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_softwareapps_traverse_system_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of a System
    # This endpoint returns the _direct_ associations of a System.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Systems and Users.   #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/associations?targets=user \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param system_id ObjectID of the System.
    # @param targets Targets which a \&quot;system\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_system_associations_list(system_id, targets, opts = {})
      data, _status_code, _headers = graph_system_associations_list_with_http_info(system_id, targets, opts)
      data
    end

    # List the associations of a System
    # This endpoint returns the _direct_ associations of a System.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Systems and Users.   #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/associations?targets&#x3D;user \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param system_id ObjectID of the System.
    # @param targets Targets which a \&quot;system\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_system_associations_list_with_http_info(system_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_associations_list ...'
      end
      # verify the required parameter 'system_id' is set
      if @api_client.config.client_side_validation && system_id.nil?
        fail ArgumentError, "Missing the required parameter 'system_id' when calling GraphApi.graph_system_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_system_associations_list"
      end
      # resource path
      local_var_path = '/systems/{system_id}/associations'.sub('{' + 'system_id' + '}', system_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'Date'] = opts[:'date'] if !opts[:'date'].nil?
      header_params[:'Authorization'] = opts[:'authorization'] if !opts[:'authorization'].nil?
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage associations of a System
    # This endpoint allows you to manage the _direct_ associations of a System.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Systems and Users.   #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/systems/{System_ID}/associations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"attributes\": {       \"sudo\": {         \"enabled\": true,         \"withoutPassword\": false       }     },     \"op\": \"add\",     \"type\": \"user\",     \"id\": \"UserID\"   }' ```
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationSystem] :body 
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_system_associations_post(system_id, opts = {})
      graph_system_associations_post_with_http_info(system_id, opts)
      nil
    end

    # Manage associations of a System
    # This endpoint allows you to manage the _direct_ associations of a System.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Systems and Users.   #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/systems/{System_ID}/associations \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;attributes\&quot;: {       \&quot;sudo\&quot;: {         \&quot;enabled\&quot;: true,         \&quot;withoutPassword\&quot;: false       }     },     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;user\&quot;,     \&quot;id\&quot;: \&quot;UserID\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationSystem] :body 
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_system_associations_post_with_http_info(system_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_associations_post ...'
      end
      # verify the required parameter 'system_id' is set
      if @api_client.config.client_side_validation && system_id.nil?
        fail ArgumentError, "Missing the required parameter 'system_id' when calling GraphApi.graph_system_associations_post"
      end
      # resource path
      local_var_path = '/systems/{system_id}/associations'.sub('{' + 'system_id' + '}', system_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'Date'] = opts[:'date'] if !opts[:'date'].nil?
      header_params[:'Authorization'] = opts[:'authorization'] if !opts[:'authorization'].nil?
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
        @api_client.config.logger.debug "API called: GraphApi#graph_system_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of a System Group
    # This endpoint returns the _direct_ associations of a System Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example System Groups and Users.   #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/associations?targets=user \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the System Group.
    # @param targets Targets which a \&quot;system_group\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_system_group_associations_list(group_id, targets, opts = {})
      data, _status_code, _headers = graph_system_group_associations_list_with_http_info(group_id, targets, opts)
      data
    end

    # List the associations of a System Group
    # This endpoint returns the _direct_ associations of a System Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example System Groups and Users.   #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/associations?targets&#x3D;user \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the System Group.
    # @param targets Targets which a \&quot;system_group\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_system_group_associations_list_with_http_info(group_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_group_associations_list ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_system_group_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_system_group_associations_list"
      end
      # resource path
      local_var_path = '/systemgroups/{group_id}/associations'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_group_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of a System Group
    # This endpoint allows you to manage the _direct_ associations of a System Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example System Groups and Users.   #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/associations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"user\",     \"id\": \"{UserID}\"   }' ```
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationSystemGroup] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_system_group_associations_post(group_id, opts = {})
      graph_system_group_associations_post_with_http_info(group_id, opts)
      nil
    end

    # Manage the associations of a System Group
    # This endpoint allows you to manage the _direct_ associations of a System Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example System Groups and Users.   #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/associations \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;user\&quot;,     \&quot;id\&quot;: \&quot;{UserID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationSystemGroup] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_system_group_associations_post_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_group_associations_post ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_system_group_associations_post"
      end
      # resource path
      local_var_path = '/systemgroups/{group_id}/associations'.sub('{' + 'group_id' + '}', group_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_system_group_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the members of a System Group
    # This endpoint returns the system members of a System Group.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{Group_ID}/members \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_system_group_members_list(group_id, opts = {})
      data, _status_code, _headers = graph_system_group_members_list_with_http_info(group_id, opts)
      data
    end

    # List the members of a System Group
    # This endpoint returns the system members of a System Group.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{Group_ID}/members \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_system_group_members_list_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_group_members_list ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_system_group_members_list"
      end
      # resource path
      local_var_path = '/systemgroups/{group_id}/members'.sub('{' + 'group_id' + '}', group_id.to_s)

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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_group_members_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the members of a System Group
    # This endpoint allows you to manage the system members of a System Group.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/systemgroups/{Group_ID}/members \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"system\",     \"id\": \"{System_ID}\"   }' ```
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationSystemGroupMember] :body 
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_system_group_members_post(group_id, opts = {})
      graph_system_group_members_post_with_http_info(group_id, opts)
      nil
    end

    # Manage the members of a System Group
    # This endpoint allows you to manage the system members of a System Group.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/systemgroups/{Group_ID}/members \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;system\&quot;,     \&quot;id\&quot;: \&quot;{System_ID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationSystemGroupMember] :body 
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_system_group_members_post_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_group_members_post ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_system_group_members_post"
      end
      # resource path
      local_var_path = '/systemgroups/{group_id}/members'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'Date'] = opts[:'date'] if !opts[:'date'].nil?
      header_params[:'Authorization'] = opts[:'authorization'] if !opts[:'authorization'].nil?
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
        @api_client.config.logger.debug "API called: GraphApi#graph_system_group_members_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the System Group's membership
    # This endpoint returns all Systems that are a member of this System Group.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{Group_ID/membership \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphObjectWithPaths>]
    def graph_system_group_membership(group_id, opts = {})
      data, _status_code, _headers = graph_system_group_membership_with_http_info(group_id, opts)
      data
    end

    # List the System Group&#x27;s membership
    # This endpoint returns all Systems that are a member of this System Group.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{Group_ID/membership \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_system_group_membership_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_group_membership ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_system_group_membership"
      end
      # resource path
      local_var_path = '/systemgroups/{group_id}/membership'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_group_membership\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Commands bound to a System Group
    # This endpoint will return all Commands bound to a System Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group's type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this System Group to the corresponding Command; this array represents all grouping and/or associations that would have to be removed to deprovision the Command from this System Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/commands \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_system_group_traverse_command(group_id, opts = {})
      data, _status_code, _headers = graph_system_group_traverse_command_with_http_info(group_id, opts)
      data
    end

    # List the Commands bound to a System Group
    # This endpoint will return all Commands bound to a System Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the group&#x27;s type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this System Group to the corresponding Command; this array represents all grouping and/or associations that would have to be removed to deprovision the Command from this System Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/commands \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_system_group_traverse_command_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_group_traverse_command ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_system_group_traverse_command"
      end
      # resource path
      local_var_path = '/systemgroups/{group_id}/commands'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_group_traverse_command\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Policies bound to a System Group
    # This endpoint will return all Policies bound to a System Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this System Group to the corresponding Policy; this array represents all grouping and/or associations that would have to be removed to deprovision the Policy from this System Group.  See `/members` and `/associations` endpoints to manage those collections.  This endpoint is not public yet as we haven't finished the code.  ##### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/policies \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_system_group_traverse_policy(group_id, opts = {})
      data, _status_code, _headers = graph_system_group_traverse_policy_with_http_info(group_id, opts)
      data
    end

    # List the Policies bound to a System Group
    # This endpoint will return all Policies bound to a System Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this System Group to the corresponding Policy; this array represents all grouping and/or associations that would have to be removed to deprovision the Policy from this System Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  This endpoint is not public yet as we haven&#x27;t finished the code.  ##### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/policies \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_system_group_traverse_policy_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_group_traverse_policy ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_system_group_traverse_policy"
      end
      # resource path
      local_var_path = '/systemgroups/{group_id}/policies'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_group_traverse_policy\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Policy Groups bound to a System Group
    # This endpoint will return all Policy Groups bound to a System Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this System Group to the corresponding Policy Group; this array represents all grouping and/or associations that would have to be removed to deprovision the Policy Group from this System Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/policygroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_system_group_traverse_policy_group(group_id, opts = {})
      data, _status_code, _headers = graph_system_group_traverse_policy_group_with_http_info(group_id, opts)
      data
    end

    # List the Policy Groups bound to a System Group
    # This endpoint will return all Policy Groups bound to a System Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this System Group to the corresponding Policy Group; this array represents all grouping and/or associations that would have to be removed to deprovision the Policy Group from this System Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/policygroups \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_system_group_traverse_policy_group_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_group_traverse_policy_group ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_system_group_traverse_policy_group"
      end
      # resource path
      local_var_path = '/systemgroups/{group_id}/policygroups'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_group_traverse_policy_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Users bound to a System Group
    # This endpoint will return all Users bound to a System Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this System Group to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this System Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/users \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_system_group_traverse_user(group_id, opts = {})
      data, _status_code, _headers = graph_system_group_traverse_user_with_http_info(group_id, opts)
      data
    end

    # List the Users bound to a System Group
    # This endpoint will return all Users bound to a System Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this System Group to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this System Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/users \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_system_group_traverse_user_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_group_traverse_user ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_system_group_traverse_user"
      end
      # resource path
      local_var_path = '/systemgroups/{group_id}/users'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_group_traverse_user\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the User Groups bound to a System Group
    # This endpoint will return all User Groups bound to a System Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this System Group to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this System Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/usergroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_system_group_traverse_user_group(group_id, opts = {})
      data, _status_code, _headers = graph_system_group_traverse_user_group_with_http_info(group_id, opts)
      data
    end

    # List the User Groups bound to a System Group
    # This endpoint will return all User Groups bound to a System Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this System Group to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this System Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systemgroups/{GroupID}/usergroups \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the System Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_system_group_traverse_user_group_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_group_traverse_user_group ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_system_group_traverse_user_group"
      end
      # resource path
      local_var_path = '/systemgroups/{group_id}/usergroups'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_group_traverse_user_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the parent Groups of a System
    # This endpoint returns all the System Groups a System is a member of.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/memberof \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphObjectWithPaths>]
    def graph_system_member_of(system_id, opts = {})
      data, _status_code, _headers = graph_system_member_of_with_http_info(system_id, opts)
      data
    end

    # List the parent Groups of a System
    # This endpoint returns all the System Groups a System is a member of.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/memberof \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_system_member_of_with_http_info(system_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_member_of ...'
      end
      # verify the required parameter 'system_id' is set
      if @api_client.config.client_side_validation && system_id.nil?
        fail ArgumentError, "Missing the required parameter 'system_id' when calling GraphApi.graph_system_member_of"
      end
      # resource path
      local_var_path = '/systems/{system_id}/memberof'.sub('{' + 'system_id' + '}', system_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'Date'] = opts[:'date'] if !opts[:'date'].nil?
      header_params[:'Authorization'] = opts[:'authorization'] if !opts[:'authorization'].nil?
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_member_of\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Commands bound to a System
    # This endpoint will return all Commands bound to a System, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this System to the corresponding Command; this array represents all grouping and/or associations that would have to be removed to deprovision the Command from this System.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/commands \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_system_traverse_command(system_id, opts = {})
      data, _status_code, _headers = graph_system_traverse_command_with_http_info(system_id, opts)
      data
    end

    # List the Commands bound to a System
    # This endpoint will return all Commands bound to a System, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this System to the corresponding Command; this array represents all grouping and/or associations that would have to be removed to deprovision the Command from this System.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/commands \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_system_traverse_command_with_http_info(system_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_traverse_command ...'
      end
      # verify the required parameter 'system_id' is set
      if @api_client.config.client_side_validation && system_id.nil?
        fail ArgumentError, "Missing the required parameter 'system_id' when calling GraphApi.graph_system_traverse_command"
      end
      # resource path
      local_var_path = '/systems/{system_id}/commands'.sub('{' + 'system_id' + '}', system_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_traverse_command\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Policies bound to a System
    # This endpoint will return all Policies bound to a System, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this System to the corresponding Policy; this array represents all grouping and/or associations that would have to be removed to deprovision the Policy from this System.  See `/members` and `/associations` endpoints to manage those collections.  This endpoint is not yet public as we have finish the code.  ##### Sample Request  ``` curl -X GET https://console.jumpcloud.com/api/v2/{System_ID}/policies \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_system_traverse_policy(system_id, opts = {})
      data, _status_code, _headers = graph_system_traverse_policy_with_http_info(system_id, opts)
      data
    end

    # List the Policies bound to a System
    # This endpoint will return all Policies bound to a System, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this System to the corresponding Policy; this array represents all grouping and/or associations that would have to be removed to deprovision the Policy from this System.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  This endpoint is not yet public as we have finish the code.  ##### Sample Request  &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/{System_ID}/policies \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_system_traverse_policy_with_http_info(system_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_traverse_policy ...'
      end
      # verify the required parameter 'system_id' is set
      if @api_client.config.client_side_validation && system_id.nil?
        fail ArgumentError, "Missing the required parameter 'system_id' when calling GraphApi.graph_system_traverse_policy"
      end
      # resource path
      local_var_path = '/systems/{system_id}/policies'.sub('{' + 'system_id' + '}', system_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_traverse_policy\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Policy Groups bound to a System
    # This endpoint will return all Policy Groups bound to a System, either directly or indirectly essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this System to the corresponding Policy Group; this array represents all grouping and/or associations that would have to be removed to deprovision the Policy Group from this System.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/policygroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_system_traverse_policy_group(system_id, opts = {})
      data, _status_code, _headers = graph_system_traverse_policy_group_with_http_info(system_id, opts)
      data
    end

    # List the Policy Groups bound to a System
    # This endpoint will return all Policy Groups bound to a System, either directly or indirectly essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this System to the corresponding Policy Group; this array represents all grouping and/or associations that would have to be removed to deprovision the Policy Group from this System.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/policygroups \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_system_traverse_policy_group_with_http_info(system_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_traverse_policy_group ...'
      end
      # verify the required parameter 'system_id' is set
      if @api_client.config.client_side_validation && system_id.nil?
        fail ArgumentError, "Missing the required parameter 'system_id' when calling GraphApi.graph_system_traverse_policy_group"
      end
      # resource path
      local_var_path = '/systems/{system_id}/policygroups'.sub('{' + 'system_id' + '}', system_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?
      header_params[:'Date'] = opts[:'date'] if !opts[:'date'].nil?
      header_params[:'Authorization'] = opts[:'authorization'] if !opts[:'authorization'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_traverse_policy_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Users bound to a System
    # This endpoint will return all Users bound to a System, either directly or indirectly essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this System to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this System.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/users \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_system_traverse_user(system_id, opts = {})
      data, _status_code, _headers = graph_system_traverse_user_with_http_info(system_id, opts)
      data
    end

    # List the Users bound to a System
    # This endpoint will return all Users bound to a System, either directly or indirectly essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this System to the corresponding User; this array represents all grouping and/or associations that would have to be removed to deprovision the User from this System.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/users \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_system_traverse_user_with_http_info(system_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_traverse_user ...'
      end
      # verify the required parameter 'system_id' is set
      if @api_client.config.client_side_validation && system_id.nil?
        fail ArgumentError, "Missing the required parameter 'system_id' when calling GraphApi.graph_system_traverse_user"
      end
      # resource path
      local_var_path = '/systems/{system_id}/users'.sub('{' + 'system_id' + '}', system_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?
      header_params[:'Date'] = opts[:'date'] if !opts[:'date'].nil?
      header_params[:'Authorization'] = opts[:'authorization'] if !opts[:'authorization'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_traverse_user\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the User Groups bound to a System
    # This endpoint will return all User Groups bound to a System, either directly or indirectly essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this System to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this System.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/usergroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_system_traverse_user_group(system_id, opts = {})
      data, _status_code, _headers = graph_system_traverse_user_group_with_http_info(system_id, opts)
      data
    end

    # List the User Groups bound to a System
    # This endpoint will return all User Groups bound to a System, either directly or indirectly essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this System to the corresponding User Group; this array represents all grouping and/or associations that would have to be removed to deprovision the User Group from this System.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/usergroups \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :date Current date header for the System Context API
    # @option opts [String] :authorization Authorization header for the System Context API
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_system_traverse_user_group_with_http_info(system_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_system_traverse_user_group ...'
      end
      # verify the required parameter 'system_id' is set
      if @api_client.config.client_side_validation && system_id.nil?
        fail ArgumentError, "Missing the required parameter 'system_id' when calling GraphApi.graph_system_traverse_user_group"
      end
      # resource path
      local_var_path = '/systems/{system_id}/usergroups'.sub('{' + 'system_id' + '}', system_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      header_params[:'x-org-id'] = opts[:'x_org_id'] if !opts[:'x_org_id'].nil?
      header_params[:'Date'] = opts[:'date'] if !opts[:'date'].nil?
      header_params[:'Authorization'] = opts[:'authorization'] if !opts[:'authorization'].nil?

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_system_traverse_user_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of a User
    # This endpoint returns the _direct_ associations of a User.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Users and Systems.   #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/associations?targets=system_group \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param user_id ObjectID of the User.
    # @param targets Targets which a \&quot;user\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_user_associations_list(user_id, targets, opts = {})
      data, _status_code, _headers = graph_user_associations_list_with_http_info(user_id, targets, opts)
      data
    end

    # List the associations of a User
    # This endpoint returns the _direct_ associations of a User.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Users and Systems.   #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/associations?targets&#x3D;system_group \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param user_id ObjectID of the User.
    # @param targets Targets which a \&quot;user\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_user_associations_list_with_http_info(user_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_associations_list ...'
      end
      # verify the required parameter 'user_id' is set
      if @api_client.config.client_side_validation && user_id.nil?
        fail ArgumentError, "Missing the required parameter 'user_id' when calling GraphApi.graph_user_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_user_associations_list"
      end
      # resource path
      local_var_path = '/users/{user_id}/associations'.sub('{' + 'user_id' + '}', user_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of a User
    # This endpoint allows you to manage the _direct_ associations of a User.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Users and Systems.   #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/users/{UserID}/associations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"attributes\": {       \"sudo\": {       \"enabled\": true,         \"withoutPassword\": false       }     },     \"op\": \"add\",     \"type\": \"system_group\",     \"id\": \"{GroupID}\"   }' ```
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationUser] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_user_associations_post(user_id, opts = {})
      graph_user_associations_post_with_http_info(user_id, opts)
      nil
    end

    # Manage the associations of a User
    # This endpoint allows you to manage the _direct_ associations of a User.  A direct association can be a non-homogeneous relationship between 2 different objects, for example Users and Systems.   #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/users/{UserID}/associations \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;attributes\&quot;: {       \&quot;sudo\&quot;: {       \&quot;enabled\&quot;: true,         \&quot;withoutPassword\&quot;: false       }     },     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;system_group\&quot;,     \&quot;id\&quot;: \&quot;{GroupID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationUser] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_user_associations_post_with_http_info(user_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_associations_post ...'
      end
      # verify the required parameter 'user_id' is set
      if @api_client.config.client_side_validation && user_id.nil?
        fail ArgumentError, "Missing the required parameter 'user_id' when calling GraphApi.graph_user_associations_post"
      end
      # resource path
      local_var_path = '/users/{user_id}/associations'.sub('{' + 'user_id' + '}', user_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_user_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the associations of a User Group.
    # This endpoint returns the _direct_ associations of this User Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example User Groups and Users.   #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/associations?targets=system \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the User Group.
    # @param targets Targets which a \&quot;user_group\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_user_group_associations_list(group_id, targets, opts = {})
      data, _status_code, _headers = graph_user_group_associations_list_with_http_info(group_id, targets, opts)
      data
    end

    # List the associations of a User Group.
    # This endpoint returns the _direct_ associations of this User Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example User Groups and Users.   #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/associations?targets&#x3D;system \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param targets Targets which a \&quot;user_group\&quot; can be associated to.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_user_group_associations_list_with_http_info(group_id, targets, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_associations_list ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GraphApi.graph_user_group_associations_list"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/associations'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'targets'] = @api_client.build_collection_param(targets, :csv)
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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the associations of a User Group
    # This endpoint manages the _direct_ associations of this User Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example User Groups and Users.   #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/associations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"system\",     \"id\": \"{SystemID}\"   }' ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationUserGroup] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_user_group_associations_post(group_id, opts = {})
      graph_user_group_associations_post_with_http_info(group_id, opts)
      nil
    end

    # Manage the associations of a User Group
    # This endpoint manages the _direct_ associations of this User Group.  A direct association can be a non-homogeneous relationship between 2 different objects, for example User Groups and Users.   #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/associations \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;system\&quot;,     \&quot;id\&quot;: \&quot;{SystemID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationUserGroup] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_user_group_associations_post_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_associations_post ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_associations_post"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/associations'.sub('{' + 'group_id' + '}', group_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the members of a User Group
    # This endpoint returns the user members of a User Group.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/members \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphConnection>]
    def graph_user_group_members_list(group_id, opts = {})
      data, _status_code, _headers = graph_user_group_members_list_with_http_info(group_id, opts)
      data
    end

    # List the members of a User Group
    # This endpoint returns the user members of a User Group.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/members \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphConnection>, Integer, Hash)>] Array<GraphConnection> data, response status code and response headers
    def graph_user_group_members_list_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_members_list ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_members_list"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/members'.sub('{' + 'group_id' + '}', group_id.to_s)

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

      return_type = opts[:return_type] || 'Array<GraphConnection>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_members_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Manage the members of a User Group
    # This endpoint allows you to manage the user members of a User Group.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/members \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"op\": \"add\",     \"type\": \"user\",     \"id\": \"{User_ID}\"   }' ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationUserGroupMember] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [nil]
    def graph_user_group_members_post(group_id, opts = {})
      graph_user_group_members_post_with_http_info(group_id, opts)
      nil
    end

    # Manage the members of a User Group
    # This endpoint allows you to manage the user members of a User Group.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/members \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;op\&quot;: \&quot;add\&quot;,     \&quot;type\&quot;: \&quot;user\&quot;,     \&quot;id\&quot;: \&quot;{User_ID}\&quot;   }&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [GraphOperationUserGroupMember] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def graph_user_group_members_post_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_members_post ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_members_post"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/members'.sub('{' + 'group_id' + '}', group_id.to_s)

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
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_members_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the User Group's membership
    # This endpoint returns all users members that are a member of this User Group.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/membership \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_group_membership(group_id, opts = {})
      data, _status_code, _headers = graph_user_group_membership_with_http_info(group_id, opts)
      data
    end

    # List the User Group&#x27;s membership
    # This endpoint returns all users members that are a member of this User Group.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/membership \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_group_membership_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_membership ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_membership"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/membership'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_membership\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Active Directories bound to a User Group
    # This endpoint will return all Active Directory Instances bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding Active Directory; this array represents all grouping and/or associations that would have to be removed to deprovision the Active Directory from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/activedirectories \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_group_traverse_active_directory(group_id, opts = {})
      data, _status_code, _headers = graph_user_group_traverse_active_directory_with_http_info(group_id, opts)
      data
    end

    # List the Active Directories bound to a User Group
    # This endpoint will return all Active Directory Instances bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User Group to the corresponding Active Directory; this array represents all grouping and/or associations that would have to be removed to deprovision the Active Directory from this User Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/activedirectories \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_group_traverse_active_directory_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_traverse_active_directory ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_traverse_active_directory"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/activedirectories'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_traverse_active_directory\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Applications bound to a User Group
    # This endpoint will return all Applications bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding Application; this array represents all grouping and/or associations that would have to be removed to deprovision the Application from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/applications \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_group_traverse_application(group_id, opts = {})
      data, _status_code, _headers = graph_user_group_traverse_application_with_http_info(group_id, opts)
      data
    end

    # List the Applications bound to a User Group
    # This endpoint will return all Applications bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User Group to the corresponding Application; this array represents all grouping and/or associations that would have to be removed to deprovision the Application from this User Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/applications \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_group_traverse_application_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_traverse_application ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_traverse_application"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/applications'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_traverse_application\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Directories bound to a User Group
    # This endpoint will return all Directories bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding Directory; this array represents all grouping and/or associations that would have to be removed to deprovision the Directories from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/directories \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_group_traverse_directory(group_id, opts = {})
      data, _status_code, _headers = graph_user_group_traverse_directory_with_http_info(group_id, opts)
      data
    end

    # List the Directories bound to a User Group
    # This endpoint will return all Directories bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User Group to the corresponding Directory; this array represents all grouping and/or associations that would have to be removed to deprovision the Directories from this User Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/directories \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_group_traverse_directory_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_traverse_directory ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_traverse_directory"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/directories'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_traverse_directory\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the G Suite instances bound to a User Group
    # This endpoint will return all G Suite Instances bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding G Suite instance; this array represents all grouping and/or associations that would have to be removed to deprovision the G Suite instance from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID/gsuites \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_group_traverse_g_suite(group_id, opts = {})
      data, _status_code, _headers = graph_user_group_traverse_g_suite_with_http_info(group_id, opts)
      data
    end

    # List the G Suite instances bound to a User Group
    # This endpoint will return all G Suite Instances bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User Group to the corresponding G Suite instance; this array represents all grouping and/or associations that would have to be removed to deprovision the G Suite instance from this User Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID/gsuites \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_group_traverse_g_suite_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_traverse_g_suite ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_traverse_g_suite"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/gsuites'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_traverse_g_suite\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the LDAP Servers bound to a User Group
    # This endpoint will return all LDAP Servers bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding LDAP Server; this array represents all grouping and/or associations that would have to be removed to deprovision the LDAP Server from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/ldapservers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_group_traverse_ldap_server(group_id, opts = {})
      data, _status_code, _headers = graph_user_group_traverse_ldap_server_with_http_info(group_id, opts)
      data
    end

    # List the LDAP Servers bound to a User Group
    # This endpoint will return all LDAP Servers bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User Group to the corresponding LDAP Server; this array represents all grouping and/or associations that would have to be removed to deprovision the LDAP Server from this User Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/ldapservers \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_group_traverse_ldap_server_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_traverse_ldap_server ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_traverse_ldap_server"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/ldapservers'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_traverse_ldap_server\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Office 365 instances bound to a User Group
    # This endpoint will return all Office 365 instances bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding Office 365 instance; this array represents all grouping and/or associations that would have to be removed to deprovision the Office 365 instance from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/office365s \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_group_traverse_office365(group_id, opts = {})
      data, _status_code, _headers = graph_user_group_traverse_office365_with_http_info(group_id, opts)
      data
    end

    # List the Office 365 instances bound to a User Group
    # This endpoint will return all Office 365 instances bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User Group to the corresponding Office 365 instance; this array represents all grouping and/or associations that would have to be removed to deprovision the Office 365 instance from this User Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/office365s \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_group_traverse_office365_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_traverse_office365 ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_traverse_office365"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/office365s'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_traverse_office365\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the RADIUS Servers bound to a User Group
    # This endpoint will return all RADIUS servers bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding RADIUS Server; this array represents all grouping and/or associations that would have to be removed to deprovision the RADIUS Server from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/radiusservers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_group_traverse_radius_server(group_id, opts = {})
      data, _status_code, _headers = graph_user_group_traverse_radius_server_with_http_info(group_id, opts)
      data
    end

    # List the RADIUS Servers bound to a User Group
    # This endpoint will return all RADIUS servers bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User Group to the corresponding RADIUS Server; this array represents all grouping and/or associations that would have to be removed to deprovision the RADIUS Server from this User Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/radiusservers \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_group_traverse_radius_server_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_traverse_radius_server ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_traverse_radius_server"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/radiusservers'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_traverse_radius_server\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Systems bound to a User Group
    # This endpoint will return all Systems bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_group_traverse_system(group_id, opts = {})
      data, _status_code, _headers = graph_user_group_traverse_system_with_http_info(group_id, opts)
      data
    end

    # List the Systems bound to a User Group
    # This endpoint will return all Systems bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User Group to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this User Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/systems \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_group_traverse_system_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_traverse_system ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_traverse_system"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/systems'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_traverse_system\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the System Groups bound to User Groups
    # This endpoint will return all System Groups bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User Group to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this User Group.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/systemgroups \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_group_traverse_system_group(group_id, opts = {})
      data, _status_code, _headers = graph_user_group_traverse_system_group_with_http_info(group_id, opts)
      data
    end

    # List the System Groups bound to User Groups
    # This endpoint will return all System Groups bound to a User Group, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User Group to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this User Group.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/usergroups/{GroupID}/systemgroups \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param group_id ObjectID of the User Group.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_group_traverse_system_group_with_http_info(group_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_group_traverse_system_group ...'
      end
      # verify the required parameter 'group_id' is set
      if @api_client.config.client_side_validation && group_id.nil?
        fail ArgumentError, "Missing the required parameter 'group_id' when calling GraphApi.graph_user_group_traverse_system_group"
      end
      # resource path
      local_var_path = '/usergroups/{group_id}/systemgroups'.sub('{' + 'group_id' + '}', group_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_group_traverse_system_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the parent Groups of a User
    # This endpoint returns all the User Groups a User is a member of.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/memberof \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_member_of(user_id, opts = {})
      data, _status_code, _headers = graph_user_member_of_with_http_info(user_id, opts)
      data
    end

    # List the parent Groups of a User
    # This endpoint returns all the User Groups a User is a member of.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/memberof \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_member_of_with_http_info(user_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_member_of ...'
      end
      # verify the required parameter 'user_id' is set
      if @api_client.config.client_side_validation && user_id.nil?
        fail ArgumentError, "Missing the required parameter 'user_id' when calling GraphApi.graph_user_member_of"
      end
      # resource path
      local_var_path = '/users/{user_id}/memberof'.sub('{' + 'user_id' + '}', user_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_member_of\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Active Directory instances bound to a User
    # This endpoint will return all Active Directory Instances bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User to the corresponding Active Directory instance; this array represents all grouping and/or associations that would have to be removed to deprovision the Active Directory instance from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/activedirectories \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_traverse_active_directory(user_id, opts = {})
      data, _status_code, _headers = graph_user_traverse_active_directory_with_http_info(user_id, opts)
      data
    end

    # List the Active Directory instances bound to a User
    # This endpoint will return all Active Directory Instances bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User to the corresponding Active Directory instance; this array represents all grouping and/or associations that would have to be removed to deprovision the Active Directory instance from this User.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/activedirectories \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_traverse_active_directory_with_http_info(user_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_traverse_active_directory ...'
      end
      # verify the required parameter 'user_id' is set
      if @api_client.config.client_side_validation && user_id.nil?
        fail ArgumentError, "Missing the required parameter 'user_id' when calling GraphApi.graph_user_traverse_active_directory"
      end
      # resource path
      local_var_path = '/users/{user_id}/activedirectories'.sub('{' + 'user_id' + '}', user_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_traverse_active_directory\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Applications bound to a User
    # This endpoint will return all Applications bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User to the corresponding Application; this array represents all grouping and/or associations that would have to be removed to deprovision the Application from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/applications \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_traverse_application(user_id, opts = {})
      data, _status_code, _headers = graph_user_traverse_application_with_http_info(user_id, opts)
      data
    end

    # List the Applications bound to a User
    # This endpoint will return all Applications bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User to the corresponding Application; this array represents all grouping and/or associations that would have to be removed to deprovision the Application from this User.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/applications \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_traverse_application_with_http_info(user_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_traverse_application ...'
      end
      # verify the required parameter 'user_id' is set
      if @api_client.config.client_side_validation && user_id.nil?
        fail ArgumentError, "Missing the required parameter 'user_id' when calling GraphApi.graph_user_traverse_application"
      end
      # resource path
      local_var_path = '/users/{user_id}/applications'.sub('{' + 'user_id' + '}', user_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_traverse_application\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Directories bound to a User
    # This endpoint will return all Directories bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User to the corresponding Directory; this array represents all grouping and/or associations that would have to be removed to deprovision the Directory from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/directories \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_traverse_directory(user_id, opts = {})
      data, _status_code, _headers = graph_user_traverse_directory_with_http_info(user_id, opts)
      data
    end

    # List the Directories bound to a User
    # This endpoint will return all Directories bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User to the corresponding Directory; this array represents all grouping and/or associations that would have to be removed to deprovision the Directory from this User.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/directories \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_traverse_directory_with_http_info(user_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_traverse_directory ...'
      end
      # verify the required parameter 'user_id' is set
      if @api_client.config.client_side_validation && user_id.nil?
        fail ArgumentError, "Missing the required parameter 'user_id' when calling GraphApi.graph_user_traverse_directory"
      end
      # resource path
      local_var_path = '/users/{user_id}/directories'.sub('{' + 'user_id' + '}', user_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_traverse_directory\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the G Suite instances bound to a User
    # This endpoint will return all G-Suite Instances bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User to the corresponding G Suite instance; this array represents all grouping and/or associations that would have to be removed to deprovision the G Suite instance from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/gsuites \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_traverse_g_suite(user_id, opts = {})
      data, _status_code, _headers = graph_user_traverse_g_suite_with_http_info(user_id, opts)
      data
    end

    # List the G Suite instances bound to a User
    # This endpoint will return all G-Suite Instances bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User to the corresponding G Suite instance; this array represents all grouping and/or associations that would have to be removed to deprovision the G Suite instance from this User.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/gsuites \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_traverse_g_suite_with_http_info(user_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_traverse_g_suite ...'
      end
      # verify the required parameter 'user_id' is set
      if @api_client.config.client_side_validation && user_id.nil?
        fail ArgumentError, "Missing the required parameter 'user_id' when calling GraphApi.graph_user_traverse_g_suite"
      end
      # resource path
      local_var_path = '/users/{user_id}/gsuites'.sub('{' + 'user_id' + '}', user_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_traverse_g_suite\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the LDAP servers bound to a User
    # This endpoint will return all LDAP Servers bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User to the corresponding LDAP Server; this array represents all grouping and/or associations that would have to be removed to deprovision the LDAP Server from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/ldapservers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_traverse_ldap_server(user_id, opts = {})
      data, _status_code, _headers = graph_user_traverse_ldap_server_with_http_info(user_id, opts)
      data
    end

    # List the LDAP servers bound to a User
    # This endpoint will return all LDAP Servers bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User to the corresponding LDAP Server; this array represents all grouping and/or associations that would have to be removed to deprovision the LDAP Server from this User.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/ldapservers \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_traverse_ldap_server_with_http_info(user_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_traverse_ldap_server ...'
      end
      # verify the required parameter 'user_id' is set
      if @api_client.config.client_side_validation && user_id.nil?
        fail ArgumentError, "Missing the required parameter 'user_id' when calling GraphApi.graph_user_traverse_ldap_server"
      end
      # resource path
      local_var_path = '/users/{user_id}/ldapservers'.sub('{' + 'user_id' + '}', user_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_traverse_ldap_server\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Office 365 instances bound to a User
    # This endpoint will return all Office 365 Instances bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User to the corresponding Office 365 instance; this array represents all grouping and/or associations that would have to be removed to deprovision the Office 365 instance from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/office365s \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_traverse_office365(user_id, opts = {})
      data, _status_code, _headers = graph_user_traverse_office365_with_http_info(user_id, opts)
      data
    end

    # List the Office 365 instances bound to a User
    # This endpoint will return all Office 365 Instances bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User to the corresponding Office 365 instance; this array represents all grouping and/or associations that would have to be removed to deprovision the Office 365 instance from this User.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/office365s \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_traverse_office365_with_http_info(user_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_traverse_office365 ...'
      end
      # verify the required parameter 'user_id' is set
      if @api_client.config.client_side_validation && user_id.nil?
        fail ArgumentError, "Missing the required parameter 'user_id' when calling GraphApi.graph_user_traverse_office365"
      end
      # resource path
      local_var_path = '/users/{user_id}/office365s'.sub('{' + 'user_id' + '}', user_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_traverse_office365\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the RADIUS Servers bound to a User
    # This endpoint will return all RADIUS Servers bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User to the corresponding RADIUS Server; this array represents all grouping and/or associations that would have to be removed to deprovision the RADIUS Server from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/radiusservers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_traverse_radius_server(user_id, opts = {})
      data, _status_code, _headers = graph_user_traverse_radius_server_with_http_info(user_id, opts)
      data
    end

    # List the RADIUS Servers bound to a User
    # This endpoint will return all RADIUS Servers bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User to the corresponding RADIUS Server; this array represents all grouping and/or associations that would have to be removed to deprovision the RADIUS Server from this User.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/radiusservers \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_traverse_radius_server_with_http_info(user_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_traverse_radius_server ...'
      end
      # verify the required parameter 'user_id' is set
      if @api_client.config.client_side_validation && user_id.nil?
        fail ArgumentError, "Missing the required parameter 'user_id' when calling GraphApi.graph_user_traverse_radius_server"
      end
      # resource path
      local_var_path = '/users/{user_id}/radiusservers'.sub('{' + 'user_id' + '}', user_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_traverse_radius_server\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the Systems bound to a User
    # This endpoint will return all Systems bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/systems\\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_traverse_system(user_id, opts = {})
      data, _status_code, _headers = graph_user_traverse_system_with_http_info(user_id, opts)
      data
    end

    # List the Systems bound to a User
    # This endpoint will return all Systems bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User to the corresponding System; this array represents all grouping and/or associations that would have to be removed to deprovision the System from this User.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/systems\\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_traverse_system_with_http_info(user_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_traverse_system ...'
      end
      # verify the required parameter 'user_id' is set
      if @api_client.config.client_side_validation && user_id.nil?
        fail ArgumentError, "Missing the required parameter 'user_id' when calling GraphApi.graph_user_traverse_system"
      end
      # resource path
      local_var_path = '/users/{user_id}/systems'.sub('{' + 'user_id' + '}', user_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_traverse_system\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the System Groups bound to a User
    # This endpoint will return all System Groups bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The `attributes` object is a key/value hash of compiled graph attributes for all paths followed.  The `paths` array enumerates each path from this User to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this User.  See `/members` and `/associations` endpoints to manage those collections.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/systemgroups\\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<GraphObjectWithPaths>]
    def graph_user_traverse_system_group(user_id, opts = {})
      data, _status_code, _headers = graph_user_traverse_system_group_with_http_info(user_id, opts)
      data
    end

    # List the System Groups bound to a User
    # This endpoint will return all System Groups bound to a User, either directly or indirectly, essentially traversing the JumpCloud Graph for your Organization.  Each element will contain the type, id, attributes and paths.  The &#x60;attributes&#x60; object is a key/value hash of compiled graph attributes for all paths followed.  The &#x60;paths&#x60; array enumerates each path from this User to the corresponding System Group; this array represents all grouping and/or associations that would have to be removed to deprovision the System Group from this User.  See &#x60;/members&#x60; and &#x60;/associations&#x60; endpoints to manage those collections.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/users/{UserID}/systemgroups\\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param user_id ObjectID of the User.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(Array<GraphObjectWithPaths>, Integer, Hash)>] Array<GraphObjectWithPaths> data, response status code and response headers
    def graph_user_traverse_system_group_with_http_info(user_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.graph_user_traverse_system_group ...'
      end
      # verify the required parameter 'user_id' is set
      if @api_client.config.client_side_validation && user_id.nil?
        fail ArgumentError, "Missing the required parameter 'user_id' when calling GraphApi.graph_user_traverse_system_group"
      end
      # resource path
      local_var_path = '/users/{user_id}/systemgroups'.sub('{' + 'user_id' + '}', user_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
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

      return_type = opts[:return_type] || 'Array<GraphObjectWithPaths>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#graph_user_traverse_system_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the policy statuses for a system
    # This endpoint returns the policy results for a particular system.  ##### Sample Request  ``` curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/policystatuses \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'  ```
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<PolicyResult>]
    def policystatuses_systems_list(system_id, opts = {})
      data, _status_code, _headers = policystatuses_systems_list_with_http_info(system_id, opts)
      data
    end

    # List the policy statuses for a system
    # This endpoint returns the policy results for a particular system.  ##### Sample Request  &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/systems/{System_ID}/policystatuses \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;  &#x60;&#x60;&#x60;
    # @param system_id ObjectID of the System.
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Array<PolicyResult>, Integer, Hash)>] Array<PolicyResult> data, response status code and response headers
    def policystatuses_systems_list_with_http_info(system_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GraphApi.policystatuses_systems_list ...'
      end
      # verify the required parameter 'system_id' is set
      if @api_client.config.client_side_validation && system_id.nil?
        fail ArgumentError, "Missing the required parameter 'system_id' when calling GraphApi.policystatuses_systems_list"
      end
      # resource path
      local_var_path = '/systems/{system_id}/policystatuses'.sub('{' + 'system_id' + '}', system_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fields'] = @api_client.build_collection_param(opts[:'fields'], :csv) if !opts[:'fields'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
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

      return_type = opts[:return_type] || 'Array<PolicyResult>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GraphApi#policystatuses_systems_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
