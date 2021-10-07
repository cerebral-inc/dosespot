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
      get(path_with_params(resource_base, params))
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

    def update(id, data)
      post(resource_path(id), data)
    end

    def resource_base
      self.class.name.demodulize.underscore.pluralize
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
