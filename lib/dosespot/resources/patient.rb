module Dosespot
  module Resources
    class Patient < RestfulResource
      public :create, :update, :read

      def search(data)
        get("#{resource_base}/search?#{data.to_param}")
      end

      def find_prescriptions(id, data = {})
        get("#{resource_path(id)}/prescriptions?#{data.to_param}")
      end
    end
  end
end
