RSpec.describe Dosespot::Resources::Patient do
  include_context 'with sandbox configuration'

  let(:resource_base_path) { "patient" }
  let(:arguments) { [] }

  it_behaves_like 'a read action'
  it_behaves_like 'a list action'
end
