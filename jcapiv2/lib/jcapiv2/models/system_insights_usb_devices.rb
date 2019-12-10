=begin
#JumpCloud APIs

# JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.

OpenAPI spec version: 2.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require 'date'

module JCAPIv2

  class SystemInsightsUsbDevices
    attr_accessor :_class

    attr_accessor :collection_time

    attr_accessor :model

    attr_accessor :model_id

    attr_accessor :protocol

    attr_accessor :removable

    attr_accessor :serial

    attr_accessor :subclass

    attr_accessor :system_id

    attr_accessor :usb_address

    attr_accessor :usb_port

    attr_accessor :vendor

    attr_accessor :vendor_id

    attr_accessor :version


    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'_class' => :'class',
        :'collection_time' => :'collection_time',
        :'model' => :'model',
        :'model_id' => :'model_id',
        :'protocol' => :'protocol',
        :'removable' => :'removable',
        :'serial' => :'serial',
        :'subclass' => :'subclass',
        :'system_id' => :'system_id',
        :'usb_address' => :'usb_address',
        :'usb_port' => :'usb_port',
        :'vendor' => :'vendor',
        :'vendor_id' => :'vendor_id',
        :'version' => :'version'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'_class' => :'String',
        :'collection_time' => :'String',
        :'model' => :'String',
        :'model_id' => :'String',
        :'protocol' => :'String',
        :'removable' => :'Integer',
        :'serial' => :'String',
        :'subclass' => :'String',
        :'system_id' => :'String',
        :'usb_address' => :'Integer',
        :'usb_port' => :'Integer',
        :'vendor' => :'String',
        :'vendor_id' => :'String',
        :'version' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}){|(k,v), h| h[k.to_sym] = v}

      if attributes.has_key?(:'class')
        self._class = attributes[:'class']
      end

      if attributes.has_key?(:'collection_time')
        self.collection_time = attributes[:'collection_time']
      end

      if attributes.has_key?(:'model')
        self.model = attributes[:'model']
      end

      if attributes.has_key?(:'model_id')
        self.model_id = attributes[:'model_id']
      end

      if attributes.has_key?(:'protocol')
        self.protocol = attributes[:'protocol']
      end

      if attributes.has_key?(:'removable')
        self.removable = attributes[:'removable']
      end

      if attributes.has_key?(:'serial')
        self.serial = attributes[:'serial']
      end

      if attributes.has_key?(:'subclass')
        self.subclass = attributes[:'subclass']
      end

      if attributes.has_key?(:'system_id')
        self.system_id = attributes[:'system_id']
      end

      if attributes.has_key?(:'usb_address')
        self.usb_address = attributes[:'usb_address']
      end

      if attributes.has_key?(:'usb_port')
        self.usb_port = attributes[:'usb_port']
      end

      if attributes.has_key?(:'vendor')
        self.vendor = attributes[:'vendor']
      end

      if attributes.has_key?(:'vendor_id')
        self.vendor_id = attributes[:'vendor_id']
      end

      if attributes.has_key?(:'version')
        self.version = attributes[:'version']
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
          _class == o._class &&
          collection_time == o.collection_time &&
          model == o.model &&
          model_id == o.model_id &&
          protocol == o.protocol &&
          removable == o.removable &&
          serial == o.serial &&
          subclass == o.subclass &&
          system_id == o.system_id &&
          usb_address == o.usb_address &&
          usb_port == o.usb_port &&
          vendor == o.vendor &&
          vendor_id == o.vendor_id &&
          version == o.version
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [_class, collection_time, model, model_id, protocol, removable, serial, subclass, system_id, usb_address, usb_port, vendor, vendor_id, version].hash
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