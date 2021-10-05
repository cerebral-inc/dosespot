require 'httparty'
require 'active_support/core_ext/module'

module Dosespot

  ##
  # Dosespot Request class
  #
  # Represents an authenticated request to the Dosespot API.
  #
  # Not used directly. RestfulResource inherits from this and implements the core, common
  # methods used by the API.
  #

  class Request
    include HTTParty
    debug_output

    base_uri base_api_url

    class RequestError < StandardError; end

    attr_reader :last_response, :clinician_id

    def initialize(clinician_id)
      @clinician_id = clinician_id
    end

    def get(path)
      perform_checks(path)
      response = send_authenticated(__callee__, path)
      Response.new(response)
    end
    alias_method :delete, :get

    def post(path, data = {})
      perform_checks(path)
      response = send_authenticated(__callee__, path, data)
      Response.new(response)
    end
    alias_method :put, :post
    alias_method :patch, :post

    private

    def send_authenticated(method, url, data = {})
      if method == :get
        options = {}
      else
        options = if data.nil? || data.empty?
          { body: nil }
        elsif data[:multipart]
          # don't covert to json here for multipart because it messes with files.
          { body: data, multipart: true }
        else
          { body: data.to_json }
        end
      end
      options.merge!(headers: request_headers(data))

      @last_response = self.class.public_send(
        method, url, options
      )

      if last_response.code == 401
        raise ::Dosespot::AuthError, 'The token is invalid'
      else
        last_response
      end
    end

    JSON_CONTENT_TYPE = 'application/json'
    MULTIPART_CONTENT_TYPE = 'multipart/form-data'

    def perform_checks(path)
      if Dosespot.configuration.api_key.blank?
        raise ::Dosespot::AccessTokenNotPresentError, "Dosespot access token not present"
      end

      # path must:
      # * not be blank
      # * contain a path besides just "/"
      if path.blank? || path.gsub('/', '').empty?
        raise ::Dosespot::InvalidApiUrlError "Dosespot API path passed appears invalid: #{path}"
      end
    end

    def access_token
      if @access_token.present?
        return @access_token
      end

      # Attempt to authenticate up to 3 times
      last_error = nil
      (0..2).each do |i|
        token_response = self.class.post '/token', access_token_options
        unless token_response.code == 200
          raise RequestError.new(token_response.body)
        end

        @access_token = token_response['access_token']
        return @access_token
      rescue Net::ReadTimeout => last_error
        next
      end

      raise last_error if last_error.present?
    end

    def access_token_options
      {
        basic_auth: {
          username: config.clinic_id,
          password: encryption_service.encrypted_clinic_id
        },
        headers: access_token_headers,
        body: access_token_params,
        timeout: 3 # seconds
      }
    end

    def access_token_params
      {
        grant_type: :password,
        Username: clinician_id,
        Password: encryption_service.encrypted_user_id(clinician_id)
      }
    end

    def access_token_headers
      {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'charset' => 'utf-8'
      }
    end

    def request_headers(data = {})
      content_type = data[:multipart] ? MULTIPART_CONTENT_TYPE : JSON_CONTENT_TYPE
      {
        'Content-Type' => content_type,
        'charset' => 'utf-8',
        'Authorization' => "Bearer #{access_token}"
      }
    end

    def encryption_service
      @encryption_service ||= Dosespot::EncryptionService.new
    end

    def self.base_api_url
      api_domain = config.production? ? 'my.dosespot.com' : 'my.staging.dosespot.com'

      "https://#{api_domain}/webapi/"
    end

  end

end
