#! /usr/bin/env ruby
#
#   handler-xmatters.rb
#
# DESCRIPTION:
#   This handler creates events in xMatters based on the Sensu event input.
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux, Windows, BSD, Solaris, etc
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#   handler-xmatters.rb -c xmatters
#
# NOTES:
#
# LICENSE:
#   xMatters  alderaan@xmatters.com
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-handler'
require 'xmatters-sensu'

#
# xMatters
#
class XMattersHandler < Sensu::Handler
  option :pattern,
         description: 'Used to allow tests to run only, ignored in code',
         long: '--pattern pattern',
         required: false
  option :config_name,
         description: 'The name of the configuration',
         short: '-c ConfigName',
         long: '--config_name ConfigName',
         required: false,
         default: 'xmatters'

  #
  # The name of the configuration that will be used to find xMatters Settings
  #
  def config_name
    @config_name ||= config[:config_name]
  end

  #
  # The xMatters Settings object
  #
  def xm_settings
    @xm_settings ||= settings[config_name]
  end

  #
  # The integration url that will be used to create an xMatters Event
  #
  def integration_url
    @integration_url ||= xm_settings['inbound_integration_url']
  end

  #
  # Override
  # If the action type is create, we will create an event in xMatters
  # with the default properties payload to the configured inbound
  # integration url in xMatters
  #
  def handle
    xm_client = XMSensu::XMClient.new(integration_url)
    payload = xm_client.get_default_properties(@event)
    begin
      case @event['action']
      when 'create'
        xm_client.send_event(payload)
      when 'resolve'
        puts 'xMatters Handler bypassing resolve'
      end
    end
  end
end
