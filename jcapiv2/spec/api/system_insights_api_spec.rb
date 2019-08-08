=begin
#JumpCloud APIs

# JumpCloud's V2 API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings and interact with the JumpCloud Graph.

OpenAPI spec version: 2.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require 'spec_helper'
require 'json'

# Unit tests for JCAPIv2::SystemInsightsApi
# Automatically generated by swagger-codegen (github.com/swagger-api/swagger-codegen)
# Please update as you see appropriate
describe 'SystemInsightsApi' do
  before do
    # run before each test
    @instance = JCAPIv2::SystemInsightsApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of SystemInsightsApi' do
    it 'should create an instance of SystemInsightsApi' do
      expect(@instance).to be_instance_of(JCAPIv2::SystemInsightsApi)
    end
  end

  # unit tests for systeminsights_list_apps
  # List System Insights Apps
  # Valid filter fields are &#x60;jc_system_id&#x60; and &#x60;bundle_name&#x60;.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsApps>]
  describe 'systeminsights_list_apps test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_apps_0
  # List System Insights System Apps
  # Valid filter fields are &#x60;bundle_name&#x60;.
  # @param jc_system_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsApps>]
  describe 'systeminsights_list_apps_0 test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_browser_plugins
  # List System Insights System Browser Plugins
  # Valid filter fields are &#x60;name&#x60;.
  # @param jc_system_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsBrowserPlugins>]
  describe 'systeminsights_list_browser_plugins test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_browser_plugins_0
  # List System Insights Browser Plugins
  # Valid filter fields are &#x60;jc_system_id&#x60; and &#x60;name&#x60;.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsBrowserPlugins>]
  describe 'systeminsights_list_browser_plugins_0 test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_chrome_extensions
  # List System Insights System Chrome Extensions
  # Valid filter fields are &#x60;name&#x60;.
  # @param jc_system_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsChromeExtensions>]
  describe 'systeminsights_list_chrome_extensions test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_chrome_extensions_0
  # List System Insights Chrome Extensions
  # Valid filter fields are &#x60;jc_system_id&#x60; and &#x60;name&#x60;.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsChromeExtensions>]
  describe 'systeminsights_list_chrome_extensions_0 test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_disk_encryption
  # List System Insights Disk Encryption
  # Valid filter fields are &#x60;jc_system_id&#x60; and &#x60;encryption_status&#x60;.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsDiskEncryption>]
  describe 'systeminsights_list_disk_encryption test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_disk_encryption_0
  # List System Insights System Disk Encryption
  # Valid filter fields are &#x60;encryption_status&#x60;.
  # @param jc_system_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsDiskEncryption>]
  describe 'systeminsights_list_disk_encryption_0 test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_firefox_addons
  # List System Insights Firefox Addons
  # Valid filter fields are &#x60;jc_system_id&#x60; and &#x60;name&#x60;.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsFirefoxAddons>]
  describe 'systeminsights_list_firefox_addons test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_firefox_addons_0
  # List System Insights System Firefox Addons
  # Valid filter fields are &#x60;name&#x60;.
  # @param jc_system_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsFirefoxAddons>]
  describe 'systeminsights_list_firefox_addons_0 test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_groups
  # List System Insights Groups
  # Valid filter fields are &#x60;jc_system_id&#x60; and &#x60;groupname&#x60;.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsGroups>]
  describe 'systeminsights_list_groups test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_groups_0
  # List System Insights System Groups
  # Valid filter fields are &#x60;groupname&#x60;.
  # @param jc_system_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsGroups>]
  describe 'systeminsights_list_groups_0 test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_interface_addresses
  # List System Insights Interface Addresses
  # Valid filter fields are &#x60;jc_system_id&#x60; and &#x60;address&#x60;.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsInterfaceAddresses>]
  describe 'systeminsights_list_interface_addresses test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_interface_addresses_0
  # List System Insights System Interface Addresses
  # Valid filter fields are &#x60;address&#x60;.
  # @param jc_system_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsInterfaceAddresses>]
  describe 'systeminsights_list_interface_addresses_0 test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_mounts
  # List System Insights Mounts
  # Valid filter fields are &#x60;jc_system_id&#x60; and &#x60;path&#x60;.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsMounts>]
  describe 'systeminsights_list_mounts test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_mounts_0
  # List System Insights System Mounts
  # Valid filter fields are &#x60;path&#x60;.
  # @param jc_system_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsMounts>]
  describe 'systeminsights_list_mounts_0 test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_os_version
  # List System Insights System OS Version
  # Valid filter fields are &#x60;version&#x60;.
  # @param jc_system_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsOsVersion>]
  describe 'systeminsights_list_os_version test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_os_version_0
  # List System Insights OS Version
  # Valid filter fields are &#x60;jc_system_id&#x60; and &#x60;version&#x60;.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsOsVersion>]
  describe 'systeminsights_list_os_version_0 test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_safari_extensions
  # List System Insights System Safari Extensions
  # Valid filter fields are &#x60;name&#x60;.
  # @param jc_system_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsSafariExtensions>]
  describe 'systeminsights_list_safari_extensions test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_safari_extensions_0
  # List System Insights Safari Extensions
  # Valid filter fields are &#x60;jc_system_id&#x60; and &#x60;name&#x60;.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsSafariExtensions>]
  describe 'systeminsights_list_safari_extensions_0 test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_system_info
  # List System Insights System Info
  # Valid filter fields are &#x60;jc_system_id&#x60; and &#x60;cpu_subtype&#x60;.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsSystemInfo>]
  describe 'systeminsights_list_system_info test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_system_info_0
  # List System Insights System System Info
  # Valid filter fields are &#x60;cpu_subtype&#x60;.
  # @param jc_system_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsSystemInfo>]
  describe 'systeminsights_list_system_info_0 test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_users
  # List System Insights Users
  # Valid filter fields are &#x60;jc_system_id&#x60; and &#x60;username&#x60;.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsUsers>]
  describe 'systeminsights_list_users test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for systeminsights_list_users_0
  # List System Insights System Users
  # Valid filter fields are &#x60;username&#x60;.
  # @param jc_system_id 
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :limit 
  # @option opts [Integer] :skip The offset into the records to return.
  # @option opts [Array<String>] :filter Supported operators are: eq
  # @return [Array<SystemInsightsUsers>]
  describe 'systeminsights_list_users_0 test' do
    it "should work" do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end