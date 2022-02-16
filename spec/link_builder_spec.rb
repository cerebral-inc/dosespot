RSpec.describe Dosespot::LinkBuilder do
  include_context 'with staging configuration'
  include_context 'with stubbed token request'

  let(:clinician_id) { 1 }
  let(:extra_params) { {} }

  subject(:result) do
    described_class.new(clinician_id, config).call(extra_params)
  end

  context 'with default configuration' do
    let(:config) { nil }

    it { is_expected.to be_present }
    it { is_expected.to include('dosespot.com') }
    it { is_expected.to include("SingleSignOnUserId=#{clinician_id}") }
    it { is_expected.to include("PharmacyId=#{config_default_pharmacy_id}") }
    it { is_expected.to include("SingleSignOnClinicId=#{config_clinic_id}") }
  end

  context 'with custom configuration' do
    let(:custom_config) do
      configuration = Dosespot::Configuration.new
      configuration.api_key = config_api_key.to_s + '_customized'
      configuration.clinic_id = config_clinic_id + 1
      configuration.default_pharmacy_id = config_default_pharmacy_id + 1

      configuration
    end
    let(:config) { custom_config }

    it { is_expected.to be_present }
    it { is_expected.to include('dosespot.com') }
    it { is_expected.to include("SingleSignOnUserId=#{clinician_id}") }
    it { is_expected.to include("PharmacyId=#{custom_config.default_pharmacy_id}") }
    it { is_expected.to include("SingleSignOnClinicId=#{custom_config.clinic_id}") }
  end
end
