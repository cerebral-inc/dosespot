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

    def get(path)
      perform_checks(path)
      url = build_url(path)
      response = send_authenticated(__callee__, url)
      Response.new(response)
    end
    alias_method :delete, :get

    def post(path, data = {})
      perform_checks(path)
      url = build_url(path)
      response = send_authenticated(__callee__, url, data)
      Response.new(response)
    end
    alias_method :put, :post
    alias_method :patch, :post

    private

    def send_authenticated(method, url, data = {})
      if method == :get
        options = {}
      else
        options = if (data.nil? || data.empty?)
          { body: nil }
        elsif data[:multipart]
          # don't covert to json here for multipart because it messes with files.
          { body: data, multipart: true }
        else
          { body: data.to_json }
        end
      end
      options.merge!(headers: headers(data))

      response = self.class.public_send(
        method, url, options
      )

      if response.code == 401
        raise ::Dosespot::AuthError, 'The token is invalid'
      else
        response
      end
    end

    def api_domain
      if Dosespot.configuration.production?
        'api.dosespot.com'
      else
        'api.falsepill.com'
      end
    end

    def build_url(path)
      ['https://', api_domain, '/v1/', path].join
    end

    JSON_CONTENT_TYPE = 'application/json'
    MULTIPART_CONTENT_TYPE = 'multipart/form-data'

    def headers(data = {})
      content_type = data[:multipart] ? MULTIPART_CONTENT_TYPE : JSON_CONTENT_TYPE
      { Authorization: "ApiKey #{Dosespot.configuration.api_key}",
        'Content-Type': content_type }
    end

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

  end

end
