# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Form component adding styling from Bulma.
  #
  # @see https://bulma.io/documentation/form/general/
  class Form < Librum::Components::Form
    include Librum::Components::Bulma::Mixin

    ICONLESS_TYPES = Set.new(%w[checkbox select textarea]).freeze
    private_constant :ICONLESS_TYPES

    option :columns, validate: Integer

    private

    def build_buttons(options:)
      return super unless options.key?(:col_span) || options.key?(:colspan)

      col_span = options.fetch(:col_span, options[:colspan])
      options  = options.except(:col_span, :colspan).merge(
        class_name: bulma_class_names("cell is-col-span-#{col_span}")
      )

      super
    end

    def build_input(name:, options:, type:)
      return super unless options.key?(:col_span) || options.key?(:colspan)

      col_span = options.fetch(:col_span, options[:colspan])
      options  = options.except(:col_span, :colspan).merge(
        class_name: bulma_class_names("cell is-col-span-#{col_span}")
      )

      super
    end

    def form_class_name
      class_names(
        super,
        columns ? bulma_class_names("fixed-grid has-#{columns}-cols") : nil
      )
    end

    def options_for_errors(errors:, type:, **options)
      super.tap do |hsh|
        hsh[:color] = 'danger'

        unless ICONLESS_TYPES.include?(type)
          hsh[:icon_right] = 'exclamation-triangle'
        end
      end
    end

    def render_content
      return super unless columns

      content_tag('div', class: bulma_class_names('grid')) { super }
    end
  end
end
