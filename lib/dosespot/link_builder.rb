# frozen_string_literal: true

module Dosespot
  class LinkBuilder
    attr_reader :clinician_id, :config

    def initialize(clinician_id, config = nil)
      @clinician_id = clinician_id
      @config = config || Dosespot.configuration
    end

    def call(extra_params = {})
      base_url + '?' + base_params.merge(extra_params).compact.to_param
    end

    protected

    def base_url
      "https://#{config.api_domain}/LoginSingleSignOn.aspx"
    end

    def base_params
      {
        b: 2,
        PharmacyId: config.default_pharmacy_id,
        SingleSignOnClinicId: config.clinic_id,
        SingleSignOnUserId: clinician_id,
        SingleSignOnPhraseLength: Dosespot::Encryption::LENGTH,
        SingleSignOnCode: sso_code,
        SingleSignOnUserIdVerify: sso_verify
      }
    end

    def sso_code
      encryption_service.encrypted_clinic_id
    end

    def sso_verify
      encryption_service.encrypted_user_id clinician_id
    end

    def encryption_service
      @encryption_service ||= Dosespot::Encryption.new(config.api_key)
    end
  end
end
