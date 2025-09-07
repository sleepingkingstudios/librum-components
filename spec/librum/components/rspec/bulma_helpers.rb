# frozen_string_literal: true

require 'librum/components/rspec'
require 'librum/components/rspec/deferred/bulma_examples'

module Librum::Components::RSpec
  # Defines an omakase setup for testing view components.
  module BulmaHelpers
    include Librum::Components::RSpec::Deferred::BulmaExamples

    def self.included(other)
      super

      other.instance_eval do
        let(:configuration_class) { Librum::Components::Bulma::Configuration }
      end
    end
  end
end
