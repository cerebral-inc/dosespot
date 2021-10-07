module Dosespot
  ##
  # Dosespot Configuration class
  #

  class Configuration

    # [String] Environment to use - 'production' or 'staging'. Most probably not used
    attr_reader :environment
    # [String] Client API Key (obtain from the Dosespot portal)
    attr_accessor :api_key
    # [Integer] Clinic ID on the Dosespot side
    attr_accessor :clinic_id
    # [Integer] The pharmacy used by default
    attr_accessor :default_pharmacy_id

    def initialize
      # default to staging environment
      @environment = :staging
    end

    def production?
      environment == :production
    end

    def staging?
      environment == :staging
    end

    def environment=(environment)
      @environment = environment.to_sym
    end

    def api_domain
      production? ? 'my.dosespot.com' : 'my.staging.dosespot.com'
    end

  end

end
