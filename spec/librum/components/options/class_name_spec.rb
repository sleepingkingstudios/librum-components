# frozen_string_literal: true

require 'librum/components/options/class_name'

require 'support/deferred/options_examples'

RSpec.describe Librum::Components::Options::ClassName do
  include Spec::Support::Deferred::OptionsExamples

  let(:described_class)   { Spec::ExampleComponent }
  let(:component_options) { {} }

  example_class 'Spec::ExampleComponent' do |klass|
    klass.include Librum::Components::Options
    klass.include Librum::Components::Options::ClassName # rubocop:disable RSpec/DescribedClass
  end

  describe '.new' do
    include_deferred 'should validate the component options'

    include_deferred 'should validate the class_name option'
  end
end
