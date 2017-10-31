=begin
#JumpCloud APIs

#V1 & V2 versions of JumpCloud's API. The previous version of JumpCloud's API. This set of endpoints allows JumpCloud customers to manage commands, systems, & system users.

OpenAPI spec version: 1.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.0-SNAPSHOT

=end

require 'spec_helper'
require 'json'

# Unit tests for JCAPIv1::TagsApi
# Automatically generated by swagger-codegen (github.com/swagger-api/swagger-codegen)
# Please update as you see appropriate
describe 'TagsApi' do
  before do
    # run before each test
    @instance = JCAPIv1::TagsApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of TagsApi' do
    it 'should create an instance of TagsApi' do
      expect(@instance).to be_instance_of(JCAPIv1::TagsApi)
    end
  end

  # unit tests for tags_delete
  # Delete a Tag
  # Delete a Tag.
  # @param name 
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @return [Tag]
  describe 'tags_delete test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for tags_get
  # List a Tag
  # Returns a specific tag.
  # @param name 
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :fields The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  # @option opts [Integer] :limit The number of records to return at once.
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [String] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
  # @return [Tag]
  describe 'tags_get test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for tags_list
  # List All Tags
  # Returns all Tags.
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [String] :fields The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
  # @option opts [Integer] :limit The number of records to return at once.
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [String] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
  # @return [Tagslist]
  describe 'tags_list test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for tags_post
  # Create a Tag
  # Create a tag.  ### Examples #### Create a new Tag  &#x60;&#x60;&#x60; curl \\   -d &#39;{\&quot;name\&quot; : \&quot;Developers\&quot;}&#39; \\   -X &#39;POST&#39; \\   -H &#39;Content-Type: application/json&#39; \\   -H &#39;Accept: application/json&#39; \\   -H \&quot;x-api-key: [YOUR_API_KEY_HERE]\&quot; \\   \&quot;https://console.jumpcloud.com/api/tags\&quot; &#x60;&#x60;&#x60;
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [Tagpost] :body 
  # @return [Tag]
  describe 'tags_post test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for tags_put
  # Update a Tag
  # Update a specific tag.
  # @param name 
  # @param content_type 
  # @param accept 
  # @param [Hash] opts the optional parameters
  # @option opts [Tagput] :body 
  # @return [Tag]
  describe 'tags_put test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end
