# frozen_string_literal: true

module Librum::Components::Views
  # Generic component for rendering a resource entity's data fields.
  class ResourceBlock < Librum::Components::View
    allow_extra_options

    option :data

    # @return [ActiveSupport::SafeBuffer] the rendered component.
    def call
      render_block
    end

    private

    def render_block
      render build_component('DataList', fields:, **options)
    end

    def fields
      return self.class.const_get(:FIELDS) if self.class.const_defined?(:FIELDS)

      message =
        "#{self.class.name} is an abstract class - implement a subclass and " \
        'define a #fields method'

      raise message
    end
  end
end
