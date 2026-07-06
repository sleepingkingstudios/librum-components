# frozen_string_literal: true

require 'librum/components/bulma/layouts/page'

module Librum::Components::Bulma::Layouts
  # Renders the alerts for a page component.
  class Page::Alerts < Librum::Components::Bulma::Base
    REQUIRED_KEYS = %i[message type].freeze
    private_constant :REQUIRED_KEYS

    option :alerts, validate: true

    private

    def build_alert(alert)
      components::Alert.new(**alert)
    end

    def class_name
      bulma_class_names('block')
    end

    def instance_error(as:, expected:)
      tools.assertions.error_message_for(:instance_of, as:, expected:)
    end

    def presence_error(as:)
      tools.assertions.error_message_for(:presence, as:)
    end

    def validate_alert(alert, as:)
      return presence_error(as:) if alert.nil?

      return instance_error(as:, expected: Hash) unless alert.is_a?(Hash)

      missing_keys = REQUIRED_KEYS.reject { |key| alert.key?(key) }

      return if missing_keys.empty?

      "#{as} missing required keys (#{missing_keys.map(&:inspect).join(', ')})"
    end

    def validate_alerts(alerts, as: 'alerts')
      return presence_error(as:) if alerts.nil?

      return instance_error(as:, expected: Array) unless alerts.is_a?(Array)

      return presence_error(as:) if alerts.empty?

      alerts
        .map
        .with_index do |alert, index|
          validate_alert(alert, as: "#{as}[#{index}]")
        end
        .compact
        .join(', ')
    end
  end
end
