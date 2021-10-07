RSpec.shared_context 'with staging configuration' do
  before do
    ::Dosespot.configure do |config|
      config.environment = :staging
      config.api_key = :some_key
      config.clinic_id = 1
      config.default_pharmacy_id = 2
    end
  end
end
