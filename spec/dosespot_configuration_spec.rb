RSpec.describe Dosespot::Configuration do

  it "has an environment string" do

    Dosespot.configure do |config|
      config.environment = 'staging'
    end

    expect(Dosespot.configuration.environment).to eq(:staging)
  end

end

