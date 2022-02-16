RSpec.shared_context 'with staging configuration' do
  let(:config_api_key) { :some_key }
  let(:config_clinic_id) { 1 }
  let(:config_default_pharmacy_id) { 2 }

  before do
    ::Dosespot.configure do |config|
      config.environment = :staging
      config.api_key = config_api_key
      config.clinic_id = config_clinic_id
      config.default_pharmacy_id = config_default_pharmacy_id
    end
  end
end
