=begin
#JumpCloud APIs

#V1 & V2 versions of JumpCloud's API. The previous version of JumpCloud's API. This set of endpoints allows JumpCloud customers to manage commands, systems, & system users.

OpenAPI spec version: 1.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require 'spec_helper'
require 'json'

# Unit tests for JCAPIv1::ApplicationsApi
# Automatically generated by swagger-codegen (github.com/swagger-api/swagger-codegen)
# Please update as you see appropriate
describe 'ApplicationsApi' do
  before do
    # run before each test
    @instance = JCAPIv1::ApplicationsApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of ApplicationsApi' do
    it 'should create an instance of ApplicationsApi' do
      expect(@instance).to be_instance_of(JCAPIv1::ApplicationsApi)
    end
  end

  # unit tests for applications_list
  # Applications
  # The endpoint returns all your SSO / SAML Applications.  #### Sample Request &#x60;&#x60;&#x60; curl -X GET https://console.jumpcloud.com/api/applications \\   -H &#39;Accept: application/json&#39; \\   -H &#39;Content-Type: application/json&#39; \\   -H &#39;x-api-key: {API_KEY}&#39;  &#x60;&#x60;&#x60;
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :fields The comma separated fileds included in the returned records. If omitted the default list of fields will be returned.
  # @option opts [Integer] :limit The number of records to return at once.
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [String] :sort 
  # @return [InlineResponse200]
  describe 'applications_list test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end
