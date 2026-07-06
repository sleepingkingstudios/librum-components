# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Theme do
  subject(:theme) { described_class.new(**options) }

  let(:options) { {} }

  describe '::DEFAULTS' do
    include_examples 'should define immutable constant',
      :DEFAULTS,
      -> { an_instance_of(Hash) }

    describe 'danger_color' do
      it { expect(described_class::DEFAULTS['danger_color']).to be == 'danger' }
    end

    describe 'danger_icon' do
      let(:expected) { 'circle-xmark' }

      it { expect(described_class::DEFAULTS['danger_icon']).to be == expected }
    end

    describe 'error_color' do
      it { expect(described_class::DEFAULTS['error_color']).to be == 'danger' }
    end

    describe 'error_icon' do
      let(:expected) { 'circle-xmark' }

      it { expect(described_class::DEFAULTS['error_icon']).to be == expected }
    end

    describe 'info_color' do
      it { expect(described_class::DEFAULTS['info_color']).to be == 'info' }
    end

    describe 'info_icon' do
      let(:expected) { 'circle-info' }

      it { expect(described_class::DEFAULTS['info_icon']).to be == expected }
    end

    describe 'success_color' do
      specify do
        expect(described_class::DEFAULTS['success_color']).to be == 'success'
      end
    end

    describe 'success_icon' do
      let(:expected) { 'circle-check' }

      it { expect(described_class::DEFAULTS['success_icon']).to be == expected }
    end

    describe 'warning_color' do
      specify do
        expect(described_class::DEFAULTS['warning_color']).to be == 'warning'
      end
    end

    describe 'warning_icon' do
      let(:expected) { 'exclamation-triangle' }

      it { expect(described_class::DEFAULTS['warning_icon']).to be == expected }
    end
  end

  describe '.default' do
    subject(:configuration) { described_class.default }

    include_examples 'should define class reader',
      :default,
      -> { an_instance_of(described_class) }

    it { expect(described_class.default).to be configuration }

    it { expect(configuration.options).to be == described_class::DEFAULTS }
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_any_keywords
    end
  end
end
