# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Icon component with a bulma wrapper.
  #
  # @see https://bulma.io/documentation/elements/icon/
  class Icon < Librum::Components::Bulma::Base
    include Librum::Components::Options::ClassName

    # The valid icon sizes for a Bulma icon.
    ICON_SIZES = Set.new(%w[small medium large]).freeze

    option :color, validate: true
    option :icon,  required: true, validate: true
    option :size,  validate: { inclusion: ICON_SIZES }

    # @return [ActiveSupport::SafeBuffer] the rendered component.
    def call
      content_tag(:span, class: class_name) do
        render(build_icon)
      end
    end

    private

    def build_icon
      Librum::Components::Icon.build(icon)
    end

    def class_name
      class_names(bulma_class_names('icon', color_class, size_class), super)
    end

    def color_class
      color ? "has-text-#{color}" : nil
    end

    def size_class
      size ? "is-#{size}" : nil
    end
  end
end
