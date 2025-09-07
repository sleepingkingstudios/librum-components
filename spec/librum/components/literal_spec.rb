# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Literal, type: :component do
  subject(:component) { described_class.new(contents) }

  let(:contents) { '<h1>Greetings, Programs</h1>' }

  describe '.new' do
    it { expect(described_class).to be_constructible.with(1).argument }
  end

  describe '#call' do
    let(:rendered) { render_component(component) }

    it { expect(rendered.to_s).to be == contents }

    context 'when the contents contain unsafe HTML' do
      let(:contents) do
        <<~HTML
          <h1><script>alert("Greetings, programs!");</script>Greetings, Programs</h1>
        HTML
      end
      let(:sanitized) do
        <<~HTML
          <h1>alert("Greetings, programs!");Greetings, Programs</h1>
        HTML
      end

      it { expect(rendered.to_s).to be == sanitized }
    end
  end

  describe '#contents' do
    include_examples 'should define reader', :contents, -> { contents }
  end
end
