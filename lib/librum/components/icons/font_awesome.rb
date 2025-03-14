# frozen_string_literal: true

require 'librum/components/icons'

module Librum::Components::Icons
  # A FontAwesome icon.
  #
  # @see https://fontawesome.com/
  class FontAwesome < Librum::Components::Icons::Base
    include Librum::Components::Options::ClassName

    ICON_FAMILY_MAPPINGS = {
      'fa'                  => 'fa-solid',
      'fa-solid'            => 'fa-solid',
      'fas'                 => 'fa-solid',
      'font-awesome'        => 'fa-solid',
      'font-awesome-solid'  => 'fa-solid',
      'fa-brands'           => 'fa-brands',
      'font-awesome-brands' => 'fa-brands'
    }.freeze
    private_constant :ICON_FAMILY_MAPPINGS

    # The valid icon families for a FontAwesome icon.
    ICON_FAMILIES = Set.new(ICON_FAMILY_MAPPINGS.keys).freeze

    # The valid icon sizes for a FontAwesome icon.
    ICON_SIZES = Set.new(
      [
        *(1..10).map { |i| "#{i}x" },
        '2xs',
        'xs',
        'sm',
        'md',
        'lg',
        'xl',
        '2xl'
      ]
    ).freeze

    option :family,
      required: true,
      validate: {
        icon_family: true,
        instance_of: String
      }
    option :fixed_width, boolean:  true
    option :icon,        required: true, validate: String
    option :size,        validate: true

    # @return [ActiveSupport::SafeBuffer] the rendered component.
    def call
      tag.i(class: class_name)
    end

    private

    def class_name
      class_names(
        mapped_family,
        "fa-#{icon}",
        size_class,
        fixed_width? ? 'fa-fw' : nil,
        super
      )
    end

    def mapped_family
      ICON_FAMILY_MAPPINGS[family]
    end

    def size_class
      return if size.nil? || size == 'md'

      "fa-#{size}"
    end

    def validate_size(value, as:)
      return if value.nil?
      return if ICON_SIZES.include?(value.to_s)

      "#{as} is not a valid size"
    end

    def validate_icon_family(value, as:)
      return if ICON_FAMILIES.include?(value)

      "#{as} is not a FontAwesome icon family"
    end
  end
end
