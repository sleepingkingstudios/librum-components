# frozen_string_literal: true

require 'librum/components/sanitize'

RSpec.describe Librum::Components::Sanitize do
  subject(:component) { Object.new.extend(described_class) }

  describe '#sanitize' do
    it { expect(component).to respond_to(:sanitize).with(1).argument }

    describe 'with nil' do
      it { expect(component.sanitize(nil)).to be nil }
    end

    describe 'with an empty String' do
      it { expect(component.sanitize('')).to be == '' }
    end

    describe 'with a non-empty String' do
      let(:raw_string) { 'Greetings, Programs!' }
      let(:expected)   { 'Greetings, Programs!' }

      it { expect(component.sanitize(raw_string)).to be == expected }
    end

    describe 'with a safe HTML String' do
      let(:raw_string) { '<h1>Greetings, Programs!</h1>' }
      let(:expected)   { '<h1>Greetings, Programs!</h1>' }

      it { expect(component.sanitize(raw_string)).to be == expected }
    end

    describe 'with an unsafe HTML String' do
      let(:raw_string) { '<nope>Greetings, Programs!</nope>' }
      let(:expected)   { 'Greetings, Programs!' }

      it { expect(component.sanitize(raw_string)).to be == expected }
    end

    describe 'with an HTML String containing a hidden form' do
      let(:raw_string) do
        <<~HTML.strip
          Greetings, Programs!<form></form>
        HTML
      end
      let(:expected) { 'Greetings, Programs!' }

      it { expect(component.sanitize(raw_string)).to be == expected }
    end
  end

  describe '#strip_tags' do
    it { expect(component).to respond_to(:strip_tags).with(1).argument }

    describe 'with nil' do
      it { expect(component.strip_tags(nil)).to be nil }
    end

    describe 'with an empty String' do
      it { expect(component.strip_tags('')).to be == '' }
    end

    describe 'with a non-empty String' do
      let(:raw_string) { 'Greetings, Programs!' }
      let(:expected)   { 'Greetings, Programs!' }

      it { expect(component.strip_tags(raw_string)).to be == expected }
    end

    describe 'with a safe HTML String' do
      let(:raw_string) { '<h1>Greetings, Programs!</h1>' }
      let(:expected)   { 'Greetings, Programs!' }

      it { expect(component.strip_tags(raw_string)).to be == expected }
    end

    describe 'with an unsafe HTML String' do
      let(:raw_string) { '<nope>Greetings, Programs!</nope>' }
      let(:expected)   { 'Greetings, Programs!' }

      it { expect(component.strip_tags(raw_string)).to be == expected }
    end
  end
end
