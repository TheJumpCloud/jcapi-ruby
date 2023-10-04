=begin
#JumpCloud API

## Overview  JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.  ## API Best Practices  Read the linked Help Article below for guidance on retrying failed requests to JumpCloud's REST API, as well as best practices for structuring subsequent retry requests. Customizing retry mechanisms based on these recommendations will increase the reliability and dependability of your API calls.  Covered topics include: 1. Important Considerations 2. Supported HTTP Request Methods 3. Response codes 4. API Key rotation 5. Paginating 6. Error handling 7. Retry rates  [JumpCloud Help Center - API Best Practices](https://support.jumpcloud.com/support/s/article/JumpCloud-API-Best-Practices)  # Directory Objects  This API offers the ability to interact with some of our core features; otherwise known as Directory Objects. The Directory Objects are:  * Commands * Policies * Policy Groups * Applications * Systems * Users * User Groups * System Groups * Radius Servers * Directories: Office 365, LDAP,G-Suite, Active Directory * Duo accounts and applications.  The Directory Object is an important concept to understand in order to successfully use JumpCloud API.  ## JumpCloud Graph  We've also introduced the concept of the JumpCloud Graph along with  Directory Objects. The Graph is a powerful aspect of our platform which will enable you to associate objects with each other, or establish membership for certain objects to become members of other objects.  Specific `GET` endpoints will allow you to traverse the JumpCloud Graph to return all indirect and directly bound objects in your organization.  | ![alt text](https://s3.amazonaws.com/jumpcloud-kb/Knowledge+Base+Photos/API+Docs/jumpcloud_graph.png \"JumpCloud Graph Model Example\") | |:--:| | **This diagram highlights our association and membership model as it relates to Directory Objects.** |  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/v2/systemgroups\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 2.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.47
=end

module JCAPIv2
  class GSuiteApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Delete a domain from a Google Workspace integration instance
    # Delete a domain from a specific Google Workspace directory sync integration instance.  #### Sample Request ``` curl -X DELETE https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/domains/{domainId} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param gsuite_id Id for the specific Google Workspace directory sync integration instance.
    # @param domain_id Id for the domain.
    # @param [Hash] opts the optional parameters
    # @return [JumpcloudGappsDomainResponse]
    def gapps_domains_delete(gsuite_id, domain_id, opts = {})
      data, _status_code, _headers = gapps_domains_delete_with_http_info(gsuite_id, domain_id, opts)
      data
    end

    # Delete a domain from a Google Workspace integration instance
    # Delete a domain from a specific Google Workspace directory sync integration instance.  #### Sample Request &#x60;&#x60;&#x60; curl -X DELETE https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/domains/{domainId} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param gsuite_id Id for the specific Google Workspace directory sync integration instance.
    # @param domain_id Id for the domain.
    # @param [Hash] opts the optional parameters
    # @return [Array<(JumpcloudGappsDomainResponse, Integer, Hash)>] JumpcloudGappsDomainResponse data, response status code and response headers
    def gapps_domains_delete_with_http_info(gsuite_id, domain_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GSuiteApi.gapps_domains_delete ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.gapps_domains_delete"
      end
      # verify the required parameter 'domain_id' is set
      if @api_client.config.client_side_validation && domain_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_id' when calling GSuiteApi.gapps_domains_delete"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/domains/{domainId}'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s).sub('{' + 'domainId' + '}', domain_id.to_s)

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

      return_type = opts[:return_type] || 'JumpcloudGappsDomainResponse' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GSuiteApi#gapps_domains_delete\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Add a domain to a Google Workspace integration instance
    # Add a domain to a specific Google Workspace directory sync integration instance. The domain must be a verified domain in Google Workspace.  #### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/domains \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{\"domain\": \"{domain name}\"}' ```
    # @param gsuite_id Id for the specific Google Workspace directory sync integration instance.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :domain 
    # @return [JumpcloudGappsDomainResponse]
    def gapps_domains_insert(gsuite_id, opts = {})
      data, _status_code, _headers = gapps_domains_insert_with_http_info(gsuite_id, opts)
      data
    end

    # Add a domain to a Google Workspace integration instance
    # Add a domain to a specific Google Workspace directory sync integration instance. The domain must be a verified domain in Google Workspace.  #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/domains \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{\&quot;domain\&quot;: \&quot;{domain name}\&quot;}&#x27; &#x60;&#x60;&#x60;
    # @param gsuite_id Id for the specific Google Workspace directory sync integration instance.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :domain 
    # @return [Array<(JumpcloudGappsDomainResponse, Integer, Hash)>] JumpcloudGappsDomainResponse data, response status code and response headers
    def gapps_domains_insert_with_http_info(gsuite_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GSuiteApi.gapps_domains_insert ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.gapps_domains_insert"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/domains'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'domain'] = opts[:'domain'] if !opts[:'domain'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'JumpcloudGappsDomainResponse' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GSuiteApi#gapps_domains_insert\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List all domains configured for the Google Workspace integration instance
    # List the domains configured for a specific Google Workspace directory sync integration instance.  #### Sample Request ``` curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/domains \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param gsuite_id Id for the specific Google Workspace directory sync integration instance..
    # @param [Hash] opts the optional parameters
    # @option opts [String] :limit The number of records to return at once. Limited to 100. (default to 100)
    # @option opts [String] :skip The offset into the records to return. (default to 0)
    # @return [JumpcloudGappsDomainListResponse]
    def gapps_domains_list(gsuite_id, opts = {})
      data, _status_code, _headers = gapps_domains_list_with_http_info(gsuite_id, opts)
      data
    end

    # List all domains configured for the Google Workspace integration instance
    # List the domains configured for a specific Google Workspace directory sync integration instance.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/domains \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param gsuite_id Id for the specific Google Workspace directory sync integration instance..
    # @param [Hash] opts the optional parameters
    # @option opts [String] :limit The number of records to return at once. Limited to 100.
    # @option opts [String] :skip The offset into the records to return.
    # @return [Array<(JumpcloudGappsDomainListResponse, Integer, Hash)>] JumpcloudGappsDomainListResponse data, response status code and response headers
    def gapps_domains_list_with_http_info(gsuite_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GSuiteApi.gapps_domains_list ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.gapps_domains_list"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/domains'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s)

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

      return_type = opts[:return_type] || 'JumpcloudGappsDomainListResponse' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GSuiteApi#gapps_domains_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
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
        @api_client.config.logger.debug 'Calling API: GSuiteApi.graph_g_suite_associations_list ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.graph_g_suite_associations_list"
      end
      # verify the required parameter 'targets' is set
      if @api_client.config.client_side_validation && targets.nil?
        fail ArgumentError, "Missing the required parameter 'targets' when calling GSuiteApi.graph_g_suite_associations_list"
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
        @api_client.config.logger.debug "API called: GSuiteApi#graph_g_suite_associations_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
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
        @api_client.config.logger.debug 'Calling API: GSuiteApi.graph_g_suite_associations_post ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.graph_g_suite_associations_post"
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
        @api_client.config.logger.debug "API called: GSuiteApi#graph_g_suite_associations_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
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
        @api_client.config.logger.debug 'Calling API: GSuiteApi.graph_g_suite_traverse_user ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.graph_g_suite_traverse_user"
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
        @api_client.config.logger.debug "API called: GSuiteApi#graph_g_suite_traverse_user\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
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
        @api_client.config.logger.debug 'Calling API: GSuiteApi.graph_g_suite_traverse_user_group ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.graph_g_suite_traverse_user_group"
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
        @api_client.config.logger.debug "API called: GSuiteApi#graph_g_suite_traverse_user_group\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get G Suite
    # This endpoint returns a specific G Suite.  ##### Sample Request  ```  curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{GSUITE_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```
    # @param id Unique identifier of the GSuite.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Gsuite]
    def gsuites_get(id, opts = {})
      data, _status_code, _headers = gsuites_get_with_http_info(id, opts)
      data
    end

    # Get G Suite
    # This endpoint returns a specific G Suite.  ##### Sample Request  &#x60;&#x60;&#x60;  curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{GSUITE_ID} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
    # @param id Unique identifier of the GSuite.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Gsuite, Integer, Hash)>] Gsuite data, response status code and response headers
    def gsuites_get_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GSuiteApi.gsuites_get ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling GSuiteApi.gsuites_get"
      end
      # resource path
      local_var_path = '/gsuites/{id}'.sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'Gsuite' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GSuiteApi#gsuites_get\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get a list of users in Jumpcloud format to import from a Google Workspace account.
    # Lists available G Suite users for import, translated to the Jumpcloud user schema.
    # @param gsuite_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :max_results Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @option opts [String] :order_by Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @option opts [String] :page_token Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @option opts [String] :query Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users.
    # @option opts [String] :sort_order Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @return [InlineResponse2001]
    def gsuites_list_import_jumpcloud_users(gsuite_id, opts = {})
      data, _status_code, _headers = gsuites_list_import_jumpcloud_users_with_http_info(gsuite_id, opts)
      data
    end

    # Get a list of users in Jumpcloud format to import from a Google Workspace account.
    # Lists available G Suite users for import, translated to the Jumpcloud user schema.
    # @param gsuite_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :max_results Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @option opts [String] :order_by Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @option opts [String] :page_token Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @option opts [String] :query Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users.
    # @option opts [String] :sort_order Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @return [Array<(InlineResponse2001, Integer, Hash)>] InlineResponse2001 data, response status code and response headers
    def gsuites_list_import_jumpcloud_users_with_http_info(gsuite_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GSuiteApi.gsuites_list_import_jumpcloud_users ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.gsuites_list_import_jumpcloud_users"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/import/jumpcloudusers'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'maxResults'] = opts[:'max_results'] if !opts[:'max_results'].nil?
      query_params[:'orderBy'] = opts[:'order_by'] if !opts[:'order_by'].nil?
      query_params[:'pageToken'] = opts[:'page_token'] if !opts[:'page_token'].nil?
      query_params[:'query'] = opts[:'query'] if !opts[:'query'].nil?
      query_params[:'sortOrder'] = opts[:'sort_order'] if !opts[:'sort_order'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'InlineResponse2001' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GSuiteApi#gsuites_list_import_jumpcloud_users\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get a list of users to import from a G Suite instance
    # Lists G Suite users available for import.
    # @param gsuite_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :max_results Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @option opts [String] :order_by Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @option opts [String] :page_token Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @option opts [String] :query Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users.
    # @option opts [String] :sort_order Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @return [InlineResponse2002]
    def gsuites_list_import_users(gsuite_id, opts = {})
      data, _status_code, _headers = gsuites_list_import_users_with_http_info(gsuite_id, opts)
      data
    end

    # Get a list of users to import from a G Suite instance
    # Lists G Suite users available for import.
    # @param gsuite_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :max_results Google Directory API maximum number of results per page. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @option opts [String] :order_by Google Directory API sort field parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @option opts [String] :page_token Google Directory API token used to access the next page of results. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @option opts [String] :query Google Directory API search parameter. See https://developers.google.com/admin-sdk/directory/v1/guides/search-users.
    # @option opts [String] :sort_order Google Directory API sort direction parameter. See https://developers.google.com/admin-sdk/directory/reference/rest/v1/users/list.
    # @return [Array<(InlineResponse2002, Integer, Hash)>] InlineResponse2002 data, response status code and response headers
    def gsuites_list_import_users_with_http_info(gsuite_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GSuiteApi.gsuites_list_import_users ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.gsuites_list_import_users"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/import/users'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'maxResults'] = opts[:'max_results'] if !opts[:'max_results'].nil?
      query_params[:'orderBy'] = opts[:'order_by'] if !opts[:'order_by'].nil?
      query_params[:'pageToken'] = opts[:'page_token'] if !opts[:'page_token'].nil?
      query_params[:'query'] = opts[:'query'] if !opts[:'query'].nil?
      query_params[:'sortOrder'] = opts[:'sort_order'] if !opts[:'sort_order'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'InlineResponse2002' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GSuiteApi#gsuites_list_import_users\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Update existing G Suite
    # This endpoint allows updating some attributes of a G Suite.  ##### Sample Request  ``` curl -X PATCH https://console.jumpcloud.com/api/v2/gsuites/{GSUITE_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"userLockoutAction\": \"suspend\",     \"userPasswordExpirationAction\": \"maintain\"   }' ``` Sample Request, set a default domain  ``` curl -X PATCH https://console.jumpcloud.com/api/v2/gsuites/{GSUITE_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"defaultDomain\": {         \"id\": \"{domainObjectID}\"       }   }' ```  Sample Request, unset the default domain  ``` curl -X PATCH https://console.jumpcloud.com/api/v2/gsuites/{GSUITE_ID} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     \"defaultDomain\": {}   }' ```
    # @param id Unique identifier of the GSuite.
    # @param [Hash] opts the optional parameters
    # @option opts [Gsuite] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Gsuite]
    def gsuites_patch(id, opts = {})
      data, _status_code, _headers = gsuites_patch_with_http_info(id, opts)
      data
    end

    # Update existing G Suite
    # This endpoint allows updating some attributes of a G Suite.  ##### Sample Request  &#x60;&#x60;&#x60; curl -X PATCH https://console.jumpcloud.com/api/v2/gsuites/{GSUITE_ID} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;userLockoutAction\&quot;: \&quot;suspend\&quot;,     \&quot;userPasswordExpirationAction\&quot;: \&quot;maintain\&quot;   }&#x27; &#x60;&#x60;&#x60; Sample Request, set a default domain  &#x60;&#x60;&#x60; curl -X PATCH https://console.jumpcloud.com/api/v2/gsuites/{GSUITE_ID} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;defaultDomain\&quot;: {         \&quot;id\&quot;: \&quot;{domainObjectID}\&quot;       }   }&#x27; &#x60;&#x60;&#x60;  Sample Request, unset the default domain  &#x60;&#x60;&#x60; curl -X PATCH https://console.jumpcloud.com/api/v2/gsuites/{GSUITE_ID} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;defaultDomain\&quot;: {}   }&#x27; &#x60;&#x60;&#x60;
    # @param id Unique identifier of the GSuite.
    # @param [Hash] opts the optional parameters
    # @option opts [Gsuite] :body 
    # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
    # @return [Array<(Gsuite, Integer, Hash)>] Gsuite data, response status code and response headers
    def gsuites_patch_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GSuiteApi.gsuites_patch ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling GSuiteApi.gsuites_patch"
      end
      # resource path
      local_var_path = '/gsuites/{id}'.sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'Gsuite' 

      auth_names = opts[:auth_names] || []
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GSuiteApi#gsuites_patch\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Deletes a G Suite translation rule
    # This endpoint allows you to delete a translation rule for a specific G Suite instance. These rules specify how JumpCloud attributes translate to [G Suite Admin SDK](https://developers.google.com/admin-sdk/directory/) attributes.  #### Sample Request  ``` curl -X DELETE https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/translationrules/{id} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```
    # @param gsuite_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def translation_rules_g_suite_delete(gsuite_id, id, opts = {})
      translation_rules_g_suite_delete_with_http_info(gsuite_id, id, opts)
      nil
    end

    # Deletes a G Suite translation rule
    # This endpoint allows you to delete a translation rule for a specific G Suite instance. These rules specify how JumpCloud attributes translate to [G Suite Admin SDK](https://developers.google.com/admin-sdk/directory/) attributes.  #### Sample Request  &#x60;&#x60;&#x60; curl -X DELETE https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/translationrules/{id} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;   &#x60;&#x60;&#x60;
    # @param gsuite_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def translation_rules_g_suite_delete_with_http_info(gsuite_id, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GSuiteApi.translation_rules_g_suite_delete ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.translation_rules_g_suite_delete"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling GSuiteApi.translation_rules_g_suite_delete"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/translationrules/{id}'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s).sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}

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
        @api_client.config.logger.debug "API called: GSuiteApi#translation_rules_g_suite_delete\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Gets a specific G Suite translation rule
    # This endpoint returns a specific translation rule for a specific G Suite instance. These rules specify how JumpCloud attributes translate to [G Suite Admin SDK](https://developers.google.com/admin-sdk/directory/) attributes.  ###### Sample Request  ```   curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/translationrules/{id} \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```
    # @param gsuite_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [GSuiteTranslationRule]
    def translation_rules_g_suite_get(gsuite_id, id, opts = {})
      data, _status_code, _headers = translation_rules_g_suite_get_with_http_info(gsuite_id, id, opts)
      data
    end

    # Gets a specific G Suite translation rule
    # This endpoint returns a specific translation rule for a specific G Suite instance. These rules specify how JumpCloud attributes translate to [G Suite Admin SDK](https://developers.google.com/admin-sdk/directory/) attributes.  ###### Sample Request  &#x60;&#x60;&#x60;   curl -X GET https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/translationrules/{id} \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;   &#x60;&#x60;&#x60;
    # @param gsuite_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(GSuiteTranslationRule, Integer, Hash)>] GSuiteTranslationRule data, response status code and response headers
    def translation_rules_g_suite_get_with_http_info(gsuite_id, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GSuiteApi.translation_rules_g_suite_get ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.translation_rules_g_suite_get"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling GSuiteApi.translation_rules_g_suite_get"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/translationrules/{id}'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s).sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'GSuiteTranslationRule' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GSuiteApi#translation_rules_g_suite_get\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List all the G Suite Translation Rules
    # This endpoint returns all graph translation rules for a specific G Suite instance. These rules specify how JumpCloud attributes translate to [G Suite Admin SDK](https://developers.google.com/admin-sdk/directory/) attributes.  ##### Sample Request  ``` curl -X GET  https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/translationrules \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}'   ```
    # @param gsuite_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @return [Array<GSuiteTranslationRule>]
    def translation_rules_g_suite_list(gsuite_id, opts = {})
      data, _status_code, _headers = translation_rules_g_suite_list_with_http_info(gsuite_id, opts)
      data
    end

    # List all the G Suite Translation Rules
    # This endpoint returns all graph translation rules for a specific G Suite instance. These rules specify how JumpCloud attributes translate to [G Suite Admin SDK](https://developers.google.com/admin-sdk/directory/) attributes.  ##### Sample Request  &#x60;&#x60;&#x60; curl -X GET  https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/translationrules \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27;   &#x60;&#x60;&#x60;
    # @param gsuite_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @return [Array<(Array<GSuiteTranslationRule>, Integer, Hash)>] Array<GSuiteTranslationRule> data, response status code and response headers
    def translation_rules_g_suite_list_with_http_info(gsuite_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GSuiteApi.translation_rules_g_suite_list ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.translation_rules_g_suite_list"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/translationrules'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s)

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

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Array<GSuiteTranslationRule>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GSuiteApi#translation_rules_g_suite_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create a new G Suite Translation Rule
    # This endpoint allows you to create a translation rule for a specific G Suite instance. These rules specify how JumpCloud attributes translate to [G Suite Admin SDK](https://developers.google.com/admin-sdk/directory/) attributes.  ##### Sample Request ``` curl -X POST https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/translationrules \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -d '{     {Translation Rule Parameters}   }' ```
    # @param gsuite_id 
    # @param [Hash] opts the optional parameters
    # @option opts [GSuiteTranslationRuleRequest] :body 
    # @return [GSuiteTranslationRule]
    def translation_rules_g_suite_post(gsuite_id, opts = {})
      data, _status_code, _headers = translation_rules_g_suite_post_with_http_info(gsuite_id, opts)
      data
    end

    # Create a new G Suite Translation Rule
    # This endpoint allows you to create a translation rule for a specific G Suite instance. These rules specify how JumpCloud attributes translate to [G Suite Admin SDK](https://developers.google.com/admin-sdk/directory/) attributes.  ##### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/gsuites/{gsuite_id}/translationrules \\   -H &#x27;Accept: application/json&#x27; \\   -H &#x27;Content-Type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     {Translation Rule Parameters}   }&#x27; &#x60;&#x60;&#x60;
    # @param gsuite_id 
    # @param [Hash] opts the optional parameters
    # @option opts [GSuiteTranslationRuleRequest] :body 
    # @return [Array<(GSuiteTranslationRule, Integer, Hash)>] GSuiteTranslationRule data, response status code and response headers
    def translation_rules_g_suite_post_with_http_info(gsuite_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: GSuiteApi.translation_rules_g_suite_post ...'
      end
      # verify the required parameter 'gsuite_id' is set
      if @api_client.config.client_side_validation && gsuite_id.nil?
        fail ArgumentError, "Missing the required parameter 'gsuite_id' when calling GSuiteApi.translation_rules_g_suite_post"
      end
      # resource path
      local_var_path = '/gsuites/{gsuite_id}/translationrules'.sub('{' + 'gsuite_id' + '}', gsuite_id.to_s)

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

      return_type = opts[:return_type] || 'GSuiteTranslationRule' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: GSuiteApi#translation_rules_g_suite_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
