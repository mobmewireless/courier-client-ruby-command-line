require_relative '../spec_helper'

require 'courier_client/client'

module CourierClient
  describe Client do
    let(:mock_access_token) { Faker::Lorem.characters(char_count=10) }
    let(:mock_configuration) {
      double 'Configuration',
             config: {
               api_base_url: 'http://courier.hostname.com/api',
               access_token: mock_access_token
             }.with_indifferent_access,
             store: {}
    }

    before :each do
      CourierClient::Configuration.stub instance: mock_configuration
    end

    describe '#configure' do
      context 'when supplied API base url is nil' do
        it 'raises Exceptions::InvalidUsage' do
          expect {
            subject.configure nil, mock_access_token
          }.to raise_error(Exceptions::InvalidUsage)
        end
      end

      context 'when supplied access token is nil' do
        it 'raises Exceptions::InvalidUsage' do
          expect {
            subject.configure 'http://courier.hostname.com/api', nil
          }.to raise_error(Exceptions::InvalidUsage)
        end
      end

      context 'when there are no exceptions' do
        it 'calls configuration.store to set config' do
          mock_configuration.should_receive(:store).with(api_base_url: 'http://courier.hostname.com/api', access_token: mock_access_token)
          subject.configure 'http://courier.hostname.com/api', mock_access_token
        end
      end
    end

    describe '#send_message' do
      let(:mock_message) { Faker::Lorem.words(num=4).join(' ') }

      context 'when empty message is passed' do
        it 'raises Exceptions::EmptyMessage' do
          expect {
            subject.send_message ' '
          }.to raise_error(Exceptions::EmptyMessage)
        end
      end

      context 'when device name is not passed' do
        it 'posts message and access token to message creation endpoint' do
          stub_request(:post, 'http://courier.hostname.com/api/messages').with(
            access_token: mock_access_token,
            message: mock_message
          ).to_return(body: { status: 'success' }.to_json)

          response = subject.send_message mock_message

          response['status'].should == 'success'
        end
      end

      context 'when device name is passed' do
        let(:mock_device_name) { Faker::Lorem.words(num=2).join('_') }

        context 'when empty device name is passed' do
          it 'raises error Exceptions::EmptyDeviceName' do
            expect {
              subject.send_message 'hello', ' '
            }.to raise_error(Exceptions::EmptyDeviceName)
          end
        end

        it 'posts message and access token to device message creation endpoint' do
          stub_request(:post, "http://courier.hostname.com/api/devices/#{mock_device_name}/messages").with(
            body: {
              access_token: mock_access_token,
              message: mock_message
            }
          ).to_return(body: { status: 'success' }.to_json)

          response = subject.send_message mock_message, mock_device_name

          response['status'].should == 'success'
        end
      end
    end
  end
end
