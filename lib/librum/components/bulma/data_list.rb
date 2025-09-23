# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Bulma component rendering sequential data, such as an entity's properties.
  class DataList < Librum::Components::Bulma::Base
    include Librum::Components::Options::ClassName

    allow_extra_options

    option :data,   default:  {}
    option :fields, required: true, validate: true

    # @param options [Hash] additional options passed to the component.
    def initialize(**options)
      super

      @options[:fields] = options[:fields].map do |column|
        Librum::Components::DataField::Definition.normalize(column)
      end
    end

    private

    def cell_class_names
      @cell_class_names ||= bulma_class_names(
        'cell is-col-span-3 is-col-span-5-desktop'
      )
    end

    def grid_class_names
      class_names(
        bulma_class_names(
          'fixed-grid has-0-cols has-4-cols-tablet has-6-cols-desktop'
        ),
        class_name
      )
    end

    def label_class_names
      @label_class_names ||= bulma_class_names('cell has-text-weight-semibold')
    end

    def render_item(field:)
      component = Librum::Components::DataField.new(
        data:,
        field:,
        **options.except(:data, :field)
      )

      content_tag('div', class: cell_class_names) do
        render(component)
      end
    end

    def render_label(field:)
      content_tag('div', class: label_class_names) do
        field.label
      end
    end

    def validate_fields(value, as: 'fields')
      Librum::Components::DataField::Definition.validate_list(value, as:)
    end
  end
end
