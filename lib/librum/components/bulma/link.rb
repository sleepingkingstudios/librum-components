# frozen_string_literal: true

require 'librum/components/bulma'

module Librum::Components::Bulma
  # Basic navigation component.
  class Link < Librum::Components::Bulma::Base
    include Librum::Components::Bulma::Options::Typography
    include Librum::Components::Options::ClassName

    # The valid option values for the :target option.
    LINK_TARGETS = Set.new(%w[blank self]).freeze

    option :color,  validate: true
    option :icon,   validate: true
    option :target, validate: { inclusion: LINK_TARGETS }
    option :text
    option :url, validate: true

    private

    def attributes
      hsh = { class: link_class_name.presence, href: url }

      hsh[:target] = "_#{target}" if target

      hsh
    end

    def build_icon
      return icon if icon.is_a?(Librum::Components::Bulma::Icon)

      if icon.is_a?(Hash)
        components::Icon.new(**icon)
      else
        components::Icon.new(icon:)
      end
    end

    def link_class_name
      class_names(
        bulma_class_names(
          icon.present? && text.present? ? 'icon-text'         : nil,
          color                          ? "has-text-#{color}" : nil
        ),
        typography_class,
        class_name
      )
    end

    def validate_url(value, as:)
      return if value.nil?
      return if value.is_a?(String) && value.present?

      tools.assertions.error_message_for(
        'sleeping_king_studios.tools.assertions.name',
        as:
      )
    end
  end
end
