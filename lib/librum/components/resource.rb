# frozen_string_literal: true

require 'cuprum/rails/resource'

require 'librum/components'

module Librum::Components
  # Extends a resource class with configuration for view components.
  module Resource
    # @return [Module] the class scope for components defined for the resource.
    def components
      options.fetch(:components, Librum::Components::Empty)
    end

    # @return [String, nil] the name of the attribute used to represent the
    #   resource, or nil if no attribute is selected.
    def title_attribute
      options[:title_attribute]
    end

    # @return [true, false, nil] true if the default form behavior is remote,
    #   i.e. an XHR or Turbo request. A nil value indicates that the form should
    #   default to the global configuration value.
    def remote_forms
      options[:remote_forms]
    end
  end
end
