# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Component class rendering the header for a data table.
  class DataTable::Header < Librum::Components::Bulma::Base
    allow_extra_options

    option :columns,
      required: true,
      validate: true

    private

    def render_item(column)
      content_tag('th') { column.label }
    end

    def validate_columns(value, as: 'columns')
      Librum::Components::DataField::Definition.validate_list(value, as:)
    end
  end
end
