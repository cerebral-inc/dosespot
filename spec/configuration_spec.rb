RSpec.describe Dosespot::Configuration do
  context 'with the staging environment' do
    before do
      Dosespot.configure do |config|
        config.environment = 'staging'
      end
    end

    subject(:service) { Dosespot.configuration }

    its(:environment) { is_expected.to eq :staging }
    its(:api_domain) { is_expected.to eq 'my.staging.dosespot.com' }
    it { is_expected.to be_staging }
    it { is_expected.not_to be_production }
  end

  context 'with the production environment' do
    before do
      Dosespot.configure do |config|
        config.environment = 'production'
      end
    end

    subject(:service) { Dosespot.configuration }

    its(:environment) { is_expected.to eq :production }
    its(:api_domain) { is_expected.to eq 'my.dosespot.com' }
    it { is_expected.not_to be_staging }
    it { is_expected.to be_production }
  end
end
