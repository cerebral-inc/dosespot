module Dosespot
  ##
  # Dosespot Configuration class
  #

  class Configuration

    # [String] Environment to use - 'production' or 'sandbox'
    attr_reader :environment
    # [String] Client API Key (obtain from the Dosespot portal)
    attr_accessor :api_key

    def initialize
      # default to sandbox environment
      @environment = :sandbox
    end

    def production?
      environment == :production
    end

    def sandbox?
      environment == :sandbox
    end

    def environment=(environment = :sandbox)
      @environment = environment.to_sym
    end

  end

end
