# frozen_string_literal: true

module Librum::Components::Views::Resources::Elements
  # Generic component for rendering a resource entity's data fields.
  class Block < Librum::Components::View
    allow_extra_options

    option :data

    # @return [ActiveSupport::SafeBuffer] the rendered component.
    def call
      render_block
    end

    private

    def evaluate_fields(value)
      return value unless value.is_a?(Proc)

      instance_exec(&value)
    end

    def fields
      if self.class.const_defined?(:FIELDS)
        return evaluate_fields(self.class.const_get(:FIELDS))
      end

      message =
        "#{self.class.name} is an abstract class - implement a subclass and " \
        'define a #fields method'

      raise message
    end

    def render_block
      render build_component('DataList', fields:, **options)
    end
  end
end
