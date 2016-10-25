require 'json'
require 'faraday'

module Mxmnd
  BASE_URL = 'https://geoip.maxmind.com'.freeze
  BASE_PATH = '/geoip/v2.1'.freeze
  USER_ID_ENV_KEY = 'MAX_MIND_USER_ID'.freeze
  LICENSE_KEY_ENV_KEY = 'MAX_MIND_LICENSE_KEY'.freeze

  class << self
    def city(ip, faraday_options = {})
      raise BadRequest.new('IP_ADDRESS_REQUIRED', 'You have not passed IP address.') unless ip
      path = "/city/#{ip}"
      get(connection(faraday_options), path)
    end

    private

    def connection(faraday_options = {})
      @connection ||= Faraday.new(BASE_URL, faraday_options)
    end

    def get(connection, path)
      connection.basic_auth(ENV[USER_ID_ENV_KEY], ENV[LICENSE_KEY_ENV_KEY])
      full_path = "#{BASE_PATH}#{path}"
      response = connection.get(full_path)
      raise_if_error!(response)
      JSON.parse(response.body)
    end

    def raise_if_error!(response)
      case response.status
      when 400 then raise_client_error(response, BadRequest)
      when 401 then raise_client_error(response, Unauthorized)
      when 402 then raise_client_error(response, PaymentRequired)
      when 403 then raise_client_error(response, Forbidden)
      # MaxMind will only return 503, but just in case
      when 500..599 then raise ServerError
      end
    end

    def raise_client_error(response, klass)
      response = JSON.parse(response.body)
      code, error = response.values_at(*%w(code error))
      raise klass.new(code, error)
    end
  end

  class ClientError < StandardError
    attr_reader :code

    def initialize(code, error)
      @code = code
      super(error)
    end
  end

  class Unauthorized < ClientError
    def initialize(code, error)
      msg = "#{error} Set valid #{USER_ID_ENV_KEY} and #{LICENSE_KEY_ENV_KEY} environmental variables to authenticate with MaxMind API." 
      super(code, msg)
    end
  end

  class BadRequest < ClientError; end
  class PaymentRequired < ClientError; end
  class NotFound < ClientError; end
  class Forbidden < ClientError; end

  class ServerError < StandardError
    def initialize
      super('MaxMind service is not available (503)')
    end
  end
end
