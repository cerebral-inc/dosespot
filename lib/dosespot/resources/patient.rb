module Dosespot
  module Resources
    class Patient < RestfulResource
      public :create, :update, :read

      def search(data)
        get("#{resource_base}/search", data)
      end

      def find_prescriptions(id, data = {})
        get("#{resource_path(id)}/prescriptions", data)
      end
    end
  end
end
