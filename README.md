# Sensu-Plugins-xMatters

## What is it?

This version of the integration is a simple sensu plugin with a single handler, found at [bin/handler-xmatters.rb](bin/handler-xmatters.rb). The handler will create a new event in xMatters via an inbound integration in the included Sensu Communication Plan.

## How does it work?

### Installation

Before installing the Sensu plugin, import the Sensu communication plan into your xMatters instance. You will need the URLs for the inbound and outbound integrations from the imported plan.

To install the integration, run the following command:

```sh
sensu-install -p xmatters
```

### Configuration

#### Configuring a handler:

To configure a handler, use the following syntax:

```json
{
  "handlers": {
    "xmatters_handler": {
      "type": "pipe",
      "command": "handler-xmatters.rb"
    }
  }
}
```
#### Create a default settings file:

To create a default settings file, use the following syntax, and replace the inbound_integration_url with the URL of the inbound integration in the Sensu communication plan:

```json
{
  "xmatters": {
     "inbound_integration_url": "https://company.instance.xmatters.com/api/integration/1/functions/uuid/triggers"
   }
}
```

To create multiple handlers that point to different integration URLS, use the following syntax:

```json

{
  "handlers": {
    "xmatters_handler": {
      "type": "pipe",
      "command": "handler-xmatters.rb -c xmatters_custom"
    }
  }
}

{
  "xmatters_custom": {
     "inbound_integration_url": "https://company.instance.xmatters.com/api/integration/1/functions/uuid/triggers"
   }
}

```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Development and Publishing

During development, to execute tests and perform additional linting and validation run the following command:

```sh
  bundle exec rake
```

When ready to release a new version, run the following commands:

```sh
  gem build sensu-plugins-xmatters.gemspec
  gem push sensu-plugins-xmatters-x.y.z.gem
```