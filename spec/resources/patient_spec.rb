RSpec.describe Dosespot::Resources::Patient do
  include_context 'with staging configuration'

  let(:resource_base_path) { "patients" }
  let(:arguments) { [] }

  it_behaves_like 'a create action'
  it_behaves_like 'an update action'
  it_behaves_like 'a read action'
end
