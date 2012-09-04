module Zoho
  class Sheet

    attr_accessor :cli
    attr_accessor :wb_id
    attr_accessor :wb_name
    attr_accessor :update_lock

    def self.auth_with(auth_params)
      @@auth_params = auth_params.merge({:servicename => 'ZohoSheet', :FROM_AGENT => 'true'})
    end

    def self.list(args = nil)
      raise "Zoho::Sheet uninitialized" if @@auth_params.nil?
      cli = Zoho::Client.new(@@auth_params)
      sheets_list_url = "https://sheet.zoho.com/api/private/json/books?apikey=#{cli.api_key}&ticket=#{cli.ticket}"
      if args
        args_in_url_format = ""
        args.each_pair{|k,v| args_in_url_format << "#{k}=#{v}"}
        sheets_list_url << "&" + args_in_url_format
      end
      puts sheets_list_url
      resp = RestClient.get(sheets_list_url)
      JSON.parse(resp)['response']['result']
    end

    def download(format = 'csv')
      raise "Zoho::Sheet uninitialized" if @@auth_params.nil?
      cli = Zoho::Client.new(@@auth_params)
      resp = RestClient.get "https://sheet.zoho.com/api/private/#{format}/download/#{wb_id}?apikey=#{cli.api_key}&ticket=#{cli.ticket}"
    end

    def initialize(workbook_id)
      raise "Zoho::Sheet uninitialized" if @@auth_params.nil?
      @cli = Zoho::Client.new(@@auth_params)
      all_docs = self.class.list
      all_wbs = all_docs['workbooks']['workbook']
      @details = all_wbs.select{|sheet|
        sheet["workbookId"] == workbook_id || sheet['workbookName'] == workbook_id
      }[0]
      @wb_id = @details['workbookId']
      @wb_name = @details['workbookName']
      @update_lock = @details['updateLock']
      @created_time = @details['createdTime']
    end

    def replace_with(file_name, contenttype = 'csv')
      raise "Zoho::Sheet uninitialized" if @@auth_params.nil?
      cli = Zoho::Client.new(@@auth_params)
      puts "https://sheet.zoho.com/api/private/json/savebook/#{wb_id}?apikey=#{cli.api_key}&ticket=#{cli.ticket}&contentType=#{contenttype}&updateLock=#{update_lock}&isOverwrite=true"
      resp = RestClient.post "https://sheet.zoho.com/api/private/json/savebook/#{wb_id}?apikey=#{cli.api_key}&ticket=#{cli.ticket}&contentType=#{contenttype}&updateLock=#{update_lock}&isOverwrite=true", :content => File.new(file_name, 'rb')
    end

    def update(new_row = "")
      existing_data = download || ""
      updated_data = existing_data + "\n" + new_row
      File.open("/tmp/#{@wb_name}.csv", 'w') {|f| f.write(updated_data) }
    end
  end
end
