=begin
#JumpCloud API

## Overview  JumpCloud's V1 API. This set of endpoints allows JumpCloud customers to manage commands, systems, and system users.  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/systemusers\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 1.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.32
=end

module JCAPIv1
  class SearchApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Search Commands Results
    # Return Command Results in multi-record format allowing for the passing of the `filter` parameter.  To support advanced filtering you can use the `filter` and `searchFilter` parameters that can only be passed in the body of POST /api/search/commandresults route. The `filter` parameter must be passed as Content-Type application/json.  The `filter` parameter is an object with a single property, either `and` or `or` with the value of the property being an array of query expressions.  This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the `and` or `or` are not included the default behavior is to match ALL query expressions.   #### Sample Request  Exact search for a specific command result ``` curl -X POST https://console.jumpcloud.com/api/search/commandresults \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"filter\" : \"workflowInstanceId:$eq:62f3c599ec4e928499069c7f\",   \"fields\" : \"name workflowId sudo\" }' ```
    # @param [Hash] opts the optional parameters
    # @option opts [Search] :body 
    # @option opts [String] :x_org_id 
    # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @return [Commandresultslist]
    def search_commandresults_post(opts = {})
      data, _status_code, _headers = search_commandresults_post_with_http_info(opts)
      data
    end

    # Search Commands Results
    # Return Command Results in multi-record format allowing for the passing of the &#x60;filter&#x60; parameter.  To support advanced filtering you can use the &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters that can only be passed in the body of POST /api/search/commandresults route. The &#x60;filter&#x60; parameter must be passed as Content-Type application/json.  The &#x60;filter&#x60; parameter is an object with a single property, either &#x60;and&#x60; or &#x60;or&#x60; with the value of the property being an array of query expressions.  This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the &#x60;and&#x60; or &#x60;or&#x60; are not included the default behavior is to match ALL query expressions.   #### Sample Request  Exact search for a specific command result &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/commandresults \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;filter\&quot; : \&quot;workflowInstanceId:$eq:62f3c599ec4e928499069c7f\&quot;,   \&quot;fields\&quot; : \&quot;name workflowId sudo\&quot; }&#x27; &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [Search] :body 
    # @option opts [String] :x_org_id 
    # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @return [Array<(Commandresultslist, Integer, Hash)>] Commandresultslist data, response status code and response headers
    def search_commandresults_post_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SearchApi.search_commandresults_post ...'
      end
      # resource path
      local_var_path = '/search/commandresults'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fields'] = opts[:'fields'] if !opts[:'fields'].nil?
      query_params[:'filter'] = opts[:'filter'] if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?

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

      return_type = opts[:return_type] || 'Commandresultslist' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SearchApi#search_commandresults_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Search Commands
    # Return Commands in multi-record format allowing for the passing of the `filter` and `searchFilter` parameters. This WILL NOT allow you to add a new command. To support advanced filtering you can use the `filter` and `searchFilter` parameters that can only be passed in the body of POST /api/search/* routes. The `filter` and `searchFilter` parameters must be passed as Content-Type application/json. The `filter` parameter is an object with a single property, either `and` or `or` with the value of the property being an array of query expressions. This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the `and` or `or` are not included the default behavior is to match ALL query expressions. The `searchFilter` parameter allows text searching on supported fields by specifying a `searchTerm` and a list of `fields` to query on. If any `field` has a partial text match on the `searchTerm` the record will be returned.  #### Sample Request Exact search for a list of commands in a launchType ``` curl -X POST https://console.jumpcloud.com/api/search/commands \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"filter\" : [{\"launchType\" : \"repeated\"}],   \"fields\" : \"name launchType sudo\" }' ``` Text search for commands with name ``` curl -X POST https://console.jumpcloud.com/api/search/commands \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\" : {     \"searchTerm\": \"List\",     \"fields\": [\"name\"]   },   \"fields\" : \"name launchType sudo\" }' ``` Text search for multiple commands ``` curl -X POST https://console.jumpcloud.com/api/search/commands \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\" : {     \"searchTerm\": [\"List\", \"Log\"],     \"fields\": [\"name\"]   },   \"fields\" : \"name launchType sudo\" }' ``` Combining `filter` and `searchFilter` to text search for commands with name who are in a list of launchType ``` curl -X POST https://console.jumpcloud.com/api/search/commands \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\": {     \"searchTerm\": \"List\",     \"fields\": [\"name\"]   },   \"filter\": {     \"or\": [       {\"launchType\" : \"repeated\"},       {\"launchType\" : \"one-time\"}     ]   },   \"fields\" : \"name launchType sudo\" }' ```
    # @param [Hash] opts the optional parameters
    # @option opts [Search] :body 
    # @option opts [String] :x_org_id 
    # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @return [Commandslist]
    def search_commands_post(opts = {})
      data, _status_code, _headers = search_commands_post_with_http_info(opts)
      data
    end

    # Search Commands
    # Return Commands in multi-record format allowing for the passing of the &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters. This WILL NOT allow you to add a new command. To support advanced filtering you can use the &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters that can only be passed in the body of POST /api/search/* routes. The &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters must be passed as Content-Type application/json. The &#x60;filter&#x60; parameter is an object with a single property, either &#x60;and&#x60; or &#x60;or&#x60; with the value of the property being an array of query expressions. This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the &#x60;and&#x60; or &#x60;or&#x60; are not included the default behavior is to match ALL query expressions. The &#x60;searchFilter&#x60; parameter allows text searching on supported fields by specifying a &#x60;searchTerm&#x60; and a list of &#x60;fields&#x60; to query on. If any &#x60;field&#x60; has a partial text match on the &#x60;searchTerm&#x60; the record will be returned.  #### Sample Request Exact search for a list of commands in a launchType &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/commands \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;filter\&quot; : [{\&quot;launchType\&quot; : \&quot;repeated\&quot;}],   \&quot;fields\&quot; : \&quot;name launchType sudo\&quot; }&#x27; &#x60;&#x60;&#x60; Text search for commands with name &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/commands \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;searchFilter\&quot; : {     \&quot;searchTerm\&quot;: \&quot;List\&quot;,     \&quot;fields\&quot;: [\&quot;name\&quot;]   },   \&quot;fields\&quot; : \&quot;name launchType sudo\&quot; }&#x27; &#x60;&#x60;&#x60; Text search for multiple commands &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/commands \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;searchFilter\&quot; : {     \&quot;searchTerm\&quot;: [\&quot;List\&quot;, \&quot;Log\&quot;],     \&quot;fields\&quot;: [\&quot;name\&quot;]   },   \&quot;fields\&quot; : \&quot;name launchType sudo\&quot; }&#x27; &#x60;&#x60;&#x60; Combining &#x60;filter&#x60; and &#x60;searchFilter&#x60; to text search for commands with name who are in a list of launchType &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/commands \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;searchFilter\&quot;: {     \&quot;searchTerm\&quot;: \&quot;List\&quot;,     \&quot;fields\&quot;: [\&quot;name\&quot;]   },   \&quot;filter\&quot;: {     \&quot;or\&quot;: [       {\&quot;launchType\&quot; : \&quot;repeated\&quot;},       {\&quot;launchType\&quot; : \&quot;one-time\&quot;}     ]   },   \&quot;fields\&quot; : \&quot;name launchType sudo\&quot; }&#x27; &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [Search] :body 
    # @option opts [String] :x_org_id 
    # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @return [Array<(Commandslist, Integer, Hash)>] Commandslist data, response status code and response headers
    def search_commands_post_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SearchApi.search_commands_post ...'
      end
      # resource path
      local_var_path = '/search/commands'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fields'] = opts[:'fields'] if !opts[:'fields'].nil?
      query_params[:'filter'] = opts[:'filter'] if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?

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

      return_type = opts[:return_type] || 'Commandslist' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SearchApi#search_commands_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Search Organizations
    # This endpoint will return Organization data based on your search parameters. This endpoint WILL NOT allow you to add a new Organization.  You can use the supported parameters and pass those in the body of request.  The parameters must be passed as Content-Type application/json.   #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/search/organizations \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"search\":{     \"fields\" : [\"settings.name\"],     \"searchTerm\": \"Second\"     },   \"fields\": [\"_id\", \"displayName\", \"logoUrl\"],   \"limit\" : 0,   \"skip\" : 0 }' ```
    # @param [Hash] opts the optional parameters
    # @option opts [Search] :body 
    # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @return [Organizationslist]
    def search_organizations_post(opts = {})
      data, _status_code, _headers = search_organizations_post_with_http_info(opts)
      data
    end

    # Search Organizations
    # This endpoint will return Organization data based on your search parameters. This endpoint WILL NOT allow you to add a new Organization.  You can use the supported parameters and pass those in the body of request.  The parameters must be passed as Content-Type application/json.   #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/organizations \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;search\&quot;:{     \&quot;fields\&quot; : [\&quot;settings.name\&quot;],     \&quot;searchTerm\&quot;: \&quot;Second\&quot;     },   \&quot;fields\&quot;: [\&quot;_id\&quot;, \&quot;displayName\&quot;, \&quot;logoUrl\&quot;],   \&quot;limit\&quot; : 0,   \&quot;skip\&quot; : 0 }&#x27; &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [Search] :body 
    # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @return [Array<(Organizationslist, Integer, Hash)>] Organizationslist data, response status code and response headers
    def search_organizations_post_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SearchApi.search_organizations_post ...'
      end
      # resource path
      local_var_path = '/search/organizations'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fields'] = opts[:'fields'] if !opts[:'fields'].nil?
      query_params[:'filter'] = opts[:'filter'] if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?

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

      return_type = opts[:return_type] || 'Organizationslist' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SearchApi#search_organizations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Search Systems
    # Return Systems in multi-record format allowing for the passing of the `filter` and `searchFilter` parameters. This WILL NOT allow you to add a new system.  To support advanced filtering you can use the `filter` and `searchFilter` parameters that can only be passed in the body of POST /api/search/* routes. The `filter` and `searchFilter` parameters must be passed as Content-Type application/json.  The `filter` parameter is an object with a single property, either `and` or `or` with the value of the property being an array of query expressions.  This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the `and` or `or` are not included the default behavior is to match ALL query expressions.  The `searchFilter` parameter allows text searching on supported fields by specifying a `searchTerm` and a list of `fields` to query on. If any `field` has a partial text match on the `searchTerm` the record will be returned.   #### Sample Request  Exact search for a list of hostnames ``` curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"filter\": {     \"or\": [       {\"hostname\" : \"my-hostname\"},       {\"hostname\" : \"other-hostname\"}     ]   },   \"fields\" : \"os hostname displayName\" }' ```  Text search for a hostname or display name ``` curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\": {     \"searchTerm\": \"my-host\",     \"fields\": [\"hostname\", \"displayName\"]   },   \"fields\": \"os hostname displayName\" }' ```  Text search for a multiple hostnames. ``` curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\": {     \"searchTerm\": [\"my-host\", \"my-other-host\"],     \"fields\": [\"hostname\"]   },   \"fields\": \"os hostname displayName\" }' ```  Combining `filter` and `searchFilter` to search for names that match a given OS ``` curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\": {     \"searchTerm\": \"my-host\",     \"fields\": [\"hostname\", \"displayName\"]   },   \"filter\": {     \"or\": [       {\"os\" : \"Ubuntu\"},       {\"os\" : \"Mac OS X\"}     ]   },   \"fields\": \"os hostname displayName\" }' ```
    # @param [Hash] opts the optional parameters
    # @option opts [Search] :body 
    # @option opts [String] :x_org_id 
    # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @return [Systemslist]
    def search_systems_post(opts = {})
      data, _status_code, _headers = search_systems_post_with_http_info(opts)
      data
    end

    # Search Systems
    # Return Systems in multi-record format allowing for the passing of the &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters. This WILL NOT allow you to add a new system.  To support advanced filtering you can use the &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters that can only be passed in the body of POST /api/search/* routes. The &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters must be passed as Content-Type application/json.  The &#x60;filter&#x60; parameter is an object with a single property, either &#x60;and&#x60; or &#x60;or&#x60; with the value of the property being an array of query expressions.  This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the &#x60;and&#x60; or &#x60;or&#x60; are not included the default behavior is to match ALL query expressions.  The &#x60;searchFilter&#x60; parameter allows text searching on supported fields by specifying a &#x60;searchTerm&#x60; and a list of &#x60;fields&#x60; to query on. If any &#x60;field&#x60; has a partial text match on the &#x60;searchTerm&#x60; the record will be returned.   #### Sample Request  Exact search for a list of hostnames &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;filter\&quot;: {     \&quot;or\&quot;: [       {\&quot;hostname\&quot; : \&quot;my-hostname\&quot;},       {\&quot;hostname\&quot; : \&quot;other-hostname\&quot;}     ]   },   \&quot;fields\&quot; : \&quot;os hostname displayName\&quot; }&#x27; &#x60;&#x60;&#x60;  Text search for a hostname or display name &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;searchFilter\&quot;: {     \&quot;searchTerm\&quot;: \&quot;my-host\&quot;,     \&quot;fields\&quot;: [\&quot;hostname\&quot;, \&quot;displayName\&quot;]   },   \&quot;fields\&quot;: \&quot;os hostname displayName\&quot; }&#x27; &#x60;&#x60;&#x60;  Text search for a multiple hostnames. &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;searchFilter\&quot;: {     \&quot;searchTerm\&quot;: [\&quot;my-host\&quot;, \&quot;my-other-host\&quot;],     \&quot;fields\&quot;: [\&quot;hostname\&quot;]   },   \&quot;fields\&quot;: \&quot;os hostname displayName\&quot; }&#x27; &#x60;&#x60;&#x60;  Combining &#x60;filter&#x60; and &#x60;searchFilter&#x60; to search for names that match a given OS &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;searchFilter\&quot;: {     \&quot;searchTerm\&quot;: \&quot;my-host\&quot;,     \&quot;fields\&quot;: [\&quot;hostname\&quot;, \&quot;displayName\&quot;]   },   \&quot;filter\&quot;: {     \&quot;or\&quot;: [       {\&quot;os\&quot; : \&quot;Ubuntu\&quot;},       {\&quot;os\&quot; : \&quot;Mac OS X\&quot;}     ]   },   \&quot;fields\&quot;: \&quot;os hostname displayName\&quot; }&#x27; &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [Search] :body 
    # @option opts [String] :x_org_id 
    # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @return [Array<(Systemslist, Integer, Hash)>] Systemslist data, response status code and response headers
    def search_systems_post_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SearchApi.search_systems_post ...'
      end
      # resource path
      local_var_path = '/search/systems'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fields'] = opts[:'fields'] if !opts[:'fields'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'filter'] = opts[:'filter'] if !opts[:'filter'].nil?

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

      return_type = opts[:return_type] || 'Systemslist' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SearchApi#search_systems_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Search System Users
    # Return System Users in multi-record format allowing for the passing of the `filter` and `searchFilter` parameters. This WILL NOT allow you to add a new system user.  To support advanced filtering you can use the `filter` and `searchFilter` parameters that can only be passed in the body of POST /api/search/* routes. The `filter` and `searchFilter` parameters must be passed as Content-Type application/json.  The `filter` parameter is an object with a single property, either `and` or `or` with the value of the property being an array of query expressions.  This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the `and` or `or` are not included the default behavior is to match ALL query expressions.  The `searchFilter` parameter allows text searching on supported fields by specifying a `searchTerm` and a list of `fields` to query on. If any `field` has a partial text match on the `searchTerm` the record will be returned.   #### Sample Request  Exact search for a list of system users in a department ``` curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"filter\" : [{\"department\" : \"IT\"}],   \"fields\" : \"email username sudo\" }' ```  Text search for system users with and email on a domain ``` curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\" : {     \"searchTerm\": \"@jumpcloud.com\",     \"fields\": [\"email\"]   },   \"fields\" : \"email username sudo\" }' ```  Text search for multiple system users ``` curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\" : {     \"searchTerm\": [\"john\", \"sarah\"],     \"fields\": [\"username\"]   },   \"fields\" : \"email username sudo\" }' ```  Combining `filter` and `searchFilter` to text search for system users with and email on a domain who are in a list of departments ``` curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{   \"searchFilter\": {     \"searchTerm\": \"@jumpcloud.com\",     \"fields\": [\"email\"]   },   \"filter\": {     \"or\": [       {\"department\" : \"IT\"},       {\"department\" : \"Sales\"}     ]   },   \"fields\" : \"email username sudo\" }' ```
    # @param [Hash] opts the optional parameters
    # @option opts [Search] :body 
    # @option opts [String] :x_org_id 
    # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @return [Systemuserslist]
    def search_systemusers_post(opts = {})
      data, _status_code, _headers = search_systemusers_post_with_http_info(opts)
      data
    end

    # Search System Users
    # Return System Users in multi-record format allowing for the passing of the &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters. This WILL NOT allow you to add a new system user.  To support advanced filtering you can use the &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters that can only be passed in the body of POST /api/search/* routes. The &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters must be passed as Content-Type application/json.  The &#x60;filter&#x60; parameter is an object with a single property, either &#x60;and&#x60; or &#x60;or&#x60; with the value of the property being an array of query expressions.  This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the &#x60;and&#x60; or &#x60;or&#x60; are not included the default behavior is to match ALL query expressions.  The &#x60;searchFilter&#x60; parameter allows text searching on supported fields by specifying a &#x60;searchTerm&#x60; and a list of &#x60;fields&#x60; to query on. If any &#x60;field&#x60; has a partial text match on the &#x60;searchTerm&#x60; the record will be returned.   #### Sample Request  Exact search for a list of system users in a department &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;filter\&quot; : [{\&quot;department\&quot; : \&quot;IT\&quot;}],   \&quot;fields\&quot; : \&quot;email username sudo\&quot; }&#x27; &#x60;&#x60;&#x60;  Text search for system users with and email on a domain &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;searchFilter\&quot; : {     \&quot;searchTerm\&quot;: \&quot;@jumpcloud.com\&quot;,     \&quot;fields\&quot;: [\&quot;email\&quot;]   },   \&quot;fields\&quot; : \&quot;email username sudo\&quot; }&#x27; &#x60;&#x60;&#x60;  Text search for multiple system users &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;searchFilter\&quot; : {     \&quot;searchTerm\&quot;: [\&quot;john\&quot;, \&quot;sarah\&quot;],     \&quot;fields\&quot;: [\&quot;username\&quot;]   },   \&quot;fields\&quot; : \&quot;email username sudo\&quot; }&#x27; &#x60;&#x60;&#x60;  Combining &#x60;filter&#x60; and &#x60;searchFilter&#x60; to text search for system users with and email on a domain who are in a list of departments &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{   \&quot;searchFilter\&quot;: {     \&quot;searchTerm\&quot;: \&quot;@jumpcloud.com\&quot;,     \&quot;fields\&quot;: [\&quot;email\&quot;]   },   \&quot;filter\&quot;: {     \&quot;or\&quot;: [       {\&quot;department\&quot; : \&quot;IT\&quot;},       {\&quot;department\&quot; : \&quot;Sales\&quot;}     ]   },   \&quot;fields\&quot; : \&quot;email username sudo\&quot; }&#x27; &#x60;&#x60;&#x60;
    # @param [Hash] opts the optional parameters
    # @option opts [Search] :body 
    # @option opts [String] :x_org_id 
    # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
    # @option opts [String] :filter A filter to apply to the query. See the supported operators below. For more complex searches, see the related &#x60;/search/&lt;domain&gt;&#x60; endpoints, e.g. &#x60;/search/systems&#x60;.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D; Supported operators are: - &#x60;$eq&#x60; (equals) - &#x60;$ne&#x60; (does not equal) - &#x60;$gt&#x60; (is greater than) - &#x60;$gte&#x60; (is greater than or equal to) - &#x60;$lt&#x60; (is less than) - &#x60;$lte&#x60; (is less than or equal to)  _Note: v1 operators differ from v2 operators._  _Note: For v1 operators, excluding the &#x60;$&#x60; will result in undefined behavior._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive.  **Examples** - &#x60;GET /users?filter&#x3D;username:$eq:testuser&#x60; - &#x60;GET /systemusers?filter&#x3D;password_expiration_date:$lte:2021-10-24&#x60; - &#x60;GET /systemusers?filter&#x3D;department:$ne:Accounting&#x60; - &#x60;GET /systems?filter[0]&#x3D;firstname:$eq:foo&amp;filter[1]&#x3D;lastname:$eq:bar&#x60; - this will    AND the filters together. - &#x60;GET /systems?filter[or][0]&#x3D;lastname:$eq:foo&amp;filter[or][1]&#x3D;lastname:$eq:bar&#x60; - this will    OR the filters together.
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @return [Array<(Systemuserslist, Integer, Hash)>] Systemuserslist data, response status code and response headers
    def search_systemusers_post_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SearchApi.search_systemusers_post ...'
      end
      # resource path
      local_var_path = '/search/systemusers'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fields'] = opts[:'fields'] if !opts[:'fields'].nil?
      query_params[:'filter'] = opts[:'filter'] if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?

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

      return_type = opts[:return_type] || 'Systemuserslist' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SearchApi#search_systemusers_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
