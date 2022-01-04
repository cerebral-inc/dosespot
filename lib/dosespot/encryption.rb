# frozen_string_literal: true

module Dosespot
  class Encryption
    LENGTH = 32

    attr_reader :api_key

    def initialize(api_key = nil)
      @api_key = api_key || Dosespot.configuration.api_key
    end

    def encrypted_clinic_id
      # the method name is a bit misleading
      # api_key is connected to a clinic
      # so we don't encrypt the clinic_id itself, but we encrypt the related api_key
      random_string + encode(random_string + api_key.to_s)
    end

    def encrypted_user_id(clinician_id)
      encode(clinician_id.to_s + random_string[0..21] + api_key.to_s)
    end

    protected

    def random_string
      @random_string ||= SecureRandom.alphanumeric(LENGTH)
    end

    def encode(string)
      sha512 = OpenSSL::Digest.new('SHA512').digest string
      Base64.encode64(sha512).delete("\n").gsub(/=*$/, '')
    end
  end
end
