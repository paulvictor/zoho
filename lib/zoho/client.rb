module Zoho
  class Client
    attr_accessor :ticket, :api_key
    def initialize(params)
      nil_params = [:LOGIN_ID, :PASSWORD, :servicename] - params.keys
      if nil_params.size != 0
        raise "#{nil_params.join(', ')} are nil"
      end
      @api_key = params['key']
      login_resp = RestClient.post("https://accounts.zoho.com/login", params)
      split_arr = login_resp.split(/\n|\=/)
      ticket_index = split_arr.index('TICKET') + 1
      @ticket = split_arr[ticket_index]
    end
  end
end
