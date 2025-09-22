# frozen_string_literal: true

require 'cuprum/rails/resource'

require 'librum/components'

module Librum::Components
  # Resource class with configuration for view components.
  class Resource < Cuprum::Rails::Resource
    # @return [Module] the class scope for components defined for the resource.
    def components
      options.fetch(:components, Librum::Components::Empty)
    end

    # @return [String, nil] the name of the attribute used to represent the
    #   resource, or nil if no attribute is selected.
    def title_attribute
      options[:title_attribute]
    end
  end
end
