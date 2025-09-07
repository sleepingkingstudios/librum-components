# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Icons::Base do
  include Librum::Components::RSpec::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options) { {} }

  include_deferred 'should be an abstract view component', described_class
end
