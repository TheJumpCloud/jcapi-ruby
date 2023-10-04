=begin
#JumpCloud API

## Overview  JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.  ## API Best Practices  Read the linked Help Article below for guidance on retrying failed requests to JumpCloud's REST API, as well as best practices for structuring subsequent retry requests. Customizing retry mechanisms based on these recommendations will increase the reliability and dependability of your API calls.  Covered topics include: 1. Important Considerations 2. Supported HTTP Request Methods 3. Response codes 4. API Key rotation 5. Paginating 6. Error handling 7. Retry rates  [JumpCloud Help Center - API Best Practices](https://support.jumpcloud.com/support/s/article/JumpCloud-API-Best-Practices)  # Directory Objects  This API offers the ability to interact with some of our core features; otherwise known as Directory Objects. The Directory Objects are:  * Commands * Policies * Policy Groups * Applications * Systems * Users * User Groups * System Groups * Radius Servers * Directories: Office 365, LDAP,G-Suite, Active Directory * Duo accounts and applications.  The Directory Object is an important concept to understand in order to successfully use JumpCloud API.  ## JumpCloud Graph  We've also introduced the concept of the JumpCloud Graph along with  Directory Objects. The Graph is a powerful aspect of our platform which will enable you to associate objects with each other, or establish membership for certain objects to become members of other objects.  Specific `GET` endpoints will allow you to traverse the JumpCloud Graph to return all indirect and directly bound objects in your organization.  | ![alt text](https://s3.amazonaws.com/jumpcloud-kb/Knowledge+Base+Photos/API+Docs/jumpcloud_graph.png \"JumpCloud Graph Model Example\") | |:--:| | **This diagram highlights our association and membership model as it relates to Directory Objects.** |  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/v2/systemgroups\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 2.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.47
=end

module JCAPIv2
  class ManagedServiceProviderApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Allow Adminstrator access to an Organization.
    # This endpoint allows you to grant Administrator access to an Organization.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [AdministratorOrganizationLinkReq] :body 
    # @return [AdministratorOrganizationLink]
    def administrator_organizations_create_by_administrator(id, opts = {})
      data, _status_code, _headers = administrator_organizations_create_by_administrator_with_http_info(id, opts)
      data
    end

    # Allow Adminstrator access to an Organization.
    # This endpoint allows you to grant Administrator access to an Organization.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [AdministratorOrganizationLinkReq] :body 
    # @return [Array<(AdministratorOrganizationLink, Integer, Hash)>] AdministratorOrganizationLink data, response status code and response headers
    def administrator_organizations_create_by_administrator_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.administrator_organizations_create_by_administrator ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling ManagedServiceProviderApi.administrator_organizations_create_by_administrator"
      end
      # resource path
      local_var_path = '/administrators/{id}/organizationlinks'.sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'AdministratorOrganizationLink' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#administrator_organizations_create_by_administrator\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the association links between an Administrator and Organizations.
    # This endpoint returns the association links between an Administrator and Organizations.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @return [Array<AdministratorOrganizationLink>]
    def administrator_organizations_list_by_administrator(id, opts = {})
      data, _status_code, _headers = administrator_organizations_list_by_administrator_with_http_info(id, opts)
      data
    end

    # List the association links between an Administrator and Organizations.
    # This endpoint returns the association links between an Administrator and Organizations.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @return [Array<(Array<AdministratorOrganizationLink>, Integer, Hash)>] Array<AdministratorOrganizationLink> data, response status code and response headers
    def administrator_organizations_list_by_administrator_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.administrator_organizations_list_by_administrator ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling ManagedServiceProviderApi.administrator_organizations_list_by_administrator"
      end
      # resource path
      local_var_path = '/administrators/{id}/organizationlinks'.sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'Array<AdministratorOrganizationLink>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#administrator_organizations_list_by_administrator\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List the association links between an Organization and Administrators.
    # This endpoint returns the association links between an Organization and Administrators.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @return [Array<AdministratorOrganizationLink>]
    def administrator_organizations_list_by_organization(id, opts = {})
      data, _status_code, _headers = administrator_organizations_list_by_organization_with_http_info(id, opts)
      data
    end

    # List the association links between an Organization and Administrators.
    # This endpoint returns the association links between an Organization and Administrators.
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @return [Array<(Array<AdministratorOrganizationLink>, Integer, Hash)>] Array<AdministratorOrganizationLink> data, response status code and response headers
    def administrator_organizations_list_by_organization_with_http_info(id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.administrator_organizations_list_by_organization ...'
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling ManagedServiceProviderApi.administrator_organizations_list_by_organization"
      end
      # resource path
      local_var_path = '/organizations/{id}/administratorlinks'.sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'Array<AdministratorOrganizationLink>' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#administrator_organizations_list_by_organization\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Remove association between an Administrator and an Organization.
    # This endpoint removes the association link between an Administrator and an Organization.
    # @param administrator_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def administrator_organizations_remove_by_administrator(administrator_id, id, opts = {})
      administrator_organizations_remove_by_administrator_with_http_info(administrator_id, id, opts)
      nil
    end

    # Remove association between an Administrator and an Organization.
    # This endpoint removes the association link between an Administrator and an Organization.
    # @param administrator_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def administrator_organizations_remove_by_administrator_with_http_info(administrator_id, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.administrator_organizations_remove_by_administrator ...'
      end
      # verify the required parameter 'administrator_id' is set
      if @api_client.config.client_side_validation && administrator_id.nil?
        fail ArgumentError, "Missing the required parameter 'administrator_id' when calling ManagedServiceProviderApi.administrator_organizations_remove_by_administrator"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling ManagedServiceProviderApi.administrator_organizations_remove_by_administrator"
      end
      # resource path
      local_var_path = '/administrators/{administrator_id}/organizationlinks/{id}'.sub('{' + 'administrator_id' + '}', administrator_id.to_s).sub('{' + 'id' + '}', id.to_s)

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
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#administrator_organizations_remove_by_administrator\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Deletes policy group template.
    # Deletes a Policy Group Template.
    # @param provider_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def policy_group_templates_delete(provider_id, id, opts = {})
      policy_group_templates_delete_with_http_info(provider_id, id, opts)
      nil
    end

    # Deletes policy group template.
    # Deletes a Policy Group Template.
    # @param provider_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def policy_group_templates_delete_with_http_info(provider_id, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.policy_group_templates_delete ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.policy_group_templates_delete"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling ManagedServiceProviderApi.policy_group_templates_delete"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/policygrouptemplates/{id}'.sub('{' + 'provider_id' + '}', provider_id.to_s).sub('{' + 'id' + '}', id.to_s)

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
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#policy_group_templates_delete\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Gets a provider's policy group template.
    # Retrieves a Policy Group Template for this provider.
    # @param provider_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [PolicyGroupTemplate]
    def policy_group_templates_get(provider_id, id, opts = {})
      data, _status_code, _headers = policy_group_templates_get_with_http_info(provider_id, id, opts)
      data
    end

    # Gets a provider&#x27;s policy group template.
    # Retrieves a Policy Group Template for this provider.
    # @param provider_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(PolicyGroupTemplate, Integer, Hash)>] PolicyGroupTemplate data, response status code and response headers
    def policy_group_templates_get_with_http_info(provider_id, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.policy_group_templates_get ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.policy_group_templates_get"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling ManagedServiceProviderApi.policy_group_templates_get"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/policygrouptemplates/{id}'.sub('{' + 'provider_id' + '}', provider_id.to_s).sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'PolicyGroupTemplate' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#policy_group_templates_get\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Retrieve a configured policy template by id.
    # Retrieves a Configured Policy Templates for this provider and Id.
    # @param provider_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [ConfiguredPolicyTemplate]
    def policy_group_templates_get_configured_policy_template(provider_id, id, opts = {})
      data, _status_code, _headers = policy_group_templates_get_configured_policy_template_with_http_info(provider_id, id, opts)
      data
    end

    # Retrieve a configured policy template by id.
    # Retrieves a Configured Policy Templates for this provider and Id.
    # @param provider_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(ConfiguredPolicyTemplate, Integer, Hash)>] ConfiguredPolicyTemplate data, response status code and response headers
    def policy_group_templates_get_configured_policy_template_with_http_info(provider_id, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.policy_group_templates_get_configured_policy_template ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.policy_group_templates_get_configured_policy_template"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling ManagedServiceProviderApi.policy_group_templates_get_configured_policy_template"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/configuredpolicytemplates/{id}'.sub('{' + 'provider_id' + '}', provider_id.to_s).sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'ConfiguredPolicyTemplate' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#policy_group_templates_get_configured_policy_template\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List a provider's policy group templates.
    # Retrieves a list of Policy Group Templates for this provider.
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [PolicyGroupTemplates]
    def policy_group_templates_list(provider_id, opts = {})
      data, _status_code, _headers = policy_group_templates_list_with_http_info(provider_id, opts)
      data
    end

    # List a provider&#x27;s policy group templates.
    # Retrieves a list of Policy Group Templates for this provider.
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(PolicyGroupTemplates, Integer, Hash)>] PolicyGroupTemplates data, response status code and response headers
    def policy_group_templates_list_with_http_info(provider_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.policy_group_templates_list ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.policy_group_templates_list"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/policygrouptemplates'.sub('{' + 'provider_id' + '}', provider_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fields'] = @api_client.build_collection_param(opts[:'fields'], :csv) if !opts[:'fields'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'PolicyGroupTemplates' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#policy_group_templates_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List a provider's configured policy templates.
    # Retrieves a list of Configured Policy Templates for this provider.
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [InlineResponse20014]
    def policy_group_templates_list_configured_policy_templates(provider_id, opts = {})
      data, _status_code, _headers = policy_group_templates_list_configured_policy_templates_with_http_info(provider_id, opts)
      data
    end

    # List a provider&#x27;s configured policy templates.
    # Retrieves a list of Configured Policy Templates for this provider.
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(InlineResponse20014, Integer, Hash)>] InlineResponse20014 data, response status code and response headers
    def policy_group_templates_list_configured_policy_templates_with_http_info(provider_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.policy_group_templates_list_configured_policy_templates ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.policy_group_templates_list_configured_policy_templates"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/configuredpolicytemplates'.sub('{' + 'provider_id' + '}', provider_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'InlineResponse20014' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#policy_group_templates_list_configured_policy_templates\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Gets the list of members from a policy group template.
    # Retrieves a Policy Group Template's Members.
    # @param provider_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [PolicyGroupTemplateMembers]
    def policy_group_templates_list_members(provider_id, id, opts = {})
      data, _status_code, _headers = policy_group_templates_list_members_with_http_info(provider_id, id, opts)
      data
    end

    # Gets the list of members from a policy group template.
    # Retrieves a Policy Group Template&#x27;s Members.
    # @param provider_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(PolicyGroupTemplateMembers, Integer, Hash)>] PolicyGroupTemplateMembers data, response status code and response headers
    def policy_group_templates_list_members_with_http_info(provider_id, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.policy_group_templates_list_members ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.policy_group_templates_list_members"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling ManagedServiceProviderApi.policy_group_templates_list_members"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/policygrouptemplates/{id}/members'.sub('{' + 'provider_id' + '}', provider_id.to_s).sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'PolicyGroupTemplateMembers' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#policy_group_templates_list_members\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create Provider Organization
    # This endpoint creates a new organization under the provider
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [CreateOrganization] :body 
    # @return [Organization]
    def provider_organizations_create_org(provider_id, opts = {})
      data, _status_code, _headers = provider_organizations_create_org_with_http_info(provider_id, opts)
      data
    end

    # Create Provider Organization
    # This endpoint creates a new organization under the provider
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [CreateOrganization] :body 
    # @return [Array<(Organization, Integer, Hash)>] Organization data, response status code and response headers
    def provider_organizations_create_org_with_http_info(provider_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.provider_organizations_create_org ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.provider_organizations_create_org"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/organizations'.sub('{' + 'provider_id' + '}', provider_id.to_s)

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

      return_type = opts[:return_type] || 'Organization' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#provider_organizations_create_org\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Update Provider Organization
    # This endpoint updates a provider's organization
    # @param provider_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [Organization] :body 
    # @return [Organization]
    def provider_organizations_update_org(provider_id, id, opts = {})
      data, _status_code, _headers = provider_organizations_update_org_with_http_info(provider_id, id, opts)
      data
    end

    # Update Provider Organization
    # This endpoint updates a provider&#x27;s organization
    # @param provider_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @option opts [Organization] :body 
    # @return [Array<(Organization, Integer, Hash)>] Organization data, response status code and response headers
    def provider_organizations_update_org_with_http_info(provider_id, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.provider_organizations_update_org ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.provider_organizations_update_org"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling ManagedServiceProviderApi.provider_organizations_update_org"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/organizations/{id}'.sub('{' + 'provider_id' + '}', provider_id.to_s).sub('{' + 'id' + '}', id.to_s)

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

      return_type = opts[:return_type] || 'Organization' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#provider_organizations_update_org\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Retrieve Provider
    # This endpoint returns details about a provider
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @return [Provider]
    def providers_get_provider(provider_id, opts = {})
      data, _status_code, _headers = providers_get_provider_with_http_info(provider_id, opts)
      data
    end

    # Retrieve Provider
    # This endpoint returns details about a provider
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @return [Array<(Provider, Integer, Hash)>] Provider data, response status code and response headers
    def providers_get_provider_with_http_info(provider_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.providers_get_provider ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.providers_get_provider"
      end
      # resource path
      local_var_path = '/providers/{provider_id}'.sub('{' + 'provider_id' + '}', provider_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fields'] = @api_client.build_collection_param(opts[:'fields'], :csv) if !opts[:'fields'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'Provider' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#providers_get_provider\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Provider Administrators
    # This endpoint returns a list of the Administrators associated with the Provider. You must be associated with the provider to use this route.
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Array<String>] :sort_ignore_case The comma separated fields used to sort the collection, ignoring case. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @return [InlineResponse20013]
    def providers_list_administrators(provider_id, opts = {})
      data, _status_code, _headers = providers_list_administrators_with_http_info(provider_id, opts)
      data
    end

    # List Provider Administrators
    # This endpoint returns a list of the Administrators associated with the Provider. You must be associated with the provider to use this route.
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Array<String>] :sort_ignore_case The comma separated fields used to sort the collection, ignoring case. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @return [Array<(InlineResponse20013, Integer, Hash)>] InlineResponse20013 data, response status code and response headers
    def providers_list_administrators_with_http_info(provider_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.providers_list_administrators ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.providers_list_administrators"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/administrators'.sub('{' + 'provider_id' + '}', provider_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fields'] = @api_client.build_collection_param(opts[:'fields'], :csv) if !opts[:'fields'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'sortIgnoreCase'] = @api_client.build_collection_param(opts[:'sort_ignore_case'], :csv) if !opts[:'sort_ignore_case'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'InlineResponse20013' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#providers_list_administrators\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Provider Organizations
    # This endpoint returns a list of the Organizations associated with the Provider. You must be associated with the provider to use this route.
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Array<String>] :sort_ignore_case The comma separated fields used to sort the collection, ignoring case. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @return [InlineResponse20015]
    def providers_list_organizations(provider_id, opts = {})
      data, _status_code, _headers = providers_list_organizations_with_http_info(provider_id, opts)
      data
    end

    # List Provider Organizations
    # This endpoint returns a list of the Organizations associated with the Provider. You must be associated with the provider to use this route.
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :fields The comma separated fields included in the returned records. If omitted, the default list of fields will be returned. 
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Array<String>] :sort_ignore_case The comma separated fields used to sort the collection, ignoring case. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @return [Array<(InlineResponse20015, Integer, Hash)>] InlineResponse20015 data, response status code and response headers
    def providers_list_organizations_with_http_info(provider_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.providers_list_organizations ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.providers_list_organizations"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/organizations'.sub('{' + 'provider_id' + '}', provider_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'fields'] = @api_client.build_collection_param(opts[:'fields'], :csv) if !opts[:'fields'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'sortIgnoreCase'] = @api_client.build_collection_param(opts[:'sort_ignore_case'], :csv) if !opts[:'sort_ignore_case'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'InlineResponse20015' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#providers_list_organizations\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create a new Provider Administrator
    # This endpoint allows you to create a provider administrator. You must be associated with the provider to use this route. You must provide either `role` or `roleName`.
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [ProviderAdminReq] :body 
    # @return [Administrator]
    def providers_post_admins(provider_id, opts = {})
      data, _status_code, _headers = providers_post_admins_with_http_info(provider_id, opts)
      data
    end

    # Create a new Provider Administrator
    # This endpoint allows you to create a provider administrator. You must be associated with the provider to use this route. You must provide either &#x60;role&#x60; or &#x60;roleName&#x60;.
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [ProviderAdminReq] :body 
    # @return [Array<(Administrator, Integer, Hash)>] Administrator data, response status code and response headers
    def providers_post_admins_with_http_info(provider_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.providers_post_admins ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.providers_post_admins"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/administrators'.sub('{' + 'provider_id' + '}', provider_id.to_s)

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

      return_type = opts[:return_type] || 'Administrator' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#providers_post_admins\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get all cases (Support/Feature requests) for provider
    # This endpoint returns the cases (Support/Feature requests) for the provider
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [CasesResponse]
    def providers_provider_list_case(provider_id, opts = {})
      data, _status_code, _headers = providers_provider_list_case_with_http_info(provider_id, opts)
      data
    end

    # Get all cases (Support/Feature requests) for provider
    # This endpoint returns the cases (Support/Feature requests) for the provider
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
    # @return [Array<(CasesResponse, Integer, Hash)>] CasesResponse data, response status code and response headers
    def providers_provider_list_case_with_http_info(provider_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.providers_provider_list_case ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.providers_provider_list_case"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/cases'.sub('{' + 'provider_id' + '}', provider_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'filter'] = @api_client.build_collection_param(opts[:'filter'], :csv) if !opts[:'filter'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'CasesResponse' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#providers_provider_list_case\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Download a provider's invoice.
    # Retrieves an invoice for this provider. You must be associated to the provider to use this endpoint.
    # @param provider_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [String]
    def providers_retrieve_invoice(provider_id, id, opts = {})
      data, _status_code, _headers = providers_retrieve_invoice_with_http_info(provider_id, id, opts)
      data
    end

    # Download a provider&#x27;s invoice.
    # Retrieves an invoice for this provider. You must be associated to the provider to use this endpoint.
    # @param provider_id 
    # @param id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(String, Integer, Hash)>] String data, response status code and response headers
    def providers_retrieve_invoice_with_http_info(provider_id, id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.providers_retrieve_invoice ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.providers_retrieve_invoice"
      end
      # verify the required parameter 'id' is set
      if @api_client.config.client_side_validation && id.nil?
        fail ArgumentError, "Missing the required parameter 'id' when calling ManagedServiceProviderApi.providers_retrieve_invoice"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/invoices/{ID}'.sub('{' + 'provider_id' + '}', provider_id.to_s).sub('{' + 'ID' + '}', id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/pdf'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'String' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#providers_retrieve_invoice\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List a provider's invoices.
    # Retrieves a list of invoices for this provider. You must be associated to the provider to use this endpoint.
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100. (default to 10)
    # @return [ProviderInvoiceResponse]
    def providers_retrieve_invoices(provider_id, opts = {})
      data, _status_code, _headers = providers_retrieve_invoices_with_http_info(provider_id, opts)
      data
    end

    # List a provider&#x27;s invoices.
    # Retrieves a list of invoices for this provider. You must be associated to the provider to use this endpoint.
    # @param provider_id 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
    # @return [Array<(ProviderInvoiceResponse, Integer, Hash)>] ProviderInvoiceResponse data, response status code and response headers
    def providers_retrieve_invoices_with_http_info(provider_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagedServiceProviderApi.providers_retrieve_invoices ...'
      end
      # verify the required parameter 'provider_id' is set
      if @api_client.config.client_side_validation && provider_id.nil?
        fail ArgumentError, "Missing the required parameter 'provider_id' when calling ManagedServiceProviderApi.providers_retrieve_invoices"
      end
      # resource path
      local_var_path = '/providers/{provider_id}/invoices'.sub('{' + 'provider_id' + '}', provider_id.to_s)

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = @api_client.build_collection_param(opts[:'sort'], :csv) if !opts[:'sort'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      return_type = opts[:return_type] || 'ProviderInvoiceResponse' 

      auth_names = opts[:auth_names] || ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type)

      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagedServiceProviderApi#providers_retrieve_invoices\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
