# frozen_string_literal: true

require 'librum/components'

module Librum::Components
  # Visual configuration options for Librum::Components.
  class Theme
    # Default options for themes.
    DEFAULTS = {
      'danger_color'  => nil,
      'danger_icon'   => nil,
      'error_color'   => nil,
      'error_icon'    => nil,
      'info_color'    => nil,
      'info_icon'     => nil,
      'success_color' => nil,
      'success_icon'  => nil,
      'warning_color' => nil,
      'warning_icon'  => nil
    }.freeze

    class << self
      # @return [Librum::Components::Theme] a theme instance with default
      #   settings.
      def default = @default ||= new
    end

    # @param options [Hash] initialization options for the theme.
    #
    # @option options danger_color [String, nil] the color used to indicate a
    #   dangerous action, such as a delete.
    # @option options danger_icon [String, nil] the icon used to indicate a
    #   dangerous action, such as a delete.
    # @option options error_color [String, nil] the color used to indicate an
    #   invalid or errored state, such as a failed form validation.
    # @option options error_icon [String, nil] the icon used to indicate an
    #   invalid or errored state, such as a failed form validation.
    # @option options info_color [String, nil] the color used to indicate an
    #   informational message.
    # @option options info_icon [String, nil] the icon used to indicate an
    #   informational message.
    # @option options success_color [String, nil] the color used to indicate a
    #   success state.
    # @option options success_icon [String, nil] the icon used to indicate a
    #   success state.
    # @option options warning_color [String, nil] the color used to indicate a
    #   warning message.
    # @option options warning_icon [String, nil] the icon used to indicate a
    #   warning message.
    def initialize(**options)
      @options =
        self.class::DEFAULTS
        .merge(tools.hash_tools.convert_keys_to_strings(options))
        .freeze
    end

    # @return [Hash] initialization options for the theme.
    attr_reader :options

    # @return [String, nil] the color used to indicate a dangerous action, such
    #   as a delete.
    def danger_color = @options['danger_color']

    # @return [String, nil] the icon used to indicate a dangerous action, such
    #   as a delete.
    def danger_icon = @options['danger_icon']

    # @return [String, nil] the color used to indicate an invalid or errored
    #   state, such as a failed form validation.
    def error_color = @options['error_color']

    # @return [String, nil] the icon used to indicate an invalid or errored
    #   state, such as a failed form validation.
    def error_icon = @options['error_icon']

    # @return [String, nil] the color used to indicate an informational message.
    def info_color = @options['info_color']

    # @return [String, nil] the icon used to indicate an informational message.
    def info_icon = @options['info_icon']

    # @return [String, nil] the color used to indicate a success state.
    def success_color = @options['success_color']

    # @return [String, nil] the icon used to indicate a success state.
    def success_icon = @options['success_icon']

    # @return [String, nil] the color used to indicate a warning message.
    def warning_color = @options['warning_color']

    # @return [String, nil] the icon used to indicate a warning message.
    def warning_icon = @options['warning_icon']

    private

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end
  end
end
