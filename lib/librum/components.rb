# frozen_string_literal: true

require 'zeitwerk'

# A Ruby application toolkit.
module Librum; end

loader = Zeitwerk::Loader.for_gem_extension(Librum)
loader.inflector.inflect('rspec' => 'RSpec')
loader.setup

require 'plumbum'

module Librum
  # Component library for Librum applications.
  module Components
    # Required keys for the base components provider.
    PROVIDER_KEYS = %w[components configuration routes].freeze

    class << self
      # @return [Pathname] the javascript path for the gem.
      def javascript_path
        File.join(root_path, 'app', 'javascript')
      end

      # @return [Plumbum::ManyProvider] a provider for managing component
      #   dependencies.
      def provider
        @provider ||= Plumbum::ManyProvider.new(
          write_once: true,
          values:     PROVIDER_KEYS.to_h { |key| [key, Plumbum::UNDEFINED] } # rubocop:disable Rails/IndexWith
        )
      end

      # Sets the provider if it is not already initialized.
      #
      # @param value [Plumbum::Provider] the provider to set.
      #
      # @raises [Librum::Components::Errors::ExistingProviderError] if the
      #   provider is already defined.
      # @raises [Librum::Components::Errors::InvalidProviderError] if the value is
      #   not a provider or does not provide the necessary keys.
      def provider=(value)
        validate_provider(value)
        validate_provider_keys(value)

        if @provider
          raise Librum::Components::Errors::ExistingProviderError,
            'provider already exists'
        end

        @provider = value
      end

      # @return [String] the root path for the gem.
      def root_path
        @root_path ||= File.expand_path(__dir__).sub('/lib/librum', '')
      end

      # @return [Pathname] the stylesheets path for the gem.
      def stylesheets_path
        File.join(root_path, 'app', 'assets', 'stylesheets')
      end

      # @return [String] the current version of the gem.
      def version
        VERSION
      end

      private

      def tools
        SleepingKingStudios::Tools::Toolbelt.instance
      end

      def validate_provider(value)
        return if value.is_a?(Plumbum::Provider)

        error_message = tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.instance_of',
          expected: Plumbum::Provider
        )

        raise ArgumentError, error_message
      end

      def validate_provider_keys(value)
        missing_keys = PROVIDER_KEYS.reject do |key|
          value.has?(key, allow_undefined: true)
        end

        return if missing_keys.empty?

        error_message =
          'provider does not define required keys ' \
          "#{missing_keys.map(&:inspect).join(', ')}"

        raise ArgumentError, error_message
      end
    end
  end
end

require 'librum/components/railtie' if defined?(Rails::Railtie)
