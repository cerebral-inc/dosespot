RSpec.shared_examples_for 'a destroy action' do
  include_context 'with staging configuration'

  let(:entity_id) { 'some_id' }

  subject(:response) { described_class.new(*arguments).destroy(entity_id) }

  before do
    request_path = Regexp.new(
      Regexp.escape("webapi/api/#{resource_base_path}/#{entity_id}")
    )

    stub_request(:delete, request_path).to_return(status: 204)
  end

  its(:code) { is_expected.to eq(204) }
  its(:data) { is_expected.to be_blank }
end
