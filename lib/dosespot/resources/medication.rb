module Dosespot
  module Resources
    class Medication < RestfulResource
      def search(data)
        get("medications/search?#{data.to_param}")
      end

      def select(data)
        get("medications/select?#{data.to_param}")
      end
    end
  end
end
