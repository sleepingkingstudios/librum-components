# frozen_string_literal: true

require 'support/deferred'

module Spec::Support::Deferred
  module ConfigurationExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    deferred_context 'with configuration' do |**values|
      define_method :configuration do
        Librum::Components::Configuration.instance
      end

      around(:example) do |example|
        original = Librum::Components::Configuration.instance
        config   = Librum::Components::Configuration.new(**values)

        Librum::Components::Configuration.instance = config

        example.call
      ensure
        Librum::Components::Configuration.instance = original
      end
    end
  end
end
