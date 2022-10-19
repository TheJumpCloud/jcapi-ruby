=begin
#JumpCloud API

## Overview  JumpCloud's V1 API. This set of endpoints allows JumpCloud customers to manage commands, systems, and system users.  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/systemusers\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 1.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.32
=end

# Common files
require 'jcapiv1/api_client'
require 'jcapiv1/api_error'
require 'jcapiv1/version'
require 'jcapiv1/configuration'

# Models
require 'jcapiv1/models/application'
require 'jcapiv1/models/application_config'
require 'jcapiv1/models/application_config_acs_url'
require 'jcapiv1/models/application_config_acs_url_tooltip'
require 'jcapiv1/models/application_config_acs_url_tooltip_variables'
require 'jcapiv1/models/application_config_constant_attributes'
require 'jcapiv1/models/application_config_constant_attributes_value'
require 'jcapiv1/models/application_config_database_attributes'
require 'jcapiv1/models/application_logo'
require 'jcapiv1/models/applicationslist'
require 'jcapiv1/models/applicationtemplate'
require 'jcapiv1/models/applicationtemplate_jit'
require 'jcapiv1/models/applicationtemplate_logo'
require 'jcapiv1/models/applicationtemplate_oidc'
require 'jcapiv1/models/applicationtemplate_provision'
require 'jcapiv1/models/applicationtemplateslist'
require 'jcapiv1/models/command'
require 'jcapiv1/models/commandfilereturn'
require 'jcapiv1/models/commandfilereturn_results'
require 'jcapiv1/models/commandresult'
require 'jcapiv1/models/commandresult_response'
require 'jcapiv1/models/commandresult_response_data'
require 'jcapiv1/models/commandresultslist'
require 'jcapiv1/models/commandresultslist_results'
require 'jcapiv1/models/commandslist'
require 'jcapiv1/models/commandslist_results'
require 'jcapiv1/models/error'
require 'jcapiv1/models/error_details'
require 'jcapiv1/models/fde'
require 'jcapiv1/models/id_resetmfa_body'
require 'jcapiv1/models/mfa'
require 'jcapiv1/models/mfa_enrollment'
require 'jcapiv1/models/mfa_enrollment_status'
require 'jcapiv1/models/organization'
require 'jcapiv1/models/organizationentitlement'
require 'jcapiv1/models/organizationentitlement_entitlement_products'
require 'jcapiv1/models/organizations_id_body'
require 'jcapiv1/models/organizationsettings'
require 'jcapiv1/models/organizationsettings_display_preferences'
require 'jcapiv1/models/organizationsettings_display_preferences_org_insights'
require 'jcapiv1/models/organizationsettings_display_preferences_org_insights_applications_usage'
require 'jcapiv1/models/organizationsettings_display_preferences_org_insights_console_stats'
require 'jcapiv1/models/organizationsettings_display_preferences_org_insights_device_notifications'
require 'jcapiv1/models/organizationsettings_display_preferences_org_insights_user_notifications'
require 'jcapiv1/models/organizationsettings_features'
require 'jcapiv1/models/organizationsettings_features_directory_insights'
require 'jcapiv1/models/organizationsettings_features_directory_insights_premium'
require 'jcapiv1/models/organizationsettings_features_system_insights'
require 'jcapiv1/models/organizationsettings_new_system_user_state_defaults'
require 'jcapiv1/models/organizationsettings_password_policy'
require 'jcapiv1/models/organizationsettings_user_portal'
require 'jcapiv1/models/organizationsettingsput'
require 'jcapiv1/models/organizationsettingsput_new_system_user_state_defaults'
require 'jcapiv1/models/organizationsettingsput_password_policy'
require 'jcapiv1/models/organizationslist'
require 'jcapiv1/models/organizationslist_results'
require 'jcapiv1/models/radiusserver'
require 'jcapiv1/models/radiusserverpost'
require 'jcapiv1/models/radiusserverput'
require 'jcapiv1/models/radiusservers_id_body'
require 'jcapiv1/models/radiusserverslist'
require 'jcapiv1/models/search'
require 'jcapiv1/models/sshkeylist'
require 'jcapiv1/models/sshkeypost'
require 'jcapiv1/models/sso'
require 'jcapiv1/models/state_activate_body'
require 'jcapiv1/models/system'
require 'jcapiv1/models/system_built_in_commands'
require 'jcapiv1/models/system_domain_info'
require 'jcapiv1/models/system_mdm'
require 'jcapiv1/models/system_mdm_internal'
require 'jcapiv1/models/system_network_interfaces'
require 'jcapiv1/models/system_os_version_detail'
require 'jcapiv1/models/system_provision_metadata'
require 'jcapiv1/models/system_provision_metadata_provisioner'
require 'jcapiv1/models/system_service_account_state'
require 'jcapiv1/models/system_sshd_params'
require 'jcapiv1/models/system_system_insights'
require 'jcapiv1/models/system_user_metrics'
require 'jcapiv1/models/systemput'
require 'jcapiv1/models/systemput_agent_bound_messages'
require 'jcapiv1/models/systemslist'
require 'jcapiv1/models/systemuserput'
require 'jcapiv1/models/systemuserput_addresses'
require 'jcapiv1/models/systemuserput_attributes'
require 'jcapiv1/models/systemuserput_phone_numbers'
require 'jcapiv1/models/systemuserput_relationships'
require 'jcapiv1/models/systemuserputpost'
require 'jcapiv1/models/systemuserputpost_addresses'
require 'jcapiv1/models/systemuserputpost_phone_numbers'
require 'jcapiv1/models/systemuserputpost_recovery_email'
require 'jcapiv1/models/systemuserreturn'
require 'jcapiv1/models/systemuserreturn_addresses'
require 'jcapiv1/models/systemuserreturn_phone_numbers'
require 'jcapiv1/models/systemuserreturn_recovery_email'
require 'jcapiv1/models/systemuserslist'
require 'jcapiv1/models/triggerreturn'
require 'jcapiv1/models/trustedapp_config_get'
require 'jcapiv1/models/trustedapp_config_get_trusted_apps'
require 'jcapiv1/models/trustedapp_config_put'
require 'jcapiv1/models/userput'
require 'jcapiv1/models/userreturn'
require 'jcapiv1/models/userreturn_growth_data'

# APIs
require 'jcapiv1/api/application_templates_api'
require 'jcapiv1/api/applications_api'
require 'jcapiv1/api/command_results_api'
require 'jcapiv1/api/command_triggers_api'
require 'jcapiv1/api/commands_api'
require 'jcapiv1/api/managed_service_provider_api'
require 'jcapiv1/api/organizations_api'
require 'jcapiv1/api/radius_servers_api'
require 'jcapiv1/api/search_api'
require 'jcapiv1/api/systems_api'
require 'jcapiv1/api/systemusers_api'
require 'jcapiv1/api/users_api'

module JCAPIv1
  class << self
    # Customize default settings for the SDK using block.
    #   JCAPIv1.configure do |config|
    #     config.username = "xxx"
    #     config.password = "xxx"
    #   end
    # If no block given, return the default Configuration object.
    def configure
      if block_given?
        yield(Configuration.default)
      else
        Configuration.default
      end
    end
  end
end
