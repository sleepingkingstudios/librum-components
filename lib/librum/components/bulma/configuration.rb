# frozen_string_literal: true

require 'librum/components'

module Librum::Components::Bulma
  # Configuration object for Librum::Components using the Bulma framework.
  class Configuration < Librum::Components::Configuration
    class << self
      # @return [Librum::Components::Bulma::Configuration] a configuration
      #   instance with default settings.
      def default = @default ||= new
    end

    # Default options for configuration for a Bulma application.
    DEFAULTS = Librum::Components::Configuration::DEFAULTS.merge(
      # See https://bulma.io/documentation/helpers/palette-helpers/
      'colors'              => %w[
        text
        link
        primary
        info
        success
        warning
        danger
      ].freeze,
      'default_icon_family' => 'fa-solid',
      'icon_families'       => [
        *Librum::Components::Icons::FontAwesome::ICON_FAMILIES
      ].freeze
    ).freeze

    # @return [String, nil] the prefix for classes using the Bulma CSS
    #   framework.
    def bulma_prefix = @options['bulma_prefix']
  end
end
