# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Alert component with icon and message.
  class Alert < Librum::Components::Bulma::Base
    option :icon,    validate: true
    option :message, required: true
    option :type,    required: true

    # @return [String] the configured icon, or the default alert icon for the
    #   specified alert type.
    def icon
      icon = options[:icon]

      return icon unless icon.nil? || icon.empty? # rubocop:disable Rails/Blank

      theme.options["#{type}_icon"]
    end

    private

    def build_icon
      components::Icon.new(class_name: icon_class_name, icon:)
    end

    def class_name
      bulma_class_names(
        'alert',
        "has-text-#{color}",
        "is-#{type}",
        'mb-1'
      )
    end

    def color
      theme.options["#{type}_color"]
    end

    def icon_class_name
      bulma_class_names('has-text-weight-bold')
    end
  end
end
