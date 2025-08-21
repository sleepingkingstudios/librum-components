# frozen_string_literal: true

require 'support/deferred'

module Spec::Support::Deferred
  module ConfigurationExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    deferred_context 'with components' do |configured_components = Module.new|
      let(:expected_components) do
        next super() if defined?(super())

        configured_components
      end

      before(:example) do
        # @todo: Replace this with stub_provider().
        registered =
          ::RSpec::Mocks.space.registered?(Librum::Components::Provider)

        unless registered
          # :nocov:
          allow(Librum::Components::Provider)
            .to receive(:get)
            .and_call_original

          allow(Librum::Components::Provider)
            .to receive(:has?)
            .and_call_original
          # :nocov:
        end

        allow(Librum::Components::Provider)
          .to receive(:get)
          .with(:components)
          .and_return(configured_components)

        allow(Librum::Components::Provider)
          .to receive(:has?)
          .with(:components)
          .and_return(true)
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
        # @todo: Replace this with stub_provider().
        registered =
          ::RSpec::Mocks.space.registered?(Librum::Components::Provider)

        unless registered
          # :nocov:
          allow(Librum::Components::Provider)
            .to receive(:get)
            .and_call_original

          allow(Librum::Components::Provider)
            .to receive(:has?)
            .and_call_original
          # :nocov:
        end

        allow(Librum::Components::Provider)
          .to receive(:get)
          .with(:configuration)
          .and_return(configuration)

        allow(Librum::Components::Provider)
          .to receive(:has?)
          .with(:configuration)
          .and_return(true)
      end
    end

    deferred_context 'with routes' do |**routes|
      let(:defined_routes) do
        Struct.new(*routes.keys, keyword_init: true).new(**routes)
      end

      before(:example) do
        # @todo: Replace this with stub_provider().
        registered =
          ::RSpec::Mocks.space.registered?(Librum::Components::Provider)

        unless registered
          # :nocov:
          allow(Librum::Components::Provider)
            .to receive(:get)
            .and_call_original

          allow(Librum::Components::Provider)
            .to receive(:has?)
            .and_call_original
          # :nocov:
        end

        allow(Librum::Components::Provider)
          .to receive(:get)
          .with(:routes)
          .and_return(defined_routes)

        allow(Librum::Components::Provider)
          .to receive(:has?)
          .with(:routes)
          .and_return(true)
      end
    end
  end
end
