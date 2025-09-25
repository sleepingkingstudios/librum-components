# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Component class rendering a row for a data table.
  class DataTable::Row < Librum::Components::Bulma::Base
    allow_extra_options

    option :columns,
      required: true,
      validate: true

    option :data

    private

    def render_cell(column:)
      component = Librum::Components::DataField.new(
        data:,
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
  end
end
