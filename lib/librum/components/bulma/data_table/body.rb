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

    option :row_component,
      default:  -> { DataTable::Row },
      validate: Class

    private

    def render_empty_message
      return render(empty_message) if empty_message.is_a?(ViewComponent::Base)

      return empty_message if empty_message.is_a?(ActiveSupport::SafeBuffer)

      sanitize(empty_message, attributes: [], tags: [])
    end

    def render_row(item:)
      component = row_component.new(**options, data: item)

      render component
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
