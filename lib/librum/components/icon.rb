# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Generic icon component.
  class Icon < Librum::Components::Base
    ICON_CLASSES = [
      Librum::Components::Icons::FontAwesome
    ].freeze
    private_constant :ICON_CLASSES

    ICON_FAMILY_MAPPINGS =
      ICON_CLASSES
      .flat_map do |icon_class|
        icon_class::ICON_FAMILIES.map { |family| [family, icon_class] }
      end
      .to_h
    private_constant :ICON_FAMILY_MAPPINGS

    allow_extra_options

    option :family
    option :icon, required: true, validate: String

    # (see Librum::Components::Base#initialize)
    def initialize(configuration: nil, **options)
      unless options.key?(:family)
        options = options.merge(family: configuration&.default_icon_family)
      end

      super

      validate_icon_family(family, as: 'icon_family')
    end

    # @return [ActiveSupport::SafeBuffer] the rendered component.
    def call
      icon_class = ICON_FAMILY_MAPPINGS[family]

      return icon_class.new(configuration:, **options).call if icon_class

      tag.i(
        class: 'fa-solid fa-bug',
        style: 'color: red;',
        data:  { family:, icon: }
      )
    end

    private

    def validate_icon_family(value, as:)
      return if configuration.icon_families.include?(value)

      if value.is_a?(String)
        raise InvalidOptionsError, "#{as} is not a configured icon family"
      end

      raise InvalidOptionsError, "#{as} is not an instance of String"
    end
  end
end
