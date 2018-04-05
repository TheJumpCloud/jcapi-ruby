=begin
#JumpCloud APIs

#V1 & V2 versions of JumpCloud's API. The previous version of JumpCloud's API. This set of endpoints allows JumpCloud customers to manage commands, systems, & system users.

OpenAPI spec version: 1.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.0-SNAPSHOT

=end

require 'date'

module JCAPIv1

  class Systemuserreturn
    attr_accessor :email

    attr_accessor :username

    attr_accessor :allow_public_key

    attr_accessor :public_key

    attr_accessor :ssh_keys

    attr_accessor :sudo

    attr_accessor :enable_managed_uid

    attr_accessor :unix_uid

    attr_accessor :unix_guid

    attr_accessor :activated

    attr_accessor :tags

    attr_accessor :password_expired

    attr_accessor :account_locked

    attr_accessor :passwordless_sudo

    attr_accessor :externally_managed

    attr_accessor :external_dn

    attr_accessor :external_source_type

    attr_accessor :firstname

    attr_accessor :lastname

    attr_accessor :ldap_binding_user

    attr_accessor :enable_user_portal_multifactor

    attr_accessor :totp_enabled

    attr_accessor :attributes

    attr_accessor :created

    attr_accessor :samba_service_user

    attr_accessor :id

    attr_accessor :organization

    attr_accessor :addresses

    attr_accessor :job_title

    attr_accessor :department

    attr_accessor :phone_numbers

    attr_accessor :relationships

    attr_accessor :bad_login_attempts


    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'email' => :'email',
        :'username' => :'username',
        :'allow_public_key' => :'allow_public_key',
        :'public_key' => :'public_key',
        :'ssh_keys' => :'ssh_keys',
        :'sudo' => :'sudo',
        :'enable_managed_uid' => :'enable_managed_uid',
        :'unix_uid' => :'unix_uid',
        :'unix_guid' => :'unix_guid',
        :'activated' => :'activated',
        :'tags' => :'tags',
        :'password_expired' => :'password_expired',
        :'account_locked' => :'account_locked',
        :'passwordless_sudo' => :'passwordless_sudo',
        :'externally_managed' => :'externally_managed',
        :'external_dn' => :'external_dn',
        :'external_source_type' => :'external_source_type',
        :'firstname' => :'firstname',
        :'lastname' => :'lastname',
        :'ldap_binding_user' => :'ldap_binding_user',
        :'enable_user_portal_multifactor' => :'enable_user_portal_multifactor',
        :'totp_enabled' => :'totp_enabled',
        :'attributes' => :'attributes',
        :'created' => :'created',
        :'samba_service_user' => :'samba_service_user',
        :'id' => :'id',
        :'organization' => :'organization',
        :'addresses' => :'addresses',
        :'job_title' => :'jobTitle',
        :'department' => :'department',
        :'phone_numbers' => :'phoneNumbers',
        :'relationships' => :'relationships',
        :'bad_login_attempts' => :'badLoginAttempts'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'email' => :'String',
        :'username' => :'String',
        :'allow_public_key' => :'BOOLEAN',
        :'public_key' => :'String',
        :'ssh_keys' => :'Array<String>',
        :'sudo' => :'BOOLEAN',
        :'enable_managed_uid' => :'BOOLEAN',
        :'unix_uid' => :'Integer',
        :'unix_guid' => :'Integer',
        :'activated' => :'BOOLEAN',
        :'tags' => :'Array<String>',
        :'password_expired' => :'BOOLEAN',
        :'account_locked' => :'BOOLEAN',
        :'passwordless_sudo' => :'BOOLEAN',
        :'externally_managed' => :'BOOLEAN',
        :'external_dn' => :'String',
        :'external_source_type' => :'String',
        :'firstname' => :'String',
        :'lastname' => :'String',
        :'ldap_binding_user' => :'BOOLEAN',
        :'enable_user_portal_multifactor' => :'BOOLEAN',
        :'totp_enabled' => :'BOOLEAN',
        :'attributes' => :'Array<Object>',
        :'created' => :'String',
        :'samba_service_user' => :'BOOLEAN',
        :'id' => :'String',
        :'organization' => :'String',
        :'addresses' => :'Array<String>',
        :'job_title' => :'String',
        :'department' => :'String',
        :'phone_numbers' => :'Array<String>',
        :'relationships' => :'Array<Object>',
        :'bad_login_attempts' => :'Integer'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}){|(k,v), h| h[k.to_sym] = v}

      if attributes.has_key?(:'email')
        self.email = attributes[:'email']
      end

      if attributes.has_key?(:'username')
        self.username = attributes[:'username']
      end

      if attributes.has_key?(:'allow_public_key')
        self.allow_public_key = attributes[:'allow_public_key']
      end

      if attributes.has_key?(:'public_key')
        self.public_key = attributes[:'public_key']
      end

      if attributes.has_key?(:'ssh_keys')
        if (value = attributes[:'ssh_keys']).is_a?(Array)
          self.ssh_keys = value
        end
      end

      if attributes.has_key?(:'sudo')
        self.sudo = attributes[:'sudo']
      end

      if attributes.has_key?(:'enable_managed_uid')
        self.enable_managed_uid = attributes[:'enable_managed_uid']
      end

      if attributes.has_key?(:'unix_uid')
        self.unix_uid = attributes[:'unix_uid']
      end

      if attributes.has_key?(:'unix_guid')
        self.unix_guid = attributes[:'unix_guid']
      end

      if attributes.has_key?(:'activated')
        self.activated = attributes[:'activated']
      end

      if attributes.has_key?(:'tags')
        if (value = attributes[:'tags']).is_a?(Array)
          self.tags = value
        end
      end

      if attributes.has_key?(:'password_expired')
        self.password_expired = attributes[:'password_expired']
      end

      if attributes.has_key?(:'account_locked')
        self.account_locked = attributes[:'account_locked']
      end

      if attributes.has_key?(:'passwordless_sudo')
        self.passwordless_sudo = attributes[:'passwordless_sudo']
      end

      if attributes.has_key?(:'externally_managed')
        self.externally_managed = attributes[:'externally_managed']
      end

      if attributes.has_key?(:'external_dn')
        self.external_dn = attributes[:'external_dn']
      end

      if attributes.has_key?(:'external_source_type')
        self.external_source_type = attributes[:'external_source_type']
      end

      if attributes.has_key?(:'firstname')
        self.firstname = attributes[:'firstname']
      end

      if attributes.has_key?(:'lastname')
        self.lastname = attributes[:'lastname']
      end

      if attributes.has_key?(:'ldap_binding_user')
        self.ldap_binding_user = attributes[:'ldap_binding_user']
      end

      if attributes.has_key?(:'enable_user_portal_multifactor')
        self.enable_user_portal_multifactor = attributes[:'enable_user_portal_multifactor']
      end

      if attributes.has_key?(:'totp_enabled')
        self.totp_enabled = attributes[:'totp_enabled']
      end

      if attributes.has_key?(:'attributes')
        if (value = attributes[:'attributes']).is_a?(Array)
          self.attributes = value
        end
      end

      if attributes.has_key?(:'created')
        self.created = attributes[:'created']
      end

      if attributes.has_key?(:'samba_service_user')
        self.samba_service_user = attributes[:'samba_service_user']
      end

      if attributes.has_key?(:'id')
        self.id = attributes[:'id']
      end

      if attributes.has_key?(:'organization')
        self.organization = attributes[:'organization']
      end

      if attributes.has_key?(:'addresses')
        if (value = attributes[:'addresses']).is_a?(Array)
          self.addresses = value
        end
      end

      if attributes.has_key?(:'jobTitle')
        self.job_title = attributes[:'jobTitle']
      end

      if attributes.has_key?(:'department')
        self.department = attributes[:'department']
      end

      if attributes.has_key?(:'phoneNumbers')
        if (value = attributes[:'phoneNumbers']).is_a?(Array)
          self.phone_numbers = value
        end
      end

      if attributes.has_key?(:'relationships')
        if (value = attributes[:'relationships']).is_a?(Array)
          self.relationships = value
        end
      end

      if attributes.has_key?(:'badLoginAttempts')
        self.bad_login_attempts = attributes[:'badLoginAttempts']
      end

    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      return invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return true
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          email == o.email &&
          username == o.username &&
          allow_public_key == o.allow_public_key &&
          public_key == o.public_key &&
          ssh_keys == o.ssh_keys &&
          sudo == o.sudo &&
          enable_managed_uid == o.enable_managed_uid &&
          unix_uid == o.unix_uid &&
          unix_guid == o.unix_guid &&
          activated == o.activated &&
          tags == o.tags &&
          password_expired == o.password_expired &&
          account_locked == o.account_locked &&
          passwordless_sudo == o.passwordless_sudo &&
          externally_managed == o.externally_managed &&
          external_dn == o.external_dn &&
          external_source_type == o.external_source_type &&
          firstname == o.firstname &&
          lastname == o.lastname &&
          ldap_binding_user == o.ldap_binding_user &&
          enable_user_portal_multifactor == o.enable_user_portal_multifactor &&
          totp_enabled == o.totp_enabled &&
          attributes == o.attributes &&
          created == o.created &&
          samba_service_user == o.samba_service_user &&
          id == o.id &&
          organization == o.organization &&
          addresses == o.addresses &&
          job_title == o.job_title &&
          department == o.department &&
          phone_numbers == o.phone_numbers &&
          relationships == o.relationships &&
          bad_login_attempts == o.bad_login_attempts
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [email, username, allow_public_key, public_key, ssh_keys, sudo, enable_managed_uid, unix_uid, unix_guid, activated, tags, password_expired, account_locked, passwordless_sudo, externally_managed, external_dn, external_source_type, firstname, lastname, ldap_binding_user, enable_user_portal_multifactor, totp_enabled, attributes, created, samba_service_user, id, organization, addresses, job_title, department, phone_numbers, relationships, bad_login_attempts].hash
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def build_from_hash(attributes)
      return nil unless attributes.is_a?(Hash)
      self.class.swagger_types.each_pair do |key, type|
        if type =~ /\AArray<(.*)>/i
          # check to ensure the input is an array given that the the attribute
          # is documented as an array but the input is not
          if attributes[self.class.attribute_map[key]].is_a?(Array)
            self.send("#{key}=", attributes[self.class.attribute_map[key]].map{ |v| _deserialize($1, v) } )
          end
        elsif !attributes[self.class.attribute_map[key]].nil?
          self.send("#{key}=", _deserialize(type, attributes[self.class.attribute_map[key]]))
        end # or else data not found in attributes(hash), not an issue as the data can be optional
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
      when :BOOLEAN
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
        temp_model = JCAPIv1.const_get(type).new
        temp_model.build_from_hash(value)
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
        next if value.nil?
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
        value.compact.map{ |v| _to_hash(v) }
      elsif value.is_a?(Hash)
        {}.tap do |hash|
          value.each { |k, v| hash[k] = _to_hash(v) }
        end
      elsif value.respond_to? :to_hash
        value.to_hash
      else
        value
      end
    end

  end

end
