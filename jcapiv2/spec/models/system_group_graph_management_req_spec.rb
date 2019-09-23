=begin
#JumpCloud APIs

# JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.

OpenAPI spec version: 2.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require 'spec_helper'
require 'json'
require 'date'

# Unit tests for JCAPIv2::SystemGroupGraphManagementReq
# Automatically generated by swagger-codegen (github.com/swagger-api/swagger-codegen)
# Please update as you see appropriate
describe 'SystemGroupGraphManagementReq' do
  before do
    # run before each test
    @instance = JCAPIv2::SystemGroupGraphManagementReq.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of SystemGroupGraphManagementReq' do
    it 'should create an instance of SystemGroupGraphManagementReq' do
      expect(@instance).to be_instance_of(JCAPIv2::SystemGroupGraphManagementReq)
    end
  end
  describe 'test attribute "id"' do
    it 'should work' do
       # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  describe 'test attribute "op"' do
    it 'should work' do
       # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
       #validator = Petstore::EnumTest::EnumAttributeValidator.new('String', ["add", "remove", "update"])
       #validator.allowable_values.each do |value|
       #  expect { @instance.op = value }.not_to raise_error
       #end
    end
  end

  describe 'test attribute "type"' do
    it 'should work' do
       # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
       #validator = Petstore::EnumTest::EnumAttributeValidator.new('String', ["active_directory", "application", "command", "g_suite", "ldap_server", "office_365", "policy", "radius_server", "user", "user_group"])
       #validator.allowable_values.each do |value|
       #  expect { @instance.type = value }.not_to raise_error
       #end
    end
  end

end

