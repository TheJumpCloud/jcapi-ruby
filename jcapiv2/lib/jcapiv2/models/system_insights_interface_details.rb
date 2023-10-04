=begin
#JumpCloud API

## Overview  JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.  ## API Best Practices  Read the linked Help Article below for guidance on retrying failed requests to JumpCloud's REST API, as well as best practices for structuring subsequent retry requests. Customizing retry mechanisms based on these recommendations will increase the reliability and dependability of your API calls.  Covered topics include: 1. Important Considerations 2. Supported HTTP Request Methods 3. Response codes 4. API Key rotation 5. Paginating 6. Error handling 7. Retry rates  [JumpCloud Help Center - API Best Practices](https://support.jumpcloud.com/support/s/article/JumpCloud-API-Best-Practices)  # Directory Objects  This API offers the ability to interact with some of our core features; otherwise known as Directory Objects. The Directory Objects are:  * Commands * Policies * Policy Groups * Applications * Systems * Users * User Groups * System Groups * Radius Servers * Directories: Office 365, LDAP,G-Suite, Active Directory * Duo accounts and applications.  The Directory Object is an important concept to understand in order to successfully use JumpCloud API.  ## JumpCloud Graph  We've also introduced the concept of the JumpCloud Graph along with  Directory Objects. The Graph is a powerful aspect of our platform which will enable you to associate objects with each other, or establish membership for certain objects to become members of other objects.  Specific `GET` endpoints will allow you to traverse the JumpCloud Graph to return all indirect and directly bound objects in your organization.  | ![alt text](https://s3.amazonaws.com/jumpcloud-kb/Knowledge+Base+Photos/API+Docs/jumpcloud_graph.png \"JumpCloud Graph Model Example\") | |:--:| | **This diagram highlights our association and membership model as it relates to Directory Objects.** |  # API Key  ## Access Your API Key  To locate your API Key:  1. Log into the [JumpCloud Admin Console](https://console.jumpcloud.com/). 2. Go to the username drop down located in the top-right of the Console. 3. Retrieve your API key from API Settings.  ## API Key Considerations  This API key is associated to the currently logged in administrator. Other admins will have different API keys.  **WARNING** Please keep this API key secret, as it grants full access to any data accessible via your JumpCloud console account.  You can also reset your API key in the same location in the JumpCloud Admin Console.  ## Recycling or Resetting Your API Key  In order to revoke access with the current API key, simply reset your API key. This will render all calls using the previous API key inaccessible.  Your API key will be passed in as a header with the header name \"x-api-key\".  ```bash curl -H \"x-api-key: [YOUR_API_KEY_HERE]\" \"https://console.jumpcloud.com/api/v2/systemgroups\" ```  # System Context  * [Introduction](#introduction) * [Supported endpoints](#supported-endpoints) * [Response codes](#response-codes) * [Authentication](#authentication) * [Additional examples](#additional-examples) * [Third party](#third-party)  ## Introduction  JumpCloud System Context Authorization is an alternative way to authenticate with a subset of JumpCloud's REST APIs. Using this method, a system can manage its information and resource associations, allowing modern auto provisioning environments to scale as needed.  **Notes:**   * The following documentation applies to Linux Operating Systems only.  * Systems that have been automatically enrolled using Apple's Device Enrollment Program (DEP) or systems enrolled using the User Portal install are not eligible to use the System Context API to prevent unauthorized access to system groups and resources. If a script that utilizes the System Context API is invoked on a system enrolled in this way, it will display an error.  ## Supported Endpoints  JumpCloud System Context Authorization can be used in conjunction with Systems endpoints found in the V1 API and certain System Group endpoints found in the v2 API.  * A system may fetch, alter, and delete metadata about itself, including manipulating a system's Group and Systemuser associations,   * `/api/systems/{system_id}` | [`GET`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_get) [`PUT`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_put) * A system may delete itself from your JumpCloud organization   * `/api/systems/{system_id}` | [`DELETE`](https://docs.jumpcloud.com/api/1.0/index.html#operation/systems_delete) * A system may fetch its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/memberof` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembership)   * `/api/v2/systems/{system_id}/associations` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsList)   * `/api/v2/systems/{system_id}/users` | [`GET`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemTraverseUser) * A system may alter its direct resource associations under v2 (Groups)   * `/api/v2/systems/{system_id}/associations` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemAssociationsPost) * A system may alter its System Group associations   * `/api/v2/systemgroups/{group_id}/members` | [`POST`](https://docs.jumpcloud.com/api/2.0/index.html#operation/graph_systemGroupMembersPost)     * _NOTE_ If a system attempts to alter the system group membership of a different system the request will be rejected  ## Response Codes  If endpoints other than those described above are called using the System Context API, the server will return a `401` response.  ## Authentication  To allow for secure access to our APIs, you must authenticate each API request. JumpCloud System Context Authorization uses [HTTP Signatures](https://tools.ietf.org/html/draft-cavage-http-signatures-00) to authenticate API requests. The HTTP Signatures sent with each request are similar to the signatures used by the Amazon Web Services REST API. To help with the request-signing process, we have provided an [example bash script](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh). This example API request simply requests the entire system record. You must be root, or have permissions to access the contents of the `/opt/jc` directory to generate a signature.  Here is a breakdown of the example script with explanations.  First, the script extracts the systemKey from the JSON formatted `/opt/jc/jcagent.conf` file.  ```bash #!/bin/bash conf=\"`cat /opt/jc/jcagent.conf`\" regex=\"systemKey\\\":\\\"(\\w+)\\\"\"  if [[ $conf =~ $regex ]] ; then   systemKey=\"${BASH_REMATCH[1]}\" fi ```  Then, the script retrieves the current date in the correct format.  ```bash now=`date -u \"+%a, %d %h %Y %H:%M:%S GMT\"`; ```  Next, we build a signing string to demonstrate the expected signature format. The signed string must consist of the [request-line](https://tools.ietf.org/html/rfc2616#page-35) and the date header, separated by a newline character.  ```bash signstr=\"GET /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" ```  The next step is to calculate and apply the signature. This is a two-step process:  1. Create a signature from the signing string using the JumpCloud Agent private key: ``printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key`` 2. Then Base64-encode the signature string and trim off the newline characters: ``| openssl enc -e -a | tr -d '\\n'``  The combined steps above result in:  ```bash signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ; ```  Finally, we make sure the API call sending the signature has the same Authorization and Date header values, HTTP method, and URL that were used in the signing string.  ```bash curl -iq \\   -H \"Accept: application/json\" \\   -H \"Content-Type: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Input Data  All PUT and POST methods should use the HTTP Content-Type header with a value of 'application/json'. PUT methods are used for updating a record. POST methods are used to create a record.  The following example demonstrates how to update the `displayName` of the system.  ```bash signstr=\"PUT /api/systems/${systemKey} HTTP/1.1\\ndate: ${now}\" signature=`printf \"$signstr\" | openssl dgst -sha256 -sign /opt/jc/client.key | openssl enc -e -a | tr -d '\\n'` ;  curl -iq \\   -d \"{\\\"displayName\\\" : \\\"updated-system-name-1\\\"}\" \\   -X \"PUT\" \\   -H \"Content-Type: application/json\" \\   -H \"Accept: application/json\" \\   -H \"Date: ${now}\" \\   -H \"Authorization: Signature keyId=\\\"system/${systemKey}\\\",headers=\\\"request-line date\\\",algorithm=\\\"rsa-sha256\\\",signature=\\\"${signature}\\\"\" \\   --url https://console.jumpcloud.com/api/systems/${systemKey} ```  ### Output Data  All results will be formatted as JSON.  Here is an abbreviated example of response output:  ```json {   \"_id\": \"525ee96f52e144993e000015\",   \"agentServer\": \"lappy386\",   \"agentVersion\": \"0.9.42\",   \"arch\": \"x86_64\",   \"connectionKey\": \"127.0.0.1_51812\",   \"displayName\": \"ubuntu-1204\",   \"firstContact\": \"2013-10-16T19:30:55.611Z\",   \"hostname\": \"ubuntu-1204\"   ... ```  ## Additional Examples  ### Signing Authentication Example  This example demonstrates how to make an authenticated request to fetch the JumpCloud record for this system.  [SigningExample.sh](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/shell/SigningExample.sh)  ### Shutdown Hook  This example demonstrates how to make an authenticated request on system shutdown. Using an init.d script registered at run level 0, you can call the System Context API as the system is shutting down.  [Instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) is an example of an init.d script that only runs at system shutdown.  After customizing the [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) script, you should install it on the system(s) running the JumpCloud agent.  1. Copy the modified [instance-shutdown-initd](https://github.com/TheJumpCloud/SystemContextAPI/blob/master/examples/instance-shutdown-initd) to `/etc/init.d/instance-shutdown`. 2. On Ubuntu systems, run `update-rc.d instance-shutdown defaults`. On RedHat/CentOS systems, run `chkconfig --add instance-shutdown`.  ## Third Party  ### Chef Cookbooks  [https://github.com/nshenry03/jumpcloud](https://github.com/nshenry03/jumpcloud)  [https://github.com/cjs226/jumpcloud](https://github.com/cjs226/jumpcloud)  # Multi-Tenant Portal Headers  Multi-Tenant Organization API Headers are available for JumpCloud Admins to use when making API requests from Organizations that have multiple managed organizations.  The `x-org-id` is a required header for all multi-tenant admins when making API requests to JumpCloud. This header will define to which organization you would like to make the request.  **NOTE** Single Tenant Admins do not need to provide this header when making an API request.  ## Header Value  `x-org-id`  ## API Response Codes  * `400` Malformed ID. * `400` x-org-id and Organization path ID do not match. * `401` ID not included for multi-tenant admin * `403` ID included on unsupported route. * `404` Organization ID Not Found.  ```bash curl -X GET https://console.jumpcloud.com/api/v2/directories \\   -H 'accept: application/json' \\   -H 'content-type: application/json' \\   -H 'x-api-key: {API_KEY}' \\   -H 'x-org-id: {ORG_ID}'  ```  ## To Obtain an Individual Organization ID via the UI  As a prerequisite, your Primary Organization will need to be setup for Multi-Tenancy. This provides access to the Multi-Tenant Organization Admin Portal.  1. Log into JumpCloud [Admin Console](https://console.jumpcloud.com). If you are a multi-tenant Admin, you will automatically be routed to the Multi-Tenant Admin Portal. 2. From the Multi-Tenant Portal's primary navigation bar, select the Organization you'd like to access. 3. You will automatically be routed to that Organization's Admin Console. 4. Go to Settings in the sub-tenant's primary navigation. 5. You can obtain your Organization ID below your Organization's Contact Information on the Settings page.  ## To Obtain All Organization IDs via the API  * You can make an API request to this endpoint using the API key of your Primary Organization.  `https://console.jumpcloud.com/api/organizations/` This will return all your managed organizations.  ```bash curl -X GET \\   https://console.jumpcloud.com/api/organizations/ \\   -H 'Accept: application/json' \\   -H 'Content-Type: application/json' \\   -H 'x-api-key: {API_KEY}' ```  # SDKs  You can find language specific SDKs that can help you kickstart your Integration with JumpCloud in the following GitHub repositories:  * [Python](https://github.com/TheJumpCloud/jcapi-python) * [Go](https://github.com/TheJumpCloud/jcapi-go) * [Ruby](https://github.com/TheJumpCloud/jcapi-ruby) * [Java](https://github.com/TheJumpCloud/jcapi-java) 

OpenAPI spec version: 2.0
Contact: support@jumpcloud.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 3.0.47
=end

require 'date'

module JCAPIv2
  class SystemInsightsInterfaceDetails
    attr_accessor :collisions

    attr_accessor :connection_id

    attr_accessor :connection_status

    attr_accessor :description

    attr_accessor :dhcp_enabled

    attr_accessor :dhcp_lease_expires

    attr_accessor :dhcp_lease_obtained

    attr_accessor :dhcp_server

    attr_accessor :dns_domain

    attr_accessor :dns_domain_suffix_search_order

    attr_accessor :dns_host_name

    attr_accessor :dns_server_search_order

    attr_accessor :enabled

    attr_accessor :flags

    attr_accessor :friendly_name

    attr_accessor :ibytes

    attr_accessor :idrops

    attr_accessor :ierrors

    attr_accessor :interface

    attr_accessor :ipackets

    attr_accessor :last_change

    attr_accessor :link_speed

    attr_accessor :mac

    attr_accessor :manufacturer

    attr_accessor :metric

    attr_accessor :mtu

    attr_accessor :obytes

    attr_accessor :odrops

    attr_accessor :oerrors

    attr_accessor :opackets

    attr_accessor :pci_slot

    attr_accessor :physical_adapter

    attr_accessor :service

    attr_accessor :speed

    attr_accessor :system_id

    attr_accessor :type

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'collisions' => :'collisions',
        :'connection_id' => :'connection_id',
        :'connection_status' => :'connection_status',
        :'description' => :'description',
        :'dhcp_enabled' => :'dhcp_enabled',
        :'dhcp_lease_expires' => :'dhcp_lease_expires',
        :'dhcp_lease_obtained' => :'dhcp_lease_obtained',
        :'dhcp_server' => :'dhcp_server',
        :'dns_domain' => :'dns_domain',
        :'dns_domain_suffix_search_order' => :'dns_domain_suffix_search_order',
        :'dns_host_name' => :'dns_host_name',
        :'dns_server_search_order' => :'dns_server_search_order',
        :'enabled' => :'enabled',
        :'flags' => :'flags',
        :'friendly_name' => :'friendly_name',
        :'ibytes' => :'ibytes',
        :'idrops' => :'idrops',
        :'ierrors' => :'ierrors',
        :'interface' => :'interface',
        :'ipackets' => :'ipackets',
        :'last_change' => :'last_change',
        :'link_speed' => :'link_speed',
        :'mac' => :'mac',
        :'manufacturer' => :'manufacturer',
        :'metric' => :'metric',
        :'mtu' => :'mtu',
        :'obytes' => :'obytes',
        :'odrops' => :'odrops',
        :'oerrors' => :'oerrors',
        :'opackets' => :'opackets',
        :'pci_slot' => :'pci_slot',
        :'physical_adapter' => :'physical_adapter',
        :'service' => :'service',
        :'speed' => :'speed',
        :'system_id' => :'system_id',
        :'type' => :'type'
      }
    end

    # Attribute type mapping.
    def self.openapi_types
      {
        :'collisions' => :'Object',
        :'connection_id' => :'Object',
        :'connection_status' => :'Object',
        :'description' => :'Object',
        :'dhcp_enabled' => :'Object',
        :'dhcp_lease_expires' => :'Object',
        :'dhcp_lease_obtained' => :'Object',
        :'dhcp_server' => :'Object',
        :'dns_domain' => :'Object',
        :'dns_domain_suffix_search_order' => :'Object',
        :'dns_host_name' => :'Object',
        :'dns_server_search_order' => :'Object',
        :'enabled' => :'Object',
        :'flags' => :'Object',
        :'friendly_name' => :'Object',
        :'ibytes' => :'Object',
        :'idrops' => :'Object',
        :'ierrors' => :'Object',
        :'interface' => :'Object',
        :'ipackets' => :'Object',
        :'last_change' => :'Object',
        :'link_speed' => :'Object',
        :'mac' => :'Object',
        :'manufacturer' => :'Object',
        :'metric' => :'Object',
        :'mtu' => :'Object',
        :'obytes' => :'Object',
        :'odrops' => :'Object',
        :'oerrors' => :'Object',
        :'opackets' => :'Object',
        :'pci_slot' => :'Object',
        :'physical_adapter' => :'Object',
        :'service' => :'Object',
        :'speed' => :'Object',
        :'system_id' => :'Object',
        :'type' => :'Object'
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
        fail ArgumentError, "The input argument (attributes) must be a hash in `JCAPIv2::SystemInsightsInterfaceDetails` initialize method"
      end

      # check to see if the attribute exists and convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h|
        if (!self.class.attribute_map.key?(k.to_sym))
          fail ArgumentError, "`#{k}` is not a valid attribute in `JCAPIv2::SystemInsightsInterfaceDetails`. Please check the name to make sure it's valid. List of attributes: " + self.class.attribute_map.keys.inspect
        end
        h[k.to_sym] = v
      }

      if attributes.key?(:'collisions')
        self.collisions = attributes[:'collisions']
      end

      if attributes.key?(:'connection_id')
        self.connection_id = attributes[:'connection_id']
      end

      if attributes.key?(:'connection_status')
        self.connection_status = attributes[:'connection_status']
      end

      if attributes.key?(:'description')
        self.description = attributes[:'description']
      end

      if attributes.key?(:'dhcp_enabled')
        self.dhcp_enabled = attributes[:'dhcp_enabled']
      end

      if attributes.key?(:'dhcp_lease_expires')
        self.dhcp_lease_expires = attributes[:'dhcp_lease_expires']
      end

      if attributes.key?(:'dhcp_lease_obtained')
        self.dhcp_lease_obtained = attributes[:'dhcp_lease_obtained']
      end

      if attributes.key?(:'dhcp_server')
        self.dhcp_server = attributes[:'dhcp_server']
      end

      if attributes.key?(:'dns_domain')
        self.dns_domain = attributes[:'dns_domain']
      end

      if attributes.key?(:'dns_domain_suffix_search_order')
        self.dns_domain_suffix_search_order = attributes[:'dns_domain_suffix_search_order']
      end

      if attributes.key?(:'dns_host_name')
        self.dns_host_name = attributes[:'dns_host_name']
      end

      if attributes.key?(:'dns_server_search_order')
        self.dns_server_search_order = attributes[:'dns_server_search_order']
      end

      if attributes.key?(:'enabled')
        self.enabled = attributes[:'enabled']
      end

      if attributes.key?(:'flags')
        self.flags = attributes[:'flags']
      end

      if attributes.key?(:'friendly_name')
        self.friendly_name = attributes[:'friendly_name']
      end

      if attributes.key?(:'ibytes')
        self.ibytes = attributes[:'ibytes']
      end

      if attributes.key?(:'idrops')
        self.idrops = attributes[:'idrops']
      end

      if attributes.key?(:'ierrors')
        self.ierrors = attributes[:'ierrors']
      end

      if attributes.key?(:'interface')
        self.interface = attributes[:'interface']
      end

      if attributes.key?(:'ipackets')
        self.ipackets = attributes[:'ipackets']
      end

      if attributes.key?(:'last_change')
        self.last_change = attributes[:'last_change']
      end

      if attributes.key?(:'link_speed')
        self.link_speed = attributes[:'link_speed']
      end

      if attributes.key?(:'mac')
        self.mac = attributes[:'mac']
      end

      if attributes.key?(:'manufacturer')
        self.manufacturer = attributes[:'manufacturer']
      end

      if attributes.key?(:'metric')
        self.metric = attributes[:'metric']
      end

      if attributes.key?(:'mtu')
        self.mtu = attributes[:'mtu']
      end

      if attributes.key?(:'obytes')
        self.obytes = attributes[:'obytes']
      end

      if attributes.key?(:'odrops')
        self.odrops = attributes[:'odrops']
      end

      if attributes.key?(:'oerrors')
        self.oerrors = attributes[:'oerrors']
      end

      if attributes.key?(:'opackets')
        self.opackets = attributes[:'opackets']
      end

      if attributes.key?(:'pci_slot')
        self.pci_slot = attributes[:'pci_slot']
      end

      if attributes.key?(:'physical_adapter')
        self.physical_adapter = attributes[:'physical_adapter']
      end

      if attributes.key?(:'service')
        self.service = attributes[:'service']
      end

      if attributes.key?(:'speed')
        self.speed = attributes[:'speed']
      end

      if attributes.key?(:'system_id')
        self.system_id = attributes[:'system_id']
      end

      if attributes.key?(:'type')
        self.type = attributes[:'type']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      true
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          collisions == o.collisions &&
          connection_id == o.connection_id &&
          connection_status == o.connection_status &&
          description == o.description &&
          dhcp_enabled == o.dhcp_enabled &&
          dhcp_lease_expires == o.dhcp_lease_expires &&
          dhcp_lease_obtained == o.dhcp_lease_obtained &&
          dhcp_server == o.dhcp_server &&
          dns_domain == o.dns_domain &&
          dns_domain_suffix_search_order == o.dns_domain_suffix_search_order &&
          dns_host_name == o.dns_host_name &&
          dns_server_search_order == o.dns_server_search_order &&
          enabled == o.enabled &&
          flags == o.flags &&
          friendly_name == o.friendly_name &&
          ibytes == o.ibytes &&
          idrops == o.idrops &&
          ierrors == o.ierrors &&
          interface == o.interface &&
          ipackets == o.ipackets &&
          last_change == o.last_change &&
          link_speed == o.link_speed &&
          mac == o.mac &&
          manufacturer == o.manufacturer &&
          metric == o.metric &&
          mtu == o.mtu &&
          obytes == o.obytes &&
          odrops == o.odrops &&
          oerrors == o.oerrors &&
          opackets == o.opackets &&
          pci_slot == o.pci_slot &&
          physical_adapter == o.physical_adapter &&
          service == o.service &&
          speed == o.speed &&
          system_id == o.system_id &&
          type == o.type
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Integer] Hash code
    def hash
      [collisions, connection_id, connection_status, description, dhcp_enabled, dhcp_lease_expires, dhcp_lease_obtained, dhcp_server, dns_domain, dns_domain_suffix_search_order, dns_host_name, dns_server_search_order, enabled, flags, friendly_name, ibytes, idrops, ierrors, interface, ipackets, last_change, link_speed, mac, manufacturer, metric, mtu, obytes, odrops, oerrors, opackets, pci_slot, physical_adapter, service, speed, system_id, type].hash
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
        JCAPIv2.const_get(type).build_from_hash(value)
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
