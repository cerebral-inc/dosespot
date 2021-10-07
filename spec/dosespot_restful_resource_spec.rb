RSpec.describe Dosespot::RestfulResource do
  include_context 'with staging configuration'

  context "#resource_base" do
    it "is an underscored pluralized version of the class name" do
      resource = Dosespot::RestfulResource.new
      expect(resource.send(:resource_base)).to eq('restful_resourcea')
    end
  end

  context "#resource_path" do
    it "is the base resource path for the class plus the passed identifier" do
      resource = Dosespot::RestfulResource.new
      expect(resource.send(:resource_path, 123)).to eq('restful_resourcea/123')
    end
  end

end
