module Dosespot
  module Resources
    class Patient < RestfulResource
      public :list, :read

      def create(data)
        put(resource_base, data)
      end

      def get_prescriptions(data)
        path = "#{resource_path(data)}/prescriptions"
        get(path)
      end

    end
  end
end
