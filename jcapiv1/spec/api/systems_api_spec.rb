=begin
#JumpCloud APIs

#V1 & V2 versions of JumpCloud's API. The previous version of JumpCloud's API. This set of endpoints allows JumpCloud customers to manage commands, systems, & system users.

OpenAPI spec version: 1.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require 'spec_helper'
require 'json'

# Unit tests for JCAPIv1::SystemsApi
# Automatically generated by swagger-codegen (github.com/swagger-api/swagger-codegen)
# Please update as you see appropriate
describe 'SystemsApi' do
  before do
    # run before each test
    @instance = JCAPIv1::SystemsApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of SystemsApi' do
    it 'should create an instance of SystemsApi' do
      expect(@instance).to be_instance_of(JCAPIv1::SystemsApi)
    end
  end

  # unit tests for systems_delete
  # Delete a System
  # Delete a system record by its id. This command will cause the system to uninstall the JumpCloud agent from its self which can can take about a minute. If the system is not connected to JumpCloud the system record will simply be removed.
  # @param id 
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :date Current date header for the System Context API
  # @option opts [String] :authorization Authorization header for the System Context API
  # @return [System]
  describe 'systems_delete test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systems_get
  # List an individual system
  # Returns an individual system.
  # @param id 
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :fields The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  # @option opts [Integer] :limit The number of records to return at once.
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [String] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
  # @option opts [String] :date Current date header for the System Context API
  # @option opts [String] :authorization Authorization header for the System Context API
  # @return [System]
  describe 'systems_get test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systems_list
  # List All Systems
  # Returns all Systems.
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :fields The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  # @option opts [Integer] :limit The number of records to return at once.
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [String] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
  # @return [Systemslist]
  describe 'systems_list test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systems_put
  # Update a system
  # Update a system record by its id and return the modified system record in single record format.
  # @param id 
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [Systemput] :body 
  # @option opts [String] :date Current date header for the System Context API
  # @option opts [String] :authorization Authorization header for the System Context API
  # @return [nil]
  describe 'systems_put test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systems_systemusers_binding_list
  # List system user bindings
  # List system user bindings for a specific system in a system and user binding format.  ### Example  #### List system user bindings for specific system  &#x60;&#x60;&#x60; curl \\   -H &#39;Content-Type: application/json&#39; \\   -H \&quot;x-api-key: [YOUR_API_KEY_HERE]\&quot; \\   \&quot;https://console.jumpcloud.com/api/systems/[SYSTEM_ID_HERE]/systemusers\&quot; &#x60;&#x60;&#x60;
  # @param id 
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :fields The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  # @option opts [Integer] :limit The number of records to return at once.
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [String] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
  # @return [Systemuserbinding]
  describe 'systems_systemusers_binding_list test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systems_systemusers_binding_put
  # Update a system&#39;s or user&#39;s binding
  # Adds or removes a user binding for a system.  This endpoint is only used for users still using JumpCloud Tags. If you are using JumpCloud Groups please refer to the documentation found [here](https://docs.jumpcloud.com/2.0/systems/manage-associations-of-a-system).  ### Example  #### Add (or remove) a system user to (from) a system  &#x60;&#x60;&#x60; curl \\   -d &#39;{ \&quot;add\&quot;: [\&quot;[SYSTEM_USER_ID_TO_ADD_HERE]\&quot;], \&quot;remove\&quot;: [\&quot;[SYSTEM_USER_ID_TO_REMOVE_HERE]\&quot;] }&#39; \\   -X PUT \\   -H &#39;Content-Type: application/json&#39; \\   -H &#39;Accept: application/json&#39; \\   -H \&quot;x-api-key: [YOUR_API_KEY_HERE]\&quot; \\   \&quot;https://console.jumpcloud.com/api/systems/[SYSTEM_ID_HERE]/systemusers
  # @param id 
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [Systemuserbindingsput] :body 
  # @return [nil]
  describe 'systems_systemusers_binding_put test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end
