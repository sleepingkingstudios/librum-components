# frozen_string_literal: true

require 'librum/components/options'

RSpec.describe Librum::Components::Options do
  subject(:component) { described_class.new(**component_options) }

  shared_context 'when the component defines options' do
    before(:example) do
      described_class.option :label

      described_class.option :checked, boolean: true
    end
  end

  shared_context 'when the option is defined' do
    before(:example) { described_class.option(name, **meta_options) }
  end

  shared_examples 'should define component option' \
  do |name, boolean: false, default: nil, value: 'value'|
    name = name.to_s
    name = name.sub(/\?\z/, '') if boolean

    let(:expected_value) do
      next super() if defined?(super())

      next false if boolean && default.nil?

      next default unless default.is_a?(Proc)

      instance_exec(&default)
    end

    it { expect(described_class.options.keys).to include name }

    if boolean
      include_examples 'should define predicate', name, -> { expected_value }

      context "when the component is initialized with #{name}: false" do
        let(:component_options) { super().merge(name.intern => false) }

        it { expect(component.send(:"#{name}?")).to be false }
      end

      context "when the component is initialized with #{name}: true" do
        let(:component_options) { super().merge(name.intern => true) }

        it { expect(component.send(:"#{name}?")).to be true }
      end
    else
      include_examples 'should define reader', name, -> { expected_value }

      context "when the component is initialized with #{name}: value" do
        let(:component_options) { super().merge(name.intern => value) }

        it { expect(component.send(name)).to be == value }
      end
    end
  end

  let(:described_class)   { Spec::ExampleComponent }
  let(:component_options) { {} }

  example_class 'Spec::ExampleComponent' do |klass|
    klass.include Librum::Components::Options # rubocop:disable RSpec/DescribedClass
  end

  describe '::DuplicateOptionError' do
    it 'should define the constant' do
      expect(described_class)
        .to define_constant(:DuplicateOptionError)
        .with_value(an_instance_of(Class).and(be < StandardError))
    end
  end

  describe '::InvalidOptionsError' do
    it 'should define the constant' do
      expect(described_class)
        .to define_constant(:InvalidOptionsError)
        .with_value(an_instance_of(Class).and(be < ArgumentError))
    end
  end

  describe '.option' do
    shared_examples 'should check for duplicate options' do
      wrap_context 'when the option is defined' do
        let(:error_message) do
          option_name = "#{name}#{meta_options[:boolean] ? '?' : ''}"

          "unable to define option ##{option_name} - the option is already " \
            "defined on #{described_class.name}"
        end

        it 'should raise an exception' do
          expect { described_class.option(name, **meta_options) }
            .to raise_error(
              Librum::Components::Options::DuplicateOptionError,
              error_message
            )
        end
      end
    end

    shared_examples 'should define the configured option' do
      describe 'with boolean: true' do
        let(:meta_options) { super().merge(boolean: true) }

        it 'should return the name of the generated method' do
          expect(described_class.option(name, **meta_options))
            .to be :"#{name}?"
        end

        include_examples 'should check for duplicate options'

        wrap_context 'when the option is defined' do
          let(:error_message) do
            "unable to define option ##{name}? - the option is already " \
              "defined on #{described_class.name}"
          end

          include_examples 'should define component option',
            'example_option?',
            boolean: true,
            default: false
        end

        describe 'with default: false' do
          let(:meta_options) { super().merge(default: false) }

          wrap_context 'when the option is defined' do
            include_examples 'should define component option',
              'example_option?',
              boolean: true,
              default: false
          end
        end

        describe 'with default: true' do
          let(:meta_options) { super().merge(default: true) }

          wrap_context 'when the option is defined' do
            include_examples 'should define component option',
              'example_option?',
              boolean: true,
              default: true
          end
        end
      end

      describe 'with default: a Proc' do
        let(:meta_options)     { super().merge(default: -> { 'value' }) }
        let(:expected_default) { 'value' }

        wrap_context 'when the option is defined' do
          include_examples 'should define component option',
            'example_option',
            default: -> { expected_default }
        end
      end

      describe 'with default: value' do
        let(:meta_options)     { super().merge(default: 'value') }
        let(:expected_default) { 'value' }

        wrap_context 'when the option is defined' do
          include_examples 'should define component option',
            'example_option',
            default: 'value'
        end
      end

      describe 'with name: a string' do
        it 'should return the name of the generated method' do
          expect(described_class.option(name, **meta_options)).to be name.intern
        end

        include_examples 'should check for duplicate options'

        wrap_context 'when the option is defined' do
          include_examples 'should define component option', 'example_option'
        end
      end

      describe 'with name: a symbol' do
        let(:name) { super().intern }

        it 'should return the name of the generated method' do
          expect(described_class.option(name, **meta_options)).to be name
        end

        include_examples 'should check for duplicate options'

        wrap_context 'when the option is defined' do
          include_examples 'should define component option', 'example_option'
        end
      end
    end

    let(:name)         { 'example_option' }
    let(:meta_options) { {} }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:option)
        .with(1).arguments
        .and_keywords(:boolean, :default)
    end

    include_examples 'should define the configured option'
  end

  describe '.options' do
    include_examples 'should define class reader', :options, -> { {} }

    wrap_context 'when the component defines options' do
      let(:expected) do
        {
          'checked' => Librum::Components::Option.new(
            name:    'checked',
            boolean: true
          ),
          'label'   => Librum::Components::Option.new(name: 'label')
        }
      end

      it { expect(described_class.options).to be == expected }
    end
  end

  describe '#options' do
    include_examples 'should define reader', :options, -> { {} }

    wrap_context 'when the component defines options' do
      it { expect(component.options).to be == {} }

      context 'when initialized with valid options' do
        let(:component_options) do
          super().merge(label: 'Do Not Push', checked: true)
        end

        it { expect(component.options).to be == component_options }
      end
    end
  end
end
