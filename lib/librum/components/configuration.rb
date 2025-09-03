# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Configuration object for Librum::Components.
  class Configuration
    class << self
      # @return [Librum::Components::Configuration] a configuration instance
      #   with default settings.
      def default = @default ||= new
    end

    # Default options for configuration.
    DEFAULTS = {
      'colors'              => [].freeze,
      'default_icon_family' => nil,
      'icon_families'       => [].freeze
    }.freeze

    # @param options [Hash] initialization options for the configuration.
    #
    # @option colors [Array<String>] the colors defined for the component set.
    def initialize(**options)
      @options =
        self.class::DEFAULTS
        .merge(tools.hash_tools.convert_keys_to_strings(options))
        .freeze
    end

    # @return [Hash] initialization options for the configuration.
    attr_reader :options

    # @return [Array<String>] the colors defined for the component set.
    def colors
      @colors ||= Set.new(@options['colors'].map(&:to_s))
    end

    # @return [String] the name of the default icon family, if any.
    def default_icon_family = @options['default_icon_family']

    # Prevents further modifications to the configuration object.
    def freeze
      # Ensure memoized values are hydrated before freezing.
      colors
      icon_families

      super
    end

    # @return [Array<String>] the icon families defined for the component set.
    def icon_families
      @icon_families ||= Set.new(@options['icon_families'].map(&:to_s))
    end

    private

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end
  end
end
