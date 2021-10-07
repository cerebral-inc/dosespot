RSpec.describe Dosespot::Resources::Clinician do
  include_context 'with staging configuration'
  include_context 'with stubbed token request'

  let(:resource_base_path) { "clinicians" }
  let(:arguments) { [1] }

  it_behaves_like 'a create action'
  it_behaves_like 'an update action'
  it_behaves_like 'a read action'
end
