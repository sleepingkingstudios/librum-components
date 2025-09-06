# frozen_string_literal: true

require 'librum/components/base'
require 'librum/components/rspec/deferred/component_examples'

RSpec.describe Librum::Components::Base do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options) { {} }

  include_deferred 'should be an abstract view component', described_class
end
