# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/provider'

require 'librum/components/rspec/deferred'

module Librum::Components::RSpec::Deferred
  # Deferred examples for stubbing provider values.
  module ConfigurationExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    deferred_context 'with components' do |configured_components = Module.new|
      let(:expected_components) do
        next super() if defined?(super())

        configured_components
      end

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          configured_components
        )
      end
    end

    deferred_context 'with configuration' do |**values|
      let(:configuration_class) do
        next super() if defined?(super())

        Librum::Components::Configuration
      end
      let(:configuration) do
        previous_options = defined?(super()) ? super().options : {}

        configuration_class.new(
          **configuration_class::DEFAULTS,
          **previous_options,
          **values
        )
      end
      let(:expected_configuration) do
        next super() if defined?(super())

        configuration
      end

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :configuration,
          configuration
        )
      end
    end

    deferred_context 'with routes' do |**routes|
      let(:defined_routes) do
        Struct.new(*routes.keys, keyword_init: true).new(**routes)
      end

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :routes,
          defined_routes
        )
      end
    end
  end
end
