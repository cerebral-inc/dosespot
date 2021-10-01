RSpec.shared_context 'with sandbox configuration' do
  before do
    ::Dosespot.configure do |config|
      config.environment = :sandbox
      config.api_key = :some_key
    end
  end
end
