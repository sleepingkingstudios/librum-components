# frozen_string_literal: true

require 'librum/components/bulma/options/typography'

require 'support/deferred/bulma_examples'
require 'support/deferred/options_examples'

RSpec.describe Librum::Components::Bulma::Options::Typography do
  include Spec::Support::Deferred::BulmaExamples
  include Spec::Support::Deferred::OptionsExamples

  subject(:component) { described_class.new(**component_options) }

  let(:described_class)     { Spec::ExampleComponent }
  let(:component_options)   { {} }
  let(:configuration_class) { Librum::Components::Bulma::Configuration }

  example_class 'Spec::ExampleComponent', Librum::Components::Bulma::Base \
  do |klass|
    klass.include Librum::Components::Bulma::Options::Typography # rubocop:disable RSpec/DescribedClass
  end

  describe '::ALIGNMENTS' do
    include_examples 'should define immutable constant',
      :ALIGNMENTS,
      Set.new(%w[centered justified left right])
  end

  describe '::FONT_FAMILIES' do
    include_examples 'should define immutable constant',
      :FONT_FAMILIES,
      Set.new(%w[code monospace primary sans-serif secondary])
  end

  describe '::SIZES' do
    include_examples 'should define immutable constant',
      :SIZES,
      Set.new([1, 2, 3, 4, 5, 6, 7, '1', '2', '3', '4', '5', '6', '7'])
  end

  describe '::TRANSFORMS' do
    include_examples 'should define immutable constant',
      :TRANSFORMS,
      Set.new(%w[capitalized lowercase uppercase])
  end

  describe '::WEIGHTS' do
    include_examples 'should define immutable constant',
      :WEIGHTS,
      Set.new(%w[light normal medium semibold bold])
  end

  include_deferred 'should define typography options'
end
