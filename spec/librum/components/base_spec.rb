# frozen_string_literal: true

require 'librum/components/base'

require 'support/deferred/component_examples'

RSpec.describe Librum::Components::Base do
  include Spec::Support::Deferred::ComponentExamples

  subject(:component) { described_class.new(**component_options) }

  let(:component_options) { {} }

  describe '::AbstractComponentError' do
    it 'should define the constant' do
      expect(described_class)
        .to define_constant(:AbstractComponentError)
        .with_value(an_instance_of(Class).and(be < StandardError))
    end
  end

  describe '::InvalidComponentError' do
    it 'should define the constant' do
      expect(described_class)
        .to define_constant(:InvalidComponentError)
        .with_value(an_instance_of(Class).and(be < StandardError))
    end
  end

  include_deferred 'should be an abstract view component', described_class
end
