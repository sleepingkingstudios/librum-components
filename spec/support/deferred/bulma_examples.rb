# frozen_string_literal: true

require 'support/deferred'
require 'support/deferred/configuration_examples'
require 'support/deferred/options_examples'

module Spec::Support::Deferred
  module BulmaExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    deferred_context 'should define typography options' do
      include Spec::Support::Deferred::ConfigurationExamples
      include Spec::Support::Deferred::OptionsExamples

      include_deferred 'should define component option',
        :alignment,
        value: 'justified'

      include_deferred 'should define component option',
        :font_family,
        value: 'sans-serif'

      include_deferred 'should define component option',
        :italic,
        boolean: true

      include_deferred 'should define component option',
        :size,
        value: '3'

      include_deferred 'should define component option',
        :transform,
        value: 'capitalized'

      include_deferred 'should define component option',
        :underlined,
        boolean: true

      include_deferred 'should define component option',
        :weight,
        value: 'semibold'

      describe '.new' do
        typography = Librum::Components::Bulma::Options::Typography

        include_deferred 'should validate the component options'

        include_deferred 'should validate the inclusion of option',
          :alignment,
          expected: typography::ALIGNMENTS

        include_deferred 'should validate the inclusion of option',
          :font_family,
          expected: typography::FONT_FAMILIES

        include_deferred 'should validate the inclusion of option',
          :size,
          expected: typography::SIZES

        include_deferred 'should validate the inclusion of option',
          :transform,
          expected: typography::TRANSFORMS

        include_deferred 'should validate the inclusion of option',
          :weight,
          expected: typography::WEIGHTS
      end

      describe '#typography_class' do
        include_examples 'should define private reader', :typography_class, ''

        context 'when initialized with alignment: value' do
          let(:component_options) { super().merge(alignment: 'centered') }
          let(:expected)          { 'has-text-centered' }

          it { expect(component.send(:typography_class)).to be == expected }
        end

        context 'when initialized with font_family: value' do
          let(:component_options) { super().merge(font_family: 'sans-serif') }
          let(:expected)          { 'is-family-sans-serif' }

          it { expect(component.send(:typography_class)).to be == expected }
        end

        context 'when initialized with italic: true' do
          let(:component_options) { super().merge(italic: true) }
          let(:expected)          { 'is-italic' }

          it { expect(component.send(:typography_class)).to be == expected }
        end

        context 'when initialized with size: value' do
          let(:component_options) { super().merge(size: 3) }
          let(:expected)          { 'is-size-3' }

          it { expect(component.send(:typography_class)).to be == expected }
        end

        context 'when initialized with transform: value' do
          let(:component_options) { super().merge(transform: 'uppercase') }
          let(:expected)          { 'is-uppercase' }

          it { expect(component.send(:typography_class)).to be == expected }
        end

        context 'when initialized with underlined: true' do
          let(:component_options) { super().merge(underlined: true) }
          let(:expected)          { 'is-underlined' }

          it { expect(component.send(:typography_class)).to be == expected }
        end

        context 'when initialized with weight: value' do
          let(:component_options) { super().merge(weight: 'semibold') }
          let(:expected)          { 'has-text-weight-semibold' }

          it { expect(component.send(:typography_class)).to be == expected }
        end

        context 'when initialized with multiple options' do
          let(:component_options) do
            super()
              .merge(italic: true, font_family: 'primary', weight: 'semibold')
          end
          let(:expected) do
            'has-text-weight-semibold is-family-primary is-italic'
          end

          it { expect(component.send(:typography_class)).to be == expected }
        end

        context 'with configuration: { bulma_prefix: value }' do
          include_deferred 'with configuration', bulma_prefix: 'bulma-'

          context 'when initialized with alignment: value' do
            let(:component_options) { super().merge(alignment: 'centered') }
            let(:expected)          { 'bulma-has-text-centered' }

            it { expect(component.send(:typography_class)).to be == expected }
          end

          context 'when initialized with font_family: value' do
            let(:component_options) { super().merge(font_family: 'sans-serif') }
            let(:expected)          { 'bulma-is-family-sans-serif' }

            it { expect(component.send(:typography_class)).to be == expected }
          end

          context 'when initialized with italic: true' do
            let(:component_options) { super().merge(italic: true) }
            let(:expected)          { 'bulma-is-italic' }

            it { expect(component.send(:typography_class)).to be == expected }
          end

          context 'when initialized with size: value' do
            let(:component_options) { super().merge(size: 3) }
            let(:expected)          { 'bulma-is-size-3' }

            it { expect(component.send(:typography_class)).to be == expected }
          end

          context 'when initialized with transform: value' do
            let(:component_options) { super().merge(transform: 'uppercase') }
            let(:expected)          { 'bulma-is-uppercase' }

            it { expect(component.send(:typography_class)).to be == expected }
          end

          context 'when initialized with underlined: true' do
            let(:component_options) { super().merge(underlined: true) }
            let(:expected)          { 'bulma-is-underlined' }

            it { expect(component.send(:typography_class)).to be == expected }
          end

          context 'when initialized with weight: value' do
            let(:component_options) { super().merge(weight: 'semibold') }
            let(:expected)          { 'bulma-has-text-weight-semibold' }

            it { expect(component.send(:typography_class)).to be == expected }
          end

          context 'when initialized with multiple options' do
            let(:component_options) do
              super()
                .merge(italic: true, font_family: 'primary', weight: 'semibold')
            end
            let(:expected) do
              'bulma-has-text-weight-semibold bulma-is-family-primary ' \
                'bulma-is-italic'
            end

            it { expect(component.send(:typography_class)).to be == expected }
          end
        end
      end
    end
  end
end
