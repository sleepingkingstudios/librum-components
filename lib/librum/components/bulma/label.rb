# frozen_string_literal: true

require 'librum/components/bulma'

module Librum::Components::Bulma
  # Basic component with text and an optional icon.
  class Label < Librum::Components::Bulma::Base
    include Librum::Components::Bulma::Options::Typography
    include Librum::Components::Options::ClassName

    option :color, validate: true
    option :icon,  validate: true
    option :tag,
      default:  'span',
      validate: { inclusion: Set.new(%w[div span]) }
    option :text

    private

    def build_icon
      return icon if icon.is_a?(Librum::Components::Bulma::Icon)

      if icon.is_a?(Hash)
        components::Icon.new(**icon)
      else
        components::Icon.new(icon:)
      end
    end

    def label_class_name
      class_names(
        icon  ? bulma_class_names('icon-text')         : nil,
        color ? bulma_class_names("has-text-#{color}") : nil,
        typography_class,
        class_name
      )
    end
  end
end
