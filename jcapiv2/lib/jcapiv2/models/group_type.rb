=begin
#JumpCloud APIs

#V1 & V2 versions of JumpCloud's API. The next version of JumpCloud's API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings. The most recent version of JumpCloud's API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings.

OpenAPI spec version: 2.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require 'date'

module JCAPIv2
  class GroupType
    
    SYSTEM_GROUP = "system_group".freeze
    USER_GROUP = "user_group".freeze

    # Builds the enum from string
    # @param [String] The enum value in the form of the string
    # @return [String] The enum value
    def build_from_hash(value)
      constantValues = GroupType.constants.select{|c| GroupType::const_get(c) == value}
      raise "Invalid ENUM value #{value} for class #GroupType" if constantValues.empty?
      value
    end
  end

end
