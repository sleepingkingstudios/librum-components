# frozen_string_literal: true

require 'librum/components/literal'
require 'librum/components/options/validation_helpers'

RSpec.describe Librum::Components::Options::ValidationHelpers do
  subject(:helpers) { Spec::ValidatedComponent.new(configuration) }

  let(:configuration) do
    Librum::Components::Configuration.new(
      colors: %i[red orange yellow green blue indigo violet]
    )
  end

  example_class 'Spec::ValidatedComponent', Struct.new(:configuration) \
  do |klass|
    klass.include Librum::Components::Options::ValidationHelpers # rubocop:disable RSpec/DescribedClass
  end

  describe '#validate_color' do
    it 'should define the private method' do
      expect(helpers)
        .to respond_to(:validate_color, true)
        .with(1).argument
        .and_keywords(:as)
    end

    describe 'with nil' do
      it { expect(helpers.send(:validate_color, nil)).to be nil }
    end

    describe 'with a value not in configuration.colors' do
      let(:color)   { 'aquamarine' }
      let(:message) { 'color is not a valid color name' }

      it { expect(helpers.send(:validate_color, color)).to be == message }

      describe 'with as: value' do
        let(:as)      { 'tint' }
        let(:message) { 'tint is not a valid color name' }

        it 'should return the error message' do
          expect(helpers.send(:validate_color, color, as:)).to be == message
        end
      end
    end

    describe 'with a value in configuration.colors' do
      let(:color) { 'indigo' }

      it { expect(helpers.send(:validate_color, color)).to be nil }
    end
  end

  describe '#validate_component' do
    it 'should define the private method' do
      expect(helpers)
        .to respond_to(:validate_component, true)
        .with(1).argument
        .and_keywords(:as)
    end

    describe 'with nil' do
      it { expect(helpers.send(:validate_component, nil)).to be nil }
    end

    describe 'with an Object' do
      let(:message) { 'value is not a component or options Hash' }

      it 'should return the error message' do
        expect(helpers.send(:validate_component, Object.new.freeze))
          .to be == message
      end

      describe 'with as: value' do
        let(:as)      { 'logo' }
        let(:message) { 'logo is not a component or options Hash' }

        it 'should return the error message' do
          expect(helpers.send(:validate_component, Object.new.freeze, as:))
            .to be == message
        end
      end
    end

    describe 'with a Hash' do
      it { expect(helpers.send(:validate_component, {})).to be nil }
    end

    describe 'with a component' do
      let(:component) { Librum::Components::Literal.new('<img />') }

      it { expect(helpers.send(:validate_component, component)).to be nil }
    end
  end

  describe '#validate_icon' do
    it 'should define the private method' do
      expect(helpers)
        .to respond_to(:validate_icon, true)
        .with(1).argument
        .and_keywords(:as)
    end

    describe 'with nil' do
      it { expect(helpers.send(:validate_icon, nil)).to be nil }
    end

    describe 'with an Object' do
      let(:message) { 'icon is not a valid icon' }

      it 'should return the error message' do
        expect(helpers.send(:validate_icon, Object.new.freeze)).to be == message
      end

      describe 'with as: value' do
        let(:as)      { 'logo' }
        let(:message) { 'logo is not a valid icon' }

        it 'should return the error message' do
          expect(helpers.send(:validate_icon, Object.new.freeze, as:))
            .to be == message
        end
      end
    end

    describe 'with a String' do
      it { expect(helpers.send(:validate_icon, 'sigil')).to be nil }
    end

    describe 'with a Hash' do
      let(:message) { 'icon is not a valid icon' }

      it 'should return the error message' do
        expect(helpers.send(:validate_icon, {})).to be == message
      end

      describe 'with as: value' do
        let(:as)      { 'logo' }
        let(:message) { 'logo is not a valid icon' }

        it 'should return the error message' do
          expect(helpers.send(:validate_icon, {}, as:)).to be == message
        end
      end
    end

    describe 'with a Hash with icon: value' do
      it { expect(helpers.send(:validate_icon, { icon: 'sigil' })).to be nil }
    end

    describe 'with a component' do
      let(:icon) { Librum::Components::Literal.new('<img />') }

      it { expect(helpers.send(:validate_icon, icon)).to be nil }
    end
  end

  describe '#validate_inclusion' do
    let(:expected) { %w[small medium large] }

    it 'should define the private method' do
      expect(helpers)
        .to respond_to(:validate_inclusion, true)
        .with(1).argument
        .and_keywords(:as, :expected)
    end

    describe 'with nil' do
      it { expect(helpers.send(:validate_inclusion, nil, expected:)).to be nil }
    end

    describe 'with a value not in the list' do
      let(:value)   { 'miniature' }
      let(:message) { 'value is not included in the list' }

      it 'should return the error message' do
        expect(helpers.send(:validate_inclusion, value, expected:))
          .to be == message
      end

      describe 'with as: value' do
        let(:as)      { 'size' }
        let(:message) { 'size is not included in the list' }

        it 'should return the error message' do
          expect(helpers.send(:validate_inclusion, value, as:, expected:))
            .to be == message
        end
      end
    end
  end
end
