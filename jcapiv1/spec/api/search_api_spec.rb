=begin
#JumpCloud APIs

# JumpCloud's V1 API. This set of endpoints allows JumpCloud customers to manage commands, systems, & system users.

OpenAPI spec version: 1.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require 'spec_helper'
require 'json'

# Unit tests for JCAPIv1::SearchApi
# Automatically generated by swagger-codegen (github.com/swagger-api/swagger-codegen)
# Please update as you see appropriate
describe 'SearchApi' do
  before do
    # run before each test
    @instance = JCAPIv1::SearchApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of SearchApi' do
    it 'should create an instance of SearchApi' do
      expect(@instance).to be_instance_of(JCAPIv1::SearchApi)
    end
  end

  # unit tests for search_organizations_post
  # Search Organizations
  # This endpoint will return Organization data based on your search parameters. This endpoint WILL NOT allow you to add a new Organization.  You can use the supported parameters and pass those in the body of request.   The parameters must be passed as Content-Type application/json.   #### Sample Request &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/organizations \\   -H &#39;Accept: application/json&#39; \\   -H &#39;Content-Type: application/json&#39; \\   -H &#39;x-api-key: {API_KEY}&#39; \\   -d &#39;{   \&quot;search\&quot;:{     \&quot;fields\&quot; : [\&quot;settings.name\&quot;],     \&quot;searchTerm\&quot;: \&quot;Second\&quot;     },   \&quot;fields\&quot;: [\&quot;_id\&quot;, \&quot;displayName\&quot;, \&quot;logoUrl\&quot;],   \&quot;limit\&quot; : 0,   \&quot;skip\&quot; : 0 }&#39; &#x60;&#x60;&#x60;
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [Search] :body 
  # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  # @option opts [String] :filter A filter to apply to the query.
  # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
  # @option opts [Integer] :skip The offset into the records to return.
  # @return [Organizationslist]
  describe 'search_organizations_post test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for search_systems_post
  # Search Systems
  # Return Systems in multi-record format allowing for the passing of the &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters. This WILL NOT allow you to add a new system.  To support advanced filtering you can use the &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters that can only be passed in the body of POST /api/search/* routes. The &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters must be passed as Content-Type application/json.  The &#x60;filter&#x60; parameter is an object with a single property, either &#x60;and&#x60; or &#x60;or&#x60; with the value of the property being an array of query expressions.   This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the &#x60;and&#x60; or &#x60;or&#x60; are not included the default behavior is to match ALL query expressions.  The &#x60;searchFilter&#x60; parameter allows text searching on supported fields by specifying a &#x60;searchTerm&#x60; and a list of &#x60;fields&#x60; to query on. If any &#x60;field&#x60; has a partial text match on the&#x60;searchTerm&#x60; the record will be returned.   #### Sample Request  Exact search for a list of hostnames &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H &#39;Accept: application/json&#39; \\   -H &#39;Content-Type: application/json&#39; \\   -H &#39;x-api-key: {API_KEY}&#39; \\   -d &#39;{   \&quot;filter\&quot;: {     \&quot;or\&quot;: [       {\&quot;hostname\&quot; : \&quot;my-hostname\&quot;},       {\&quot;hostname\&quot; : \&quot;other-hostname\&quot;}     ]   },   \&quot;fields\&quot; : \&quot;os hostname displayName\&quot; }&#39; &#x60;&#x60;&#x60;  Text search for a hostname or display name &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H &#39;Accept: application/json&#39; \\   -H &#39;Content-Type: application/json&#39; \\   -H &#39;x-api-key: {API_KEY}&#39; \\   -d &#39;{   \&quot;searchFilter\&quot;: {     \&quot;searchTerm\&quot;: \&quot;my-host\&quot;,     \&quot;fields\&quot;: [\&quot;hostname\&quot;, \&quot;displayName\&quot;]   },   \&quot;fields\&quot;: \&quot;os hostname displayName\&quot; }&#39; &#x60;&#x60;&#x60;  Combining &#x60;filter&#x60; and &#x60;searchFilter&#x60; to search for names that match a given OS &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systems \\   -H &#39;Accept: application/json&#39; \\   -H &#39;Content-Type: application/json&#39; \\   -H &#39;x-api-key: {API_KEY}&#39; \\   -d &#39;{   \&quot;searchFilter\&quot;: {     \&quot;searchTerm\&quot;: \&quot;my-host\&quot;,     \&quot;fields\&quot;: [\&quot;hostname\&quot;, \&quot;displayName\&quot;]   },   \&quot;filter\&quot;: {     \&quot;or\&quot;: [       {\&quot;os\&quot; : \&quot;Ubuntu\&quot;},       {\&quot;os\&quot; : \&quot;Mac OS X\&quot;}     ]   },   \&quot;fields\&quot;: \&quot;os hostname displayName\&quot; }&#39; &#x60;&#x60;&#x60;
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [Search] :body 
  # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
  # @option opts [String] :x_org_id 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [String] :filter A filter to apply to the query.
  # @return [Systemslist]
  describe 'search_systems_post test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for search_systemusers_post
  # Search System Users
  # Return System Users in multi-record format allowing for the passing of the &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters. This WILL NOT allow you to add a new system user.  To support advanced filtering you can use the &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters that can only be passed in the body of POST /api/search/* routes. The &#x60;filter&#x60; and &#x60;searchFilter&#x60; parameters must be passed as Content-Type application/json.  The &#x60;filter&#x60; parameter is an object with a single property, either &#x60;and&#x60; or &#x60;or&#x60; with the value of the property being an array of query expressions.   This allows you to filter records using the logic of matching ALL or ANY records in the array of query expressions. If the &#x60;and&#x60; or &#x60;or&#x60; are not included the default behavior is to match ALL query expressions.  The &#x60;searchFilter&#x60; parameter allows text searching on supported fields by specifying a &#x60;searchTerm&#x60; and a list of &#x60;fields&#x60; to query on. If any &#x60;field&#x60; has a partial text match on the&#x60;searchTerm&#x60; the record will be returned.   #### Sample Request  Exact search for a list of system users in a department &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H &#39;Accept: application/json&#39; \\   -H &#39;Content-Type: application/json&#39; \\   -H &#39;x-api-key: {API_KEY}&#39; \\   -d &#39;{   \&quot;filter\&quot; : [{\&quot;department\&quot; : \&quot;IT\&quot;}],   \&quot;fields\&quot; : \&quot;email username sudo\&quot; }&#39; &#x60;&#x60;&#x60;  Text search for system users with and email on a domain &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H &#39;Accept: application/json&#39; \\   -H &#39;Content-Type: application/json&#39; \\   -H &#39;x-api-key: {API_KEY}&#39; \\   -d &#39;{   \&quot;searchFilter\&quot; : {     \&quot;searchTerm\&quot;: \&quot;@jumpcloud.com\&quot;,     \&quot;fields\&quot;: [\&quot;email\&quot;]   },   \&quot;fields\&quot; : \&quot;email username sudo\&quot; }&#39; &#x60;&#x60;&#x60;  Combining &#x60;filter&#x60; and &#x60;searchFilter&#x60; to text search for system users with and email on a domain who are in a list of departments &#x60;&#x60;&#x60; curl -X POST https://console.jumpcloud.com/api/search/systemusers \\   -H &#39;Accept: application/json&#39; \\   -H &#39;Content-Type: application/json&#39; \\   -H &#39;x-api-key: {API_KEY}&#39; \\   -d &#39;{   \&quot;searchFilter\&quot;: {     \&quot;searchTerm\&quot;: \&quot;@jumpcloud.com\&quot;,     \&quot;fields\&quot;: [\&quot;email\&quot;]   },   \&quot;filter\&quot;: {     \&quot;or\&quot;: [       {\&quot;department\&quot; : \&quot;IT\&quot;},       {\&quot;department\&quot; : \&quot;Sales\&quot;}     ]   },   \&quot;fields\&quot; : \&quot;email username sudo\&quot; }&#39; &#x60;&#x60;&#x60;
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [Search] :body 
  # @option opts [String] :fields Use a space seperated string of field parameters to include the data in the response. If omitted, the default list of fields will be returned. 
  # @option opts [String] :filter A filter to apply to the query.
  # @option opts [Integer] :limit The number of records to return at once. Limited to 100.
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [String] :x_org_id 
  # @return [Systemuserslist]
  describe 'search_systemusers_post test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end
