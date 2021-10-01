# Dosespot API Client

A ruby gem for the Dosespot API.

Dosespot API documentation: https://docs.dosespot.com/#introduction

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dosespot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dosespot

## Usage

First configure the environment and credentials.

In a Rails app, this might go in `config/initializers/dosespot.rb` for example.

```ruby
Dosespot.configure do |config|
  config.environment = Rails.env.production? ? :production : :sandbox
  config.api_key = ENV['DOSESPOT_API_KEY']
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at: [https://github.com/cerebral-inc/dosespot](https://github.com/cerebral-inc/dosespot)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
