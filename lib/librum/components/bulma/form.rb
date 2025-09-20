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

    private

    def options_for_errors(errors:, type:, **options)
      super.tap do |hsh|
        hsh[:color] = 'danger'

        unless ICONLESS_TYPES.include?(type)
          hsh[:icon_right] = 'exclamation-triangle'
        end
      end
    end
  end
end
