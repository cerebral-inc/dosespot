RSpec.shared_context 'with stubbed token request' do
  before do
    stub_request(:post, /webapi\/token/).
      to_return(
        status: 200,
        body: { access_token: :token }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end
end
