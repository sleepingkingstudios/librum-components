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
  end
end
