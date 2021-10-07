RSpec.describe Dosespot::Request do
  include_context 'with staging configuration'

  context 'authentication works' do
    it 'sets access_token token' do
      request_service = described_class.new 'fake-clinician-id'
      stub_request(:post, %r{webapi/token})
        .to_return(
          status: 200,
          body: '{"access_token": "fake-access-token"}',
          headers: { 'Content-Type' => 'application/json' }
        )
      expect(request_service.send(:access_token))
        .to eq('fake-access-token')
    end
  end

  context 'authentication error' do
    it 'raises the correct error' do
      request_service = described_class.new 'fake-clinician-id'
      body = '{"access_token": "fake-access-token"}'
      stub_request(:post, %r{webapi/token})
        .to_return(
          status: 403,
          body: body,
          headers: { 'Content-Type' => 'application/json' }
        )
      expect {request_service.send(:access_token)}
        .to raise_error(Dosespot::Request::RequestError)
    end
  end

  context 'authentication timeout' do
    it 'retries twice then raises timeout error' do
      request_service = described_class.new 'fake-clinician-id'
      timeout_stub = stub_request(:post, %r{webapi/token})
                     .to_raise(Net::ReadTimeout)
      expect {request_service.send(:access_token)}
        .to raise_error(Net::ReadTimeout)
      expect(timeout_stub).to have_been_requested.times(3)
    end

    it 'retries then succeeds' do
      request_service = described_class.new 'fake-clinician-id'
      timeout_stub = stub_request(:post, %r{webapi/token})
                     .to_raise(Net::ReadTimeout).then
                     .to_return(
                       status: 200,
                       body: '{"access_token": "fake-access-token"}',
                       headers: { 'Content-Type' => 'application/json' }
                     )
      expect(request_service.send(:access_token))
        .to eq('fake-access-token')
      expect(timeout_stub).to have_been_requested.times(2)
    end
  end
end
