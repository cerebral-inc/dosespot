RSpec.shared_context 'with staging configuration' do
  before do
    ::Dosespot.configure do |config|
      config.environment = :staging
      config.api_key = :some_key
    end
  end
end
