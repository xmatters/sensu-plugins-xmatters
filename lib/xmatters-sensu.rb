require 'xmatters-sensu/version'

#
# XMSensu
#
# Holder for common functionality
#
module XMSensu
  #
  # XMSensu::XMClient
  #
  # A class used for common xMatters logic
  #
  class XMClient
    #
    # Constructor
    #
    # integration_url is an inbound integration url from an xMatters Communication Plan
    #
    def initialize(integration_url, user = nil, pass = nil)
      @user = user
      @pass = pass
      @uri = URI(integration_url)
      @header = {
        'Content-Type' => 'text/json'
      }
    end

    #
    # Sends the properties to the configured integration url in the correct json format
    #
    def send_event(properties)
      response = nil
      options = { use_ssl: true }
      Net::HTTP.start(@uri.host, @uri.port, options) do |http|
        request = Net::HTTP::Post.new(@uri, @header)
        request.body = { properties: properties }.to_json
        response = http.request request # Net::HTTPResponse object
        if response.is_a? Net::HTTPSuccess
          puts 'Sent request to xMatters succesfully.'
        else
          puts 'Failed to send request to xMatters.'
        end
      end
      response
    end

    #
    # Gets a default set of properties from the event
    #
    def get_default_properties(event)
      client = event['client']
      check = event['check']
      {
        server_name: client['name'],
        server_ip: client['address'],
        subscriptions: client['subscriptions'].join(';'),
        environment: client['environment'],
        check_name: check['name'],
        check_command: check['command'],
        check_output: check['output'],
        timestamp: event['timestamp'].inspect
      }
    end
  end
end
