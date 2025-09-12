# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Bulma implementation of a semantic table displaying data.
  #
  # @see https://bulma.io/documentation/elements/table/
  class DataTable < Librum::Components::Bulma::Base
    include Librum::Components::Options::ClassName

    allow_extra_options

    option :columns,
      required: true,
      validate: true

    option :data,
      validate: { instance_of: Array }

    option :empty_message

    option :full_width,
      boolean: true,
      default: true

    option :body_component,
      default:  -> { DataTable::Body },
      validate: Class

    option :footer_component,
      validate: Class

    option :header_component,
      default:  -> { DataTable::Header },
      validate: Class

    # @param options [Hash] additional options passed to the component.
    def initialize(**options)
      super

      @options[:columns] = options[:columns].map do |column|
        Librum::Components::DataField::Definition.normalize(column)
      end
    end

    private

    def render_body
      component = body_component.new(**options)

      render(component)
    end

    def render_footer
      return unless footer_component

      component = footer_component.new(**options)

      render(component)
    end

    def render_header
      component = header_component.new(**options)

      render(component)
    end

    def table_class
      class_names(
        bulma_class_names(
          'table',
          full_width? ? 'is-fullwidth' : nil
        ),
        class_name
      )
    end

    def validate_columns(value, as: 'columns')
      Librum::Components::DataField::Definition.validate_list(value, as:)
    end
  end
end
