=begin
#JumpCloud APIs

#V1 & V2 versions of JumpCloud's API. The next version of JumpCloud's API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings. The most recent version of JumpCloud's API. This set of endpoints allows JumpCloud customers to manage objects, groupings and mappings.

OpenAPI spec version: 2.0

Generated by: https://github.com/swagger-api/swagger-codegen.git

=end

require "uri"

module JCAPIv2
  class WorkdayApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end

    # Delete Workday
    # This endpoint allows you to delete a workday
    # @param id 
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @option opts [WorkdayRequest] :body 
    # @return [nil]
    def workdays_delete(id, content_type, accept, opts = {})
      workdays_delete_with_http_info(id, content_type, accept, opts)
      return nil
    end

    # Delete Workday
    # This endpoint allows you to delete a workday
    # @param id 
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @option opts [WorkdayRequest] :body 
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def workdays_delete_with_http_info(id, content_type, accept, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WorkdayApi.workdays_delete ..."
      end
      # verify the required parameter 'id' is set
      fail ArgumentError, "Missing the required parameter 'id' when calling WorkdayApi.workdays_delete" if id.nil?
      # verify the required parameter 'content_type' is set
      fail ArgumentError, "Missing the required parameter 'content_type' when calling WorkdayApi.workdays_delete" if content_type.nil?
      # verify the required parameter 'accept' is set
      fail ArgumentError, "Missing the required parameter 'accept' when calling WorkdayApi.workdays_delete" if accept.nil?
      # resource path
      local_var_path = "/workdays/{id}".sub('{format}','json').sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'Content-Type'] = content_type
      header_params[:'Accept'] = accept

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(opts[:'body'])
      auth_names = ['x-api-key']
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayApi#workdays_delete\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Get Workday
    # 
    # @param id 
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @return [WorkdayOutput]
    def workdays_get(id, content_type, accept, opts = {})
      data, _status_code, _headers = workdays_get_with_http_info(id, content_type, accept, opts)
      return data
    end

    # Get Workday
    # 
    # @param id 
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @return [Array<(WorkdayOutput, Fixnum, Hash)>] WorkdayOutput data, response status code and response headers
    def workdays_get_with_http_info(id, content_type, accept, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WorkdayApi.workdays_get ..."
      end
      # verify the required parameter 'id' is set
      fail ArgumentError, "Missing the required parameter 'id' when calling WorkdayApi.workdays_get" if id.nil?
      # verify the required parameter 'content_type' is set
      fail ArgumentError, "Missing the required parameter 'content_type' when calling WorkdayApi.workdays_get" if content_type.nil?
      # verify the required parameter 'accept' is set
      fail ArgumentError, "Missing the required parameter 'accept' when calling WorkdayApi.workdays_get" if accept.nil?
      # resource path
      local_var_path = "/workdays/{id}".sub('{format}','json').sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'Content-Type'] = content_type
      header_params[:'Accept'] = accept

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'WorkdayOutput')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayApi#workdays_get\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # List Workdays
    # 
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :fields The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  (default to )
    # @option opts [String] :filter Supported operators are: eq, ne, gt, ge, lt, le, between, search (default to )
    # @option opts [Integer] :limit The number of records to return at once. (default to 10)
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @option opts [String] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  (default to )
    # @return [Array<WorkdayOutput>]
    def workdays_list(content_type, accept, opts = {})
      data, _status_code, _headers = workdays_list_with_http_info(content_type, accept, opts)
      return data
    end

    # List Workdays
    # 
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :fields The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
    # @option opts [String] :filter Supported operators are: eq, ne, gt, ge, lt, le, between, search
    # @option opts [Integer] :limit The number of records to return at once.
    # @option opts [Integer] :skip The offset into the records to return.
    # @option opts [String] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @return [Array<(Array<WorkdayOutput>, Fixnum, Hash)>] Array<WorkdayOutput> data, response status code and response headers
    def workdays_list_with_http_info(content_type, accept, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WorkdayApi.workdays_list ..."
      end
      # verify the required parameter 'content_type' is set
      fail ArgumentError, "Missing the required parameter 'content_type' when calling WorkdayApi.workdays_list" if content_type.nil?
      # verify the required parameter 'accept' is set
      fail ArgumentError, "Missing the required parameter 'accept' when calling WorkdayApi.workdays_list" if accept.nil?
      # resource path
      local_var_path = "/workdays".sub('{format}','json')

      # query parameters
      query_params = {}
      query_params[:'fields'] = opts[:'fields'] if !opts[:'fields'].nil?
      query_params[:'filter'] = opts[:'filter'] if !opts[:'filter'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?
      query_params[:'sort'] = opts[:'sort'] if !opts[:'sort'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'Content-Type'] = content_type
      header_params[:'Accept'] = accept

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'Array<WorkdayOutput>')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayApi#workdays_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Create new Workday
    # This endpoint allows you to create a new workday object
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @option opts [Body] :body 
    # @return [WorkdayOutput]
    def workdays_post(content_type, accept, opts = {})
      data, _status_code, _headers = workdays_post_with_http_info(content_type, accept, opts)
      return data
    end

    # Create new Workday
    # This endpoint allows you to create a new workday object
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @option opts [Body] :body 
    # @return [Array<(WorkdayOutput, Fixnum, Hash)>] WorkdayOutput data, response status code and response headers
    def workdays_post_with_http_info(content_type, accept, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WorkdayApi.workdays_post ..."
      end
      # verify the required parameter 'content_type' is set
      fail ArgumentError, "Missing the required parameter 'content_type' when calling WorkdayApi.workdays_post" if content_type.nil?
      # verify the required parameter 'accept' is set
      fail ArgumentError, "Missing the required parameter 'accept' when calling WorkdayApi.workdays_post" if accept.nil?
      # resource path
      local_var_path = "/workdays".sub('{format}','json')

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'Content-Type'] = content_type
      header_params[:'Accept'] = accept

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(opts[:'body'])
      auth_names = ['x-api-key']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'WorkdayOutput')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayApi#workdays_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Update Workday
    # This endpoint allows you to update the name and report_url for a Workday Authentication Edit
    # @param id 
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @option opts [WorkdayInput] :body 
    # @return [WorkdayOutput]
    def workdays_put(id, content_type, accept, opts = {})
      data, _status_code, _headers = workdays_put_with_http_info(id, content_type, accept, opts)
      return data
    end

    # Update Workday
    # This endpoint allows you to update the name and report_url for a Workday Authentication Edit
    # @param id 
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @option opts [WorkdayInput] :body 
    # @return [Array<(WorkdayOutput, Fixnum, Hash)>] WorkdayOutput data, response status code and response headers
    def workdays_put_with_http_info(id, content_type, accept, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WorkdayApi.workdays_put ..."
      end
      # verify the required parameter 'id' is set
      fail ArgumentError, "Missing the required parameter 'id' when calling WorkdayApi.workdays_put" if id.nil?
      # verify the required parameter 'content_type' is set
      fail ArgumentError, "Missing the required parameter 'content_type' when calling WorkdayApi.workdays_put" if content_type.nil?
      # verify the required parameter 'accept' is set
      fail ArgumentError, "Missing the required parameter 'accept' when calling WorkdayApi.workdays_put" if accept.nil?
      # resource path
      local_var_path = "/workdays/{id}".sub('{format}','json').sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'Content-Type'] = content_type
      header_params[:'Accept'] = accept

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(opts[:'body'])
      auth_names = ['x-api-key']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'WorkdayOutput')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayApi#workdays_put\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Get Workday Report Results
    # 
    # @param id 
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :fields The comma separated fields included in the returned records. If omitted the default list of fields will be returned.  (default to )
    # @option opts [String] :filter Supported operators are: eq, ne, gt, ge, lt, le, between, search (default to )
    # @option opts [String] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending.  (default to )
    # @option opts [Integer] :skip The offset into the records to return. (default to 0)
    # @return [WorkdayReportResult]
    def workdays_report(id, content_type, accept, opts = {})
      data, _status_code, _headers = workdays_report_with_http_info(id, content_type, accept, opts)
      return data
    end

    # Get Workday Report Results
    # 
    # @param id 
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :fields The comma separated fields included in the returned records. If omitted the default list of fields will be returned. 
    # @option opts [String] :filter Supported operators are: eq, ne, gt, ge, lt, le, between, search
    # @option opts [String] :sort The comma separated fields used to sort the collection. Default sort is ascending, prefix with &#x60;-&#x60; to sort descending. 
    # @option opts [Integer] :skip The offset into the records to return.
    # @return [Array<(WorkdayReportResult, Fixnum, Hash)>] WorkdayReportResult data, response status code and response headers
    def workdays_report_with_http_info(id, content_type, accept, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WorkdayApi.workdays_report ..."
      end
      # verify the required parameter 'id' is set
      fail ArgumentError, "Missing the required parameter 'id' when calling WorkdayApi.workdays_report" if id.nil?
      # verify the required parameter 'content_type' is set
      fail ArgumentError, "Missing the required parameter 'content_type' when calling WorkdayApi.workdays_report" if content_type.nil?
      # verify the required parameter 'accept' is set
      fail ArgumentError, "Missing the required parameter 'accept' when calling WorkdayApi.workdays_report" if accept.nil?
      # resource path
      local_var_path = "/workdays/{id}/report".sub('{format}','json').sub('{' + 'id' + '}', id.to_s)

      # query parameters
      query_params = {}
      query_params[:'fields'] = opts[:'fields'] if !opts[:'fields'].nil?
      query_params[:'filter'] = opts[:'filter'] if !opts[:'filter'].nil?
      query_params[:'sort'] = opts[:'sort'] if !opts[:'sort'].nil?
      query_params[:'skip'] = opts[:'skip'] if !opts[:'skip'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'Content-Type'] = content_type
      header_params[:'Accept'] = accept

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'WorkdayReportResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayApi#workdays_report\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Get Workday Settings
    # This endpoint allows you to obtain all settings needed for creating a workday instance, namely the URL to initiate an OAuth negotiation
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :state 
    # @return [InlineResponse200]
    def workdays_settings(content_type, accept, opts = {})
      data, _status_code, _headers = workdays_settings_with_http_info(content_type, accept, opts)
      return data
    end

    # Get Workday Settings
    # This endpoint allows you to obtain all settings needed for creating a workday instance, namely the URL to initiate an OAuth negotiation
    # @param content_type 
    # @param accept 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :state 
    # @return [Array<(InlineResponse200, Fixnum, Hash)>] InlineResponse200 data, response status code and response headers
    def workdays_settings_with_http_info(content_type, accept, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WorkdayApi.workdays_settings ..."
      end
      # verify the required parameter 'content_type' is set
      fail ArgumentError, "Missing the required parameter 'content_type' when calling WorkdayApi.workdays_settings" if content_type.nil?
      # verify the required parameter 'accept' is set
      fail ArgumentError, "Missing the required parameter 'accept' when calling WorkdayApi.workdays_settings" if accept.nil?
      # resource path
      local_var_path = "/workdays/settings".sub('{format}','json')

      # query parameters
      query_params = {}
      query_params[:'state'] = opts[:'state'] if !opts[:'state'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])
      header_params[:'Content-Type'] = content_type
      header_params[:'Accept'] = accept

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['x-api-key']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'InlineResponse200')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WorkdayApi#workdays_settings\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
