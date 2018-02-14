require 'json'
require_relative '../spec_helper.rb'
require_relative '../../bin/handler-xmatters.rb'

# rubocop:disable Style/ClassVars
class XMattersHandler
  at_exit do
    @@autorun = false
  end

  def settings
    @settings ||= JSON.parse(fixture('xmatters_settings.json').read)
  end
end

describe 'Handlers' do
  before do
    @handler = XMattersHandler.new

    @body = {
      properties: {
        server_name: 'sample-client',
        server_ip: '127.0.0.1',
        subscriptions: 'dev;client:sample-client',
        environment: 'development',
        check_name: 'sample-check',
        check_command: 'check-process.rb -p cron',
        check_output: "CheckProcess CRITICAL: Found 0 matching processes; cmd /cron/\n",
        timestamp: '1489170215'
      }
    }

    @event_stub_success = stub_request(:post, 'https://test.xmatters.com/my/path')
                          .with(body: @body.to_json,
                                headers: {
                                  'Accept' => '*/*',
                                  'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                                  'Content-Type' => 'text/json',
                                  'User-Agent' => 'Ruby'
                                })
                          .to_return(status: 200, body: '', headers: {})
  end

  describe '#config_name' do
    it 'should return xmatters' do
      expect(@handler.config_name).to eq('xmatters')
    end

    it 'should return custom' do
      config_name = XMattersHandler.new('-c custom_config'.split).config_name
      expect(config_name).to eq('custom_config')
    end
  end

  describe '#xm_settings' do
    it 'should return xmatters settings' do
      expect(@handler.xm_settings.to_json).to eq('{"inbound_integration_url":"https://test.xmatters.com/my/path"}')
    end

    it 'should return custom settings' do
      xm_settings = XMattersHandler.new('-c custom_config'.split).xm_settings
      expect(xm_settings.to_json).to eq('{"inbound_integration_url":"https://custom.xmatters.com/my/path"}')
    end
  end

  describe '#integration_url' do
    it 'should return standard url' do
      expect(@handler.integration_url).to eq('https://test.xmatters.com/my/path')
    end

    it 'should return custom url' do
      integration_url = XMattersHandler.new('-c custom_config'.split).integration_url
      expect(integration_url).to eq('https://custom.xmatters.com/my/path')
    end
  end

  describe '#handle' do
    it 'should send the correct payload to the configured url' do
      event = fixture('sample_event.json')
      @handler.read_event(event)
      @handler.handle
    end

    it 'should not send the correct payload to the configured url' do
      remove_request_stub(@event_stub_success)

      event = fixture('sample_resolve.json')
      @handler.read_event(event)
      @handler.handle
    end

    it 'should send the correct payload to the configured url with query details' do
      remove_request_stub(@event_stub_success)
      stub_request(:post, 'https://test.xmatters.com/my/path?apiKey=some-type-of-key')
        .with(body: @body.to_json,
              headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type' => 'text/json',
                'User-Agent' => 'Ruby'
              })
        .to_return(status: 201, body: '', headers: {})

      handler_with_key = XMattersHandler.new('-c custom_config_with_apiKey'.split)
      event = fixture('sample_event.json')
      handler_with_key.read_event(event)
      handler_with_key.handle
    end
  end
end
