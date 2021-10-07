module Dosespot
  module Resources
    class Notification < RestfulResource
      def total
        get('notifications/counts')
      end
    end
  end
end
