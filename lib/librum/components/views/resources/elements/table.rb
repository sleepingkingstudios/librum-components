# frozen_string_literal: true

module Librum::Components::Views::Resources::Elements
  # Generic component for rendering a resource list's data fields.
  class Table < Librum::Components::View
    allow_extra_options

    option :data,   validate: Array
    option :routes, required: true, validate: Cuprum::Rails::Routes

    # @overload initialize(request:, resource: nil, result:, **options)
    #   @param result [Cuprum::Result] the result returned by the controller
    #     action.
    #   @param resource [Cuprum::Rails::Resource] the resource for the
    #     controller.
    #   @param options [Hash] additional options for the view.
    def initialize(resource:, result:, **) # rubocop:disable Lint/UselessMethodDefinition
      super
    end

    # @return [ActiveSupport::SafeBuffer] the rendered component.
    def call
      render_table
    end

    private

    def columns
      if self.class.const_defined?(:COLUMNS)
        return evaluate_columns(self.class.const_get(:COLUMNS))
      end

      message =
        "#{self.class.name} is an abstract class - implement a subclass and " \
        'define a #columns method'

      raise message
    end

    def default_empty_message
      "There are no #{resource.plural_name} matching the criteria."
    end

    def evaluate_columns(value)
      return value unless value.is_a?(Proc)

      instance_exec(&value)
    end

    def render_table
      render build_component('DataTable', columns:, **table_options)
    end

    def table_class_name = nil

    def table_options
      {
        columns:,
        empty_message: default_empty_message,
        resource:,
        routes:,
        **options,
        class_name:    table_class_name
      }
    end
  end
end
