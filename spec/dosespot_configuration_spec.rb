RSpec.describe Dosespot::Configuration do

  it "has an environment string" do

    Dosespot.configure do |config|
      config.environment = 'sandbox'
    end

    expect(Dosespot.configuration.environment).to eq(:sandbox)
  end

end

