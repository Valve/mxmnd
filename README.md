[![Code Climate](https://codeclimate.com/github/Valve/mxmnd/badges/gpa.svg)](https://codeclimate.com/github/Valve/mxmnd)

# Mxmnd

Minimalistic MaxMind API wrapper for Ruby.

`Faraday` is the only runtime dependency.

Supports only `#city` API call. API compatible with `Geoip2.city`.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mxmnd'
```

## Usage

```ruby
Mxmnd.city('8.8.8.8')
```

If you want to use faraday options, you can pass them as a second parameter:

```ruby
Mxmnd.city('8.8.8.8', request: {timeout: 1})
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

