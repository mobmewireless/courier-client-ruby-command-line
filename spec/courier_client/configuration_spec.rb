require_relative '../spec_helper'

module CourierClient
  describe Configuration do
    subject { Configuration.instance }

    before :all do
      # Let's create the home folder, since that'll exist.
      FakeFS do
        FileUtils.mkdir_p `echo $HOME`
      end
    end

    describe '#config' do
      context 'when the config file does not exists' do
        before :each do
          FakeFS do
            FileUtils.rm_r(File.join(`echo $HOME`.strip, '.courier'), force: true)
          end
        end

        it 'raises Exceptions::ConfigurationMissing' do
          FakeFS do
            expect {
              subject.config
            }.to raise_error(Exceptions::ConfigurationMissing)
          end
        end
      end

      context 'when the config file exists' do
        let(:mock_configuration) {
          {
            access_token: Faker::Lorem.characters(char_count=10)
          }
        }

        before :each do
          FakeFS do
            config_directory = File.join `echo $HOME`.strip, '.courier'

            FileUtils.mkdir_p(config_directory)

            File.open(File.join(config_directory, 'config.yml'), 'w') do |f|
              YAML.dump(mock_configuration, f)
            end
          end
        end

        it 'returns the parsed configuration hash with indifferent access' do
          configuration = nil

          FakeFS do
            configuration = subject.config
          end

          configuration[:access_token].should == mock_configuration[:access_token]
          configuration[:access_token].should == configuration['access_token']
        end
      end
    end

    describe '#store' do
      let(:base_url) { "http://base_url/#{rand(1000)}" }
      let(:access_token) { Faker::Lorem.characters(char_count=10) }

      it 'stores the supplied hash in configuration file' do
        FakeFS do
          subject.store(api_base_url: base_url, access_token: access_token)

          config_file = File.join `echo $HOME`.strip, '.courier', 'config.yml'
          YAML.load_file(config_file).should == { api_base_url: base_url, access_token: access_token }
        end
      end

      it 'returns configuration with indifferent access' do
        return_value = nil

        FakeFS do
          return_value = subject.store(api_base_url: base_url, access_token: access_token)
        end

        return_value[:access_token].should == access_token
        return_value[:access_token].should == return_value['access_token']
      end
    end
  end
end
