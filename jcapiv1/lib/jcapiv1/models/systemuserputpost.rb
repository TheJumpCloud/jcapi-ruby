=begin
#JumpCloud API

## Overview  JumpCloud's V1 API. This set of endpoints allows JumpCloud customers to manage commands, systems, and system users.  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/systemusers\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 1.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.32
=end

require 'date'

module JCAPIv1
  class Systemuserputpost
    attr_accessor :account_locked

    attr_accessor :activated

    attr_accessor :addresses

    attr_accessor :allow_public_key

    attr_accessor :alternate_email

    attr_accessor :attributes

    attr_accessor :company

    attr_accessor :cost_center

    attr_accessor :department

    attr_accessor :description

    attr_accessor :disable_device_max_login_attempts

    attr_accessor :displayname

    attr_accessor :email

    # Must be unique per user. 
    attr_accessor :employee_identifier

    attr_accessor :employee_type

    attr_accessor :enable_managed_uid

    attr_accessor :enable_user_portal_multifactor

    attr_accessor :external_dn

    attr_accessor :external_password_expiration_date

    attr_accessor :external_source_type

    attr_accessor :externally_managed

    attr_accessor :firstname

    attr_accessor :job_title

    attr_accessor :lastname

    attr_accessor :ldap_binding_user

    attr_accessor :location

    attr_accessor :managed_apple_id

    # Relation with another systemuser to identify the last as a manager.
    attr_accessor :manager

    attr_accessor :mfa

    attr_accessor :middlename

    attr_accessor :password

    attr_accessor :password_never_expires

    attr_accessor :passwordless_sudo

    attr_accessor :phone_numbers

    attr_accessor :public_key

    attr_accessor :recovery_email

    attr_accessor :relationships

    attr_accessor :samba_service_user

    attr_accessor :state

    attr_accessor :sudo

    attr_accessor :suspended

    attr_accessor :tags

    attr_accessor :unix_guid

    attr_accessor :unix_uid

    attr_accessor :username

    class EnumAttributeValidator
      attr_reader :datatype
      attr_reader :allowable_values

      def initialize(datatype, allowable_values)
        @allowable_values = allowable_values.map do |value|
          case datatype.to_s
          when /Integer/i
            value.to_i
          when /Float/i
            value.to_f
          else
            value
          end
        end
      end

      def valid?(value)
        !value || allowable_values.include?(value)
      end
    end

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'account_locked' => :'account_locked',
        :'activated' => :'activated',
        :'addresses' => :'addresses',
        :'allow_public_key' => :'allow_public_key',
        :'alternate_email' => :'alternateEmail',
        :'attributes' => :'attributes',
        :'company' => :'company',
        :'cost_center' => :'costCenter',
        :'department' => :'department',
        :'description' => :'description',
        :'disable_device_max_login_attempts' => :'disableDeviceMaxLoginAttempts',
        :'displayname' => :'displayname',
        :'email' => :'email',
        :'employee_identifier' => :'employeeIdentifier',
        :'employee_type' => :'employeeType',
        :'enable_managed_uid' => :'enable_managed_uid',
        :'enable_user_portal_multifactor' => :'enable_user_portal_multifactor',
        :'external_dn' => :'external_dn',
        :'external_password_expiration_date' => :'external_password_expiration_date',
        :'external_source_type' => :'external_source_type',
        :'externally_managed' => :'externally_managed',
        :'firstname' => :'firstname',
        :'job_title' => :'jobTitle',
        :'lastname' => :'lastname',
        :'ldap_binding_user' => :'ldap_binding_user',
        :'location' => :'location',
        :'managed_apple_id' => :'managedAppleId',
        :'manager' => :'manager',
        :'mfa' => :'mfa',
        :'middlename' => :'middlename',
        :'password' => :'password',
        :'password_never_expires' => :'password_never_expires',
        :'passwordless_sudo' => :'passwordless_sudo',
        :'phone_numbers' => :'phoneNumbers',
        :'public_key' => :'public_key',
        :'recovery_email' => :'recoveryEmail',
        :'relationships' => :'relationships',
        :'samba_service_user' => :'samba_service_user',
        :'state' => :'state',
        :'sudo' => :'sudo',
        :'suspended' => :'suspended',
        :'tags' => :'tags',
        :'unix_guid' => :'unix_guid',
        :'unix_uid' => :'unix_uid',
        :'username' => :'username'
      }
    end

    # Attribute type mapping.
    def self.openapi_types
      {
        :'account_locked' => :'Object',
        :'activated' => :'Object',
        :'addresses' => :'Object',
        :'allow_public_key' => :'Object',
        :'alternate_email' => :'Object',
        :'attributes' => :'Object',
        :'company' => :'Object',
        :'cost_center' => :'Object',
        :'department' => :'Object',
        :'description' => :'Object',
        :'disable_device_max_login_attempts' => :'Object',
        :'displayname' => :'Object',
        :'email' => :'Object',
        :'employee_identifier' => :'Object',
        :'employee_type' => :'Object',
        :'enable_managed_uid' => :'Object',
        :'enable_user_portal_multifactor' => :'Object',
        :'external_dn' => :'Object',
        :'external_password_expiration_date' => :'Object',
        :'external_source_type' => :'Object',
        :'externally_managed' => :'Object',
        :'firstname' => :'Object',
        :'job_title' => :'Object',
        :'lastname' => :'Object',
        :'ldap_binding_user' => :'Object',
        :'location' => :'Object',
        :'managed_apple_id' => :'Object',
        :'manager' => :'Object',
        :'mfa' => :'Object',
        :'middlename' => :'Object',
        :'password' => :'Object',
        :'password_never_expires' => :'Object',
        :'passwordless_sudo' => :'Object',
        :'phone_numbers' => :'Object',
        :'public_key' => :'Object',
        :'recovery_email' => :'Object',
        :'relationships' => :'Object',
        :'samba_service_user' => :'Object',
        :'state' => :'Object',
        :'sudo' => :'Object',
        :'suspended' => :'Object',
        :'tags' => :'Object',
        :'unix_guid' => :'Object',
        :'unix_uid' => :'Object',
        :'username' => :'Object'
      }
    end

    # List of attributes with nullable: true
    def self.openapi_nullable
      Set.new([
      ])
    end
  
    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      if (!attributes.is_a?(Hash))
        fail ArgumentError, "The input argument (attributes) must be a hash in `JCAPIv1::Systemuserputpost` initialize method"
      end

      # check to see if the attribute exists and convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h|
        if (!self.class.attribute_map.key?(k.to_sym))
          fail ArgumentError, "`#{k}` is not a valid attribute in `JCAPIv1::Systemuserputpost`. Please check the name to make sure it's valid. List of attributes: " + self.class.attribute_map.keys.inspect
        end
        h[k.to_sym] = v
      }

      if attributes.key?(:'account_locked')
        self.account_locked = attributes[:'account_locked']
      end

      if attributes.key?(:'activated')
        self.activated = attributes[:'activated']
      end

      if attributes.key?(:'addresses')
        if (value = attributes[:'addresses']).is_a?(Array)
          self.addresses = value
        end
      end

      if attributes.key?(:'allow_public_key')
        self.allow_public_key = attributes[:'allow_public_key']
      end

      if attributes.key?(:'alternate_email')
        self.alternate_email = attributes[:'alternate_email']
      end

      if attributes.key?(:'attributes')
        if (value = attributes[:'attributes']).is_a?(Array)
          self.attributes = value
        end
      end

      if attributes.key?(:'company')
        self.company = attributes[:'company']
      end

      if attributes.key?(:'cost_center')
        self.cost_center = attributes[:'cost_center']
      end

      if attributes.key?(:'department')
        self.department = attributes[:'department']
      end

      if attributes.key?(:'description')
        self.description = attributes[:'description']
      end

      if attributes.key?(:'disable_device_max_login_attempts')
        self.disable_device_max_login_attempts = attributes[:'disable_device_max_login_attempts']
      end

      if attributes.key?(:'displayname')
        self.displayname = attributes[:'displayname']
      end

      if attributes.key?(:'email')
        self.email = attributes[:'email']
      end

      if attributes.key?(:'employee_identifier')
        self.employee_identifier = attributes[:'employee_identifier']
      end

      if attributes.key?(:'employee_type')
        self.employee_type = attributes[:'employee_type']
      end

      if attributes.key?(:'enable_managed_uid')
        self.enable_managed_uid = attributes[:'enable_managed_uid']
      end

      if attributes.key?(:'enable_user_portal_multifactor')
        self.enable_user_portal_multifactor = attributes[:'enable_user_portal_multifactor']
      end

      if attributes.key?(:'external_dn')
        self.external_dn = attributes[:'external_dn']
      end

      if attributes.key?(:'external_password_expiration_date')
        self.external_password_expiration_date = attributes[:'external_password_expiration_date']
      end

      if attributes.key?(:'external_source_type')
        self.external_source_type = attributes[:'external_source_type']
      end

      if attributes.key?(:'externally_managed')
        self.externally_managed = attributes[:'externally_managed']
      end

      if attributes.key?(:'firstname')
        self.firstname = attributes[:'firstname']
      end

      if attributes.key?(:'job_title')
        self.job_title = attributes[:'job_title']
      end

      if attributes.key?(:'lastname')
        self.lastname = attributes[:'lastname']
      end

      if attributes.key?(:'ldap_binding_user')
        self.ldap_binding_user = attributes[:'ldap_binding_user']
      end

      if attributes.key?(:'location')
        self.location = attributes[:'location']
      end

      if attributes.key?(:'managed_apple_id')
        self.managed_apple_id = attributes[:'managed_apple_id']
      end

      if attributes.key?(:'manager')
        self.manager = attributes[:'manager']
      end

      if attributes.key?(:'mfa')
        self.mfa = attributes[:'mfa']
      end

      if attributes.key?(:'middlename')
        self.middlename = attributes[:'middlename']
      end

      if attributes.key?(:'password')
        self.password = attributes[:'password']
      end

      if attributes.key?(:'password_never_expires')
        self.password_never_expires = attributes[:'password_never_expires']
      end

      if attributes.key?(:'passwordless_sudo')
        self.passwordless_sudo = attributes[:'passwordless_sudo']
      end

      if attributes.key?(:'phone_numbers')
        if (value = attributes[:'phone_numbers']).is_a?(Array)
          self.phone_numbers = value
        end
      end

      if attributes.key?(:'public_key')
        self.public_key = attributes[:'public_key']
      end

      if attributes.key?(:'recovery_email')
        self.recovery_email = attributes[:'recovery_email']
      end

      if attributes.key?(:'relationships')
        if (value = attributes[:'relationships']).is_a?(Array)
          self.relationships = value
        end
      end

      if attributes.key?(:'samba_service_user')
        self.samba_service_user = attributes[:'samba_service_user']
      end

      if attributes.key?(:'state')
        self.state = attributes[:'state']
      end

      if attributes.key?(:'sudo')
        self.sudo = attributes[:'sudo']
      end

      if attributes.key?(:'suspended')
        self.suspended = attributes[:'suspended']
      end

      if attributes.key?(:'tags')
        if (value = attributes[:'tags']).is_a?(Array)
          self.tags = value
        end
      end

      if attributes.key?(:'unix_guid')
        self.unix_guid = attributes[:'unix_guid']
      end

      if attributes.key?(:'unix_uid')
        self.unix_uid = attributes[:'unix_uid']
      end

      if attributes.key?(:'username')
        self.username = attributes[:'username']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @email.nil?
        invalid_properties.push('invalid value for "email", email cannot be nil.')
      end

      if @username.nil?
        invalid_properties.push('invalid value for "username", username cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @email.nil?
      state_validator = EnumAttributeValidator.new('Object', ['STAGED', 'ACTIVATED', 'SUSPENDED'])
      return false unless state_validator.valid?(@state)
      return false if @username.nil?
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] state Object to be assigned
    def state=(state)
      validator = EnumAttributeValidator.new('Object', ['STAGED', 'ACTIVATED', 'SUSPENDED'])
      unless validator.valid?(state)
        fail ArgumentError, "invalid value for \"state\", must be one of #{validator.allowable_values}."
      end
      @state = state
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          account_locked == o.account_locked &&
          activated == o.activated &&
          addresses == o.addresses &&
          allow_public_key == o.allow_public_key &&
          alternate_email == o.alternate_email &&
          attributes == o.attributes &&
          company == o.company &&
          cost_center == o.cost_center &&
          department == o.department &&
          description == o.description &&
          disable_device_max_login_attempts == o.disable_device_max_login_attempts &&
          displayname == o.displayname &&
          email == o.email &&
          employee_identifier == o.employee_identifier &&
          employee_type == o.employee_type &&
          enable_managed_uid == o.enable_managed_uid &&
          enable_user_portal_multifactor == o.enable_user_portal_multifactor &&
          external_dn == o.external_dn &&
          external_password_expiration_date == o.external_password_expiration_date &&
          external_source_type == o.external_source_type &&
          externally_managed == o.externally_managed &&
          firstname == o.firstname &&
          job_title == o.job_title &&
          lastname == o.lastname &&
          ldap_binding_user == o.ldap_binding_user &&
          location == o.location &&
          managed_apple_id == o.managed_apple_id &&
          manager == o.manager &&
          mfa == o.mfa &&
          middlename == o.middlename &&
          password == o.password &&
          password_never_expires == o.password_never_expires &&
          passwordless_sudo == o.passwordless_sudo &&
          phone_numbers == o.phone_numbers &&
          public_key == o.public_key &&
          recovery_email == o.recovery_email &&
          relationships == o.relationships &&
          samba_service_user == o.samba_service_user &&
          state == o.state &&
          sudo == o.sudo &&
          suspended == o.suspended &&
          tags == o.tags &&
          unix_guid == o.unix_guid &&
          unix_uid == o.unix_uid &&
          username == o.username
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Integer] Hash code
    def hash
      [account_locked, activated, addresses, allow_public_key, alternate_email, attributes, company, cost_center, department, description, disable_device_max_login_attempts, displayname, email, employee_identifier, employee_type, enable_managed_uid, enable_user_portal_multifactor, external_dn, external_password_expiration_date, external_source_type, externally_managed, firstname, job_title, lastname, ldap_binding_user, location, managed_apple_id, manager, mfa, middlename, password, password_never_expires, passwordless_sudo, phone_numbers, public_key, recovery_email, relationships, samba_service_user, state, sudo, suspended, tags, unix_guid, unix_uid, username].hash
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def self.build_from_hash(attributes)
      new.build_from_hash(attributes)
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def build_from_hash(attributes)
      return nil unless attributes.is_a?(Hash)
      self.class.openapi_types.each_pair do |key, type|
        if type =~ /\AArray<(.*)>/i
          # check to ensure the input is an array given that the attribute
          # is documented as an array but the input is not
          if attributes[self.class.attribute_map[key]].is_a?(Array)
            self.send("#{key}=", attributes[self.class.attribute_map[key]].map { |v| _deserialize($1, v) })
          end
        elsif !attributes[self.class.attribute_map[key]].nil?
          self.send("#{key}=", _deserialize(type, attributes[self.class.attribute_map[key]]))
        elsif attributes[self.class.attribute_map[key]].nil? && self.class.openapi_nullable.include?(key)
          self.send("#{key}=", nil)
        end
      end

      self
    end

    # Deserializes the data based on type
    # @param string type Data type
    # @param string value Value to be deserialized
    # @return [Object] Deserialized data
    def _deserialize(type, value)
      case type.to_sym
      when :DateTime
        DateTime.parse(value)
      when :Date
        Date.parse(value)
      when :String
        value.to_s
      when :Integer
        value.to_i
      when :Float
        value.to_f
      when :Boolean
        if value.to_s =~ /\A(true|t|yes|y|1)\z/i
          true
        else
          false
        end
      when :Object
        # generic object (usually a Hash), return directly
        value
      when /\AArray<(?<inner_type>.+)>\z/
        inner_type = Regexp.last_match[:inner_type]
        value.map { |v| _deserialize(inner_type, v) }
      when /\AHash<(?<k_type>.+?), (?<v_type>.+)>\z/
        k_type = Regexp.last_match[:k_type]
        v_type = Regexp.last_match[:v_type]
        {}.tap do |hash|
          value.each do |k, v|
            hash[_deserialize(k_type, k)] = _deserialize(v_type, v)
          end
        end
      else # model
        JCAPIv1.const_get(type).build_from_hash(value)
      end
    end

    # Returns the string representation of the object
    # @return [String] String presentation of the object
    def to_s
      to_hash.to_s
    end

    # to_body is an alias to to_hash (backward compatibility)
    # @return [Hash] Returns the object in the form of hash
    def to_body
      to_hash
    end

    # Returns the object in the form of hash
    # @return [Hash] Returns the object in the form of hash
    def to_hash
      hash = {}
      self.class.attribute_map.each_pair do |attr, param|
        value = self.send(attr)
        if value.nil?
          is_nullable = self.class.openapi_nullable.include?(attr)
          next if !is_nullable || (is_nullable && !instance_variable_defined?(:"@#{attr}"))
        end

        hash[param] = _to_hash(value)
      end
      hash
    end

    # Outputs non-array value in the form of hash
    # For object, use to_hash. Otherwise, just return the value
    # @param [Object] value Any valid value
    # @return [Hash] Returns the value in the form of hash
    def _to_hash(value)
      if value.is_a?(Array)
        value.compact.map { |v| _to_hash(v) }
      elsif value.is_a?(Hash)
        {}.tap do |hash|
          value.each { |k, v| hash[k] = _to_hash(v) }
        end
      elsif value.respond_to? :to_hash
        value.to_hash
      else
        value
      end
    end  end
end
