module Dosespot

  ##
  # Dosespot RestfulResource class
  #
  # Resource classes should inherit from this class. Defines core methods like list, create, read, update
  # that can then be used by the subclasses by making the applicable methods available.
  #

  class RestfulResource < Request

    protected

    def list(params = {})
      path = path_with_params(resource_base, params)
      get(path)
    end

    def create(data)
      post(resource_base, data)
    end

    def read(id)
      get(resource_path(id))
    end

    def destroy(id)
      delete(resource_path(id))
    end

    def replace(id, data)
      put(resource_path(id), data)
    end

    def update(id, data)
      patch(resource_path(id), data)
    end

    def resource_base
      self.class.name.demodulize.underscore
    end

    def resource_path(id)
      "#{resource_base}/#{id}"
    end

    def path_with_params(path, params)
      return path if params.blank?

      [path, '/?', params.to_query].join
    end

  end

end
