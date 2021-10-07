RSpec.shared_examples_for 'an update action' do
  include_context 'with staging configuration'

  let(:attributes) do
    {
      id: "some_id",
      field: 'value'
    }
  end

  subject(:response) do
    described_class.new(*arguments).update(attributes[:id], attributes)
  end

  before do
    request_path = Regexp.new(
      Regexp.escape("webapi/api/#{resource_base_path}/#{attributes[:id]}")
    )

    stub_request(:post, request_path).
      with(body: attributes).
      to_return(
        body: attributes.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  its(:code) { is_expected.to eq(200) }
  its(:data) { is_expected.to include(attributes) }
end
