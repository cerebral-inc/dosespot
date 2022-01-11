module Dosespot

  ##
  # Dosespot Response class
  #
  # Encapsulates a parsed json response from Dosespot's API with methods
  # for things like HTTP status codes, etc.
  #

  class Response

    attr_reader :response
    delegate :body, :code, :message, :headers, :parsed_response, to: :response, allow_nil: true
    delegate :[], to: :parsed_response, allow_nil: true

    def initialize(response)
      @response = response
    end

    def success?
      code.to_i / 100 == 2 && data['Result']["ResultCode"] == "OK"
    rescue => e
      false
    end

    def error?
      !success?
    end

    def errors
      errors_list = []

      errors_list << ["Bad response code: #{code}"] unless code.to_i / 100 == 2
      errors_list << ["Invalid response: #{body}"] unless data.is_a?(Hash)

      errors_list
    end

    def error_message
      errors&.join(', ')
    end

    ##
    # Parsed response (e.g. Hash version of json received back)
    #

    def data
      if parsed_response.is_a?(Hash)
        parsed_response&.with_indifferent_access
      elsif parsed_response.is_a?(Array)
        parsed_response.map(&:with_indifferent_access)
      else
        parsed_response
      end
    rescue JSON::ParserError
      # if the server sends an invalid response
      body
    end
  end
end
