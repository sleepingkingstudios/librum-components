# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Component class rendering the header for a data table.
  class DataTable::Body < Librum::Components::Bulma::Base
    include ActionView::Helpers::SanitizeHelper

    allow_extra_options

    option :columns,
      required: true,
      validate: true

    option :data,
      validate: { instance_of: Array }

    option :empty_message,
      default:  'There are no items matching the criteria.',
      validate: true

    private

    def render_empty_message
      return render(empty_message) if empty_message.is_a?(ViewComponent::Base)

      return empty_message if empty_message.is_a?(ActiveSupport::SafeBuffer)

      sanitize(empty_message, attributes: [], tags: [])
    end

    def render_item(column:, item:)
      component = Librum::Components::DataField.new(
        data:  item,
        field: column,
        **options.except(:columns, :data)
      )

      render(component)
    end

    def table_cell_attributes(column)
      class_name = table_cell_class(column)

      class_name ? { class: class_name } : {}
    end

    def table_cell_class(column)
      return nil unless column.align

      bulma_class_names("has-text-#{column.align}")
    end

    def validate_columns(value, as: 'columns')
      Librum::Components::DataField::Definition.validate_list(value, as:)
    end

    def validate_empty_message(value, as: 'empty_message')
      return if value.nil?

      return if value.is_a?(String)

      return if value.is_a?(ViewComponent::Base)

      "#{as} is not a String or a component"
    end
  end
end
