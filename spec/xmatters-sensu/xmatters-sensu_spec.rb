require 'spec_helper'

describe 'XMSensu' do
  before do
    @uri = 'https://www.google.com/my/path'
    @event = JSON.parse(fixture('sample_event.json').read)

    body = {
      properties: {
        prop1: 'val1',
        prop2: 'val2'
      }
    }
    stub_request(:post, @uri)
      .with(body: body.to_json,
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'text/json',
              'User-Agent' => 'Ruby'
            })
      .to_return(status: 200, body: '', headers: {})
  end

  describe 'version' do
    it 'has a version number' do
      expect(XMSensu::Version).not_to be nil
    end
  end

  describe 'xm_client' do
    it 'should have a client that can be instantiated' do
      xm_client = XMSensu::XMClient.new(@uri)
      expect(xm_client)
    end

    it 'the client should be able to generate a default payload' do
      xm_client = XMSensu::XMClient.new(@uri)
      default_properties = xm_client.get_default_properties(@event)

      client = @event['client']
      check = @event['check']
      subscription_str = client['subscriptions'].join(';')

      expect(default_properties[:server_name]).to eq client['name']
      expect(default_properties[:server_ip]).to eq client['address']
      expect(default_properties[:subscriptions]).to eq subscription_str
      expect(default_properties[:environment]).to eq client['environment']
      expect(default_properties[:check_name]).to eq check['name']
      expect(default_properties[:check_command]).to eq check['command']
      expect(default_properties[:check_output]).to eq check['output']
      expect(default_properties[:timestamp]).to eq @event['timestamp'].inspect
    end

    it 'the client should send an event to the specified path' do
      xm_client = XMSensu::XMClient.new(@uri)
      props = { 'prop1' => 'val1', 'prop2' => 'val2' }
      response = xm_client.send_event(props)
      expect(response.code).to eq '200'
    end
  end
end
