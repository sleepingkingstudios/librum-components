# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Configuration object for Librum::Components.
  class Configuration
    # Singleton configuration instance.
    def self.instance = @instance ||= new

    # Default options for configuration.
    DEFAULTS = {}.freeze

    # @param options [Hash] initialization options for the configuration.
    def initialize(**options)
      @options =
        DEFAULTS
        .merge(tools.hash_tools.convert_keys_to_strings(options))
        .freeze
    end

    # @return [Hash] initialization options for the configuration.
    attr_reader :options

    private

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end
  end
end
