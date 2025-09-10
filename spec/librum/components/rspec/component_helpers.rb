# frozen_string_literal: true

require 'librum/components/rspec'
require 'librum/components/rspec/matchers/match_snapshot_matcher'
require 'librum/components/rspec/render_component'
require 'librum/components/rspec/deferred/component_examples'

module Librum::Components::RSpec
  # Defines an omakase setup for testing view components.
  module ComponentHelpers
    include Librum::Components::RSpec::Deferred::ComponentExamples
    include Librum::Components::RSpec::Matchers
    include Librum::Components::RSpec::RenderComponent

    def self.included(other)
      super

      other.instance_eval do
        subject(:component) do
          described_class.new(**component_options)
        end

        let(:component_options) { {} }

        define_singleton_method :print_component do
          # :nocov:
          fit { puts pretty_render(rendered) } # rubocop:disable RSpec/NoExpectationExample
          # :nocov:
        end
      end
    end

    def rendered
      render_component(component)
    end
  end
end
