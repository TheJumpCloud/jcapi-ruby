=begin
#JumpCloud APIs

# JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.

OpenAPI spec version: 2.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require 'date'

module JCAPIv2

  class SystemInsightsSystemInfo
    attr_accessor :hostname

    attr_accessor :uuid

    attr_accessor :cpu_type

    attr_accessor :cpu_subtype

    attr_accessor :cpu_brand

    attr_accessor :cpu_physical_cores

    attr_accessor :cpu_logical_cores

    attr_accessor :cpu_microcode

    attr_accessor :physical_memory

    attr_accessor :hardware_vendor

    attr_accessor :hardware_model

    attr_accessor :hardware_version

    attr_accessor :hardware_serial

    attr_accessor :computer_name

    attr_accessor :local_hostname

    attr_accessor :jc_collection_time

    attr_accessor :jc_system_id

    attr_accessor :jc_organization_id


    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'hostname' => :'hostname',
        :'uuid' => :'uuid',
        :'cpu_type' => :'cpu_type',
        :'cpu_subtype' => :'cpu_subtype',
        :'cpu_brand' => :'cpu_brand',
        :'cpu_physical_cores' => :'cpu_physical_cores',
        :'cpu_logical_cores' => :'cpu_logical_cores',
        :'cpu_microcode' => :'cpu_microcode',
        :'physical_memory' => :'physical_memory',
        :'hardware_vendor' => :'hardware_vendor',
        :'hardware_model' => :'hardware_model',
        :'hardware_version' => :'hardware_version',
        :'hardware_serial' => :'hardware_serial',
        :'computer_name' => :'computer_name',
        :'local_hostname' => :'local_hostname',
        :'jc_collection_time' => :'jc_collection_time',
        :'jc_system_id' => :'jc_system_id',
        :'jc_organization_id' => :'jc_organization_id'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'hostname' => :'String',
        :'uuid' => :'String',
        :'cpu_type' => :'String',
        :'cpu_subtype' => :'String',
        :'cpu_brand' => :'String',
        :'cpu_physical_cores' => :'Integer',
        :'cpu_logical_cores' => :'Integer',
        :'cpu_microcode' => :'String',
        :'physical_memory' => :'String',
        :'hardware_vendor' => :'String',
        :'hardware_model' => :'String',
        :'hardware_version' => :'String',
        :'hardware_serial' => :'String',
        :'computer_name' => :'String',
        :'local_hostname' => :'String',
        :'jc_collection_time' => :'String',
        :'jc_system_id' => :'String',
        :'jc_organization_id' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}){|(k,v), h| h[k.to_sym] = v}

      if attributes.has_key?(:'hostname')
        self.hostname = attributes[:'hostname']
      end

      if attributes.has_key?(:'uuid')
        self.uuid = attributes[:'uuid']
      end

      if attributes.has_key?(:'cpu_type')
        self.cpu_type = attributes[:'cpu_type']
      end

      if attributes.has_key?(:'cpu_subtype')
        self.cpu_subtype = attributes[:'cpu_subtype']
      end

      if attributes.has_key?(:'cpu_brand')
        self.cpu_brand = attributes[:'cpu_brand']
      end

      if attributes.has_key?(:'cpu_physical_cores')
        self.cpu_physical_cores = attributes[:'cpu_physical_cores']
      end

      if attributes.has_key?(:'cpu_logical_cores')
        self.cpu_logical_cores = attributes[:'cpu_logical_cores']
      end

      if attributes.has_key?(:'cpu_microcode')
        self.cpu_microcode = attributes[:'cpu_microcode']
      end

      if attributes.has_key?(:'physical_memory')
        self.physical_memory = attributes[:'physical_memory']
      end

      if attributes.has_key?(:'hardware_vendor')
        self.hardware_vendor = attributes[:'hardware_vendor']
      end

      if attributes.has_key?(:'hardware_model')
        self.hardware_model = attributes[:'hardware_model']
      end

      if attributes.has_key?(:'hardware_version')
        self.hardware_version = attributes[:'hardware_version']
      end

      if attributes.has_key?(:'hardware_serial')
        self.hardware_serial = attributes[:'hardware_serial']
      end

      if attributes.has_key?(:'computer_name')
        self.computer_name = attributes[:'computer_name']
      end

      if attributes.has_key?(:'local_hostname')
        self.local_hostname = attributes[:'local_hostname']
      end

      if attributes.has_key?(:'jc_collection_time')
        self.jc_collection_time = attributes[:'jc_collection_time']
      end

      if attributes.has_key?(:'jc_system_id')
        self.jc_system_id = attributes[:'jc_system_id']
      end

      if attributes.has_key?(:'jc_organization_id')
        self.jc_organization_id = attributes[:'jc_organization_id']
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
          hostname == o.hostname &&
          uuid == o.uuid &&
          cpu_type == o.cpu_type &&
          cpu_subtype == o.cpu_subtype &&
          cpu_brand == o.cpu_brand &&
          cpu_physical_cores == o.cpu_physical_cores &&
          cpu_logical_cores == o.cpu_logical_cores &&
          cpu_microcode == o.cpu_microcode &&
          physical_memory == o.physical_memory &&
          hardware_vendor == o.hardware_vendor &&
          hardware_model == o.hardware_model &&
          hardware_version == o.hardware_version &&
          hardware_serial == o.hardware_serial &&
          computer_name == o.computer_name &&
          local_hostname == o.local_hostname &&
          jc_collection_time == o.jc_collection_time &&
          jc_system_id == o.jc_system_id &&
          jc_organization_id == o.jc_organization_id
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [hostname, uuid, cpu_type, cpu_subtype, cpu_brand, cpu_physical_cores, cpu_logical_cores, cpu_microcode, physical_memory, hardware_vendor, hardware_model, hardware_version, hardware_serial, computer_name, local_hostname, jc_collection_time, jc_system_id, jc_organization_id].hash
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
        temp_model = JCAPIv2.const_get(type).new
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