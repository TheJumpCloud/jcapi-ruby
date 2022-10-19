=begin
#JumpCloud API

## Overview  JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.  # Directory Objects  This API offers the ability to interact with some of our core features; otherwise known as Directory Objects. The Directory Objects are:  * Commands * Policies * Policy Groups * Applications * Systems * Users * User Groups * System Groups * Radius Servers * Directories: Office 365, LDAP,G-Suite, Active Directory * Duo accounts and applications.  The Directory Object is an important concept to understand in order to successfully use JumpCloud API.  ## JumpCloud Graph  We've also introduced the concept of the JumpCloud Graph along with  Directory Objects. The Graph is a powerful aspect of our platform which will enable you to associate objects with each other, or establish membership for certain objects to become members of other objects.  Specific `GET` endpoints will allow you to traverse the JumpCloud Graph to return all indirect and directly bound objects in your organization.  | ![alt text](https://s3.amazonaws.com/jumpcloud-kb/Knowledge+Base+Photos/API+Docs/jumpcloud_graph.png \"JumpCloud Graph Model Example\") | |:--:| | **This diagram highlights our association and membership model as it relates to Directory Objects.** |  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/v2/systemgroups\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 2.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.32
=end

require 'spec_helper'
require 'json'

# Unit tests for JCAPIv2::AppleMDMApi
# Automatically generated by swagger-codegen (github.com/swagger-api/swagger-codegen)
# Please update as you see appropriate
describe 'AppleMDMApi' do
  before do
    # run before each test
    @instance = JCAPIv2::AppleMDMApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of AppleMDMApi' do
    it 'should create an instance of AppleMDMApi' do
      expect(@instance).to be_instance_of(JCAPIv2::AppleMDMApi)
    end
  end

  # unit tests for applemdms_csrget
  # Get Apple MDM CSR Plist
  # Retrieves an Apple MDM signed CSR Plist for an organization.  The user must supply the returned plist to Apple for signing, and then provide the certificate provided by Apple back into the PUT API.  #### Sample Request &#x60;&#x60;&#x60;   curl -X GET https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/csr \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [AppleMdmSignedCsrPlist]
  describe 'applemdms_csrget test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_delete
  # Delete an Apple MDM
  # Removes an Apple MDM configuration.  Warning: This is a destructive operation and will remove your Apple Push Certificates.  We will no longer be able to manage your devices and the only recovery option is to re-register all devices into MDM.  #### Sample Request &#x60;&#x60;&#x60; curl -X DELETE https://console.jumpcloud.com/api/v2/applemdms/{id} \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
  # @param id 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [AppleMDM]
  describe 'applemdms_delete test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_deletedevice
  # Remove an Apple MDM Device&#x27;s Enrollment
  # Remove a single Apple MDM device from MDM enrollment.  #### Sample Request &#x60;&#x60;&#x60;   curl -X DELETE https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id} \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param device_id 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [AppleMdmDevice]
  describe 'applemdms_deletedevice test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_depkeyget
  # Get Apple MDM DEP Public Key
  # Retrieves an Apple MDM DEP Public Key.
  # @param apple_mdm_id 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [AppleMdmPublicKeyCert]
  describe 'applemdms_depkeyget test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_devices_clear_activation_lock
  # Clears the Activation Lock for a Device
  # Clears the activation lock on the specified device.  #### Sample Request &#x60;&#x60;&#x60;   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/clearActivationLock \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param device_id 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [nil]
  describe 'applemdms_devices_clear_activation_lock test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_devices_refresh_activation_lock_information
  # Refresh activation lock information for a device
  # Refreshes the activation lock information for a device  #### Sample Request  &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/refreshActivationLockInformation \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param device_id 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [nil]
  describe 'applemdms_devices_refresh_activation_lock_information test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_deviceserase
  # Erase Device
  # Erases a DEP-enrolled device.  #### Sample Request &#x60;&#x60;&#x60;   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/erase \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param device_id 
  # @param [Hash] opts the optional parameters
  # @option opts [DeviceIdEraseBody] :body 
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [nil]
  describe 'applemdms_deviceserase test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_deviceslist
  # List AppleMDM Devices
  # Lists all Apple MDM devices.  The filter and sort queries will allow the following fields: &#x60;createdAt&#x60; &#x60;depRegistered&#x60; &#x60;enrolled&#x60; &#x60;id&#x60; &#x60;osVersion&#x60; &#x60;serialNumber&#x60; &#x60;udid&#x60;  #### Sample Request &#x60;&#x60;&#x60;   curl -X GET https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter A filter to apply to the query.  **Filter structure**: &#x60;&lt;field&gt;:&lt;operator&gt;:&lt;value&gt;&#x60;.  **field** &#x3D; Populate with a valid field from an endpoint response.  **operator** &#x3D;  Supported operators are: eq, ne, gt, ge, lt, le, between, search, in. _Note: v1 operators differ from v2 operators._  **value** &#x3D; Populate with the value you want to search for. Is case sensitive. Supports wild cards.  **EX:** &#x60;GET /api/v2/groups?filter&#x3D;name:eq:Test+Group&#x60;
  # @option opts [Array<String>] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
  # @option opts [Integer] :x_total_count 
  # @return [Array<AppleMdmDevice>]
  describe 'applemdms_deviceslist test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_deviceslock
  # Lock Device
  # Locks a DEP-enrolled device.  #### Sample Request &#x60;&#x60;&#x60;   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/lock \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param device_id 
  # @param [Hash] opts the optional parameters
  # @option opts [DeviceIdLockBody] :body 
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [nil]
  describe 'applemdms_deviceslock test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_devicesrestart
  # Restart Device
  # Restarts a DEP-enrolled device.  #### Sample Request &#x60;&#x60;&#x60;   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/restart \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{\&quot;kextPaths\&quot;: [\&quot;Path1\&quot;, \&quot;Path2\&quot;]}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param device_id 
  # @param [Hash] opts the optional parameters
  # @option opts [DeviceIdRestartBody] :body 
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [nil]
  describe 'applemdms_devicesrestart test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_devicesshutdown
  # Shut Down Device
  # Shuts down a DEP-enrolled device.  #### Sample Request &#x60;&#x60;&#x60;   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id}/shutdown \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param device_id 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [nil]
  describe 'applemdms_devicesshutdown test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_enrollmentprofilesget
  # Get an Apple MDM Enrollment Profile
  # Get an enrollment profile  Currently only requesting the mobileconfig is supported.  #### Sample Request  &#x60;&#x60;&#x60; curl https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/enrollmentprofiles/{ID} \\   -H &#x27;accept: application/x-apple-aspen-config&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param id 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [Mobileconfig]
  describe 'applemdms_enrollmentprofilesget test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_enrollmentprofileslist
  # List Apple MDM Enrollment Profiles
  # Get a list of enrollment profiles for an apple mdm.  Note: currently only one enrollment profile is supported.  #### Sample Request &#x60;&#x60;&#x60;  curl https://console.jumpcloud.com/api/v2/applemdms/{APPLE_MDM_ID}/enrollmentprofiles \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [Array<AppleMDM>]
  describe 'applemdms_enrollmentprofileslist test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_getdevice
  # Details of an AppleMDM Device
  # Gets a single Apple MDM device.  #### Sample Request &#x60;&#x60;&#x60;   curl -X GET https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/devices/{device_id} \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param device_id 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [AppleMdmDevice]
  describe 'applemdms_getdevice test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_list
  # List Apple MDMs
  # Get a list of all Apple MDM configurations.  An empty topic indicates that a signed certificate from Apple has not been provided to the PUT endpoint yet.  Note: currently only one MDM configuration per organization is supported.  #### Sample Request &#x60;&#x60;&#x60; curl https://console.jumpcloud.com/api/v2/applemdms \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; &#x60;&#x60;&#x60;
  # @param [Hash] opts the optional parameters
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [Array<AppleMDM>]
  describe 'applemdms_list test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_put
  # Update an Apple MDM
  # Updates an Apple MDM configuration.  This endpoint is used to supply JumpCloud with a signed certificate from Apple in order to finalize the setup and allow JumpCloud to manage your devices.  It may also be used to update the DEP Settings.  #### Sample Request &#x60;&#x60;&#x60;   curl -X PUT https://console.jumpcloud.com/api/v2/applemdms/{ID} \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{     \&quot;name\&quot;: \&quot;MDM name\&quot;,     \&quot;appleSignedCert\&quot;: \&quot;{CERTIFICATE}\&quot;,     \&quot;encryptedDepServerToken\&quot;: \&quot;{SERVER_TOKEN}\&quot;,     \&quot;dep\&quot;: {       \&quot;welcomeScreen\&quot;: {         \&quot;title\&quot;: \&quot;Welcome\&quot;,         \&quot;paragraph\&quot;: \&quot;In just a few steps, you will be working securely from your Mac.\&quot;,         \&quot;button\&quot;: \&quot;continue\&quot;,       },     },   }&#x27; &#x60;&#x60;&#x60;
  # @param id 
  # @param [Hash] opts the optional parameters
  # @option opts [AppleMdmPatchInput] :body 
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [AppleMDM]
  describe 'applemdms_put test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for applemdms_refreshdepdevices
  # Refresh DEP Devices
  # Refreshes the list of devices that a JumpCloud admin has added to their virtual MDM in Apple Business Manager - ABM so that they can be DEP enrolled with JumpCloud.  #### Sample Request &#x60;&#x60;&#x60;   curl -X POST https://console.jumpcloud.com/api/v2/applemdms/{apple_mdm_id}/refreshdepdevices \\   -H &#x27;accept: application/json&#x27; \\   -H &#x27;content-type: application/json&#x27; \\   -H &#x27;x-api-key: {API_KEY}&#x27; \\   -d &#x27;{}&#x27; &#x60;&#x60;&#x60;
  # @param apple_mdm_id 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :x_org_id Organization identifier that can be obtained from console settings.
  # @return [nil]
  describe 'applemdms_refreshdepdevices test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end
