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

# Unit tests for JCAPIv2::LdapServerInput
# Automatically generated by swagger-codegen (github.com/swagger-api/swagger-codegen)
# Please update as you see appropriate
describe 'LdapServerInput' do
  before do
    # run before each test
    @instance = JCAPIv2::LdapServerInput.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of LdapServerInput' do
    it 'should create an instance of LdapServerInput' do
      expect(@instance).to be_instance_of(JCAPIv2::LdapServerInput)
    end
  end
  describe 'test attribute "name"' do
    it 'should work' do
       # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  describe 'test attribute "user_lockout_action"' do
    it 'should work' do
       # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
       #validator = Petstore::EnumTest::EnumAttributeValidator.new('String', ["disable", "remove"])
       #validator.allowable_values.each do |value|
       #  expect { @instance.user_lockout_action = value }.not_to raise_error
       #end
    end
  end

  describe 'test attribute "user_password_expiration_action"' do
    it 'should work' do
       # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
       #validator = Petstore::EnumTest::EnumAttributeValidator.new('String', ["disable", "remove"])
       #validator.allowable_values.each do |value|
       #  expect { @instance.user_password_expiration_action = value }.not_to raise_error
       #end
    end
  end

end

