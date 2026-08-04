# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Views::NotFoundView, type: :component do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  include_deferred 'should be a view'

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <h1>
          Not Found
        </h1>

        <p>
          This is not a place of honor.

          <br>

          No highly esteemed deed is commemorated here.

          <br>

          Nothing valued is here.
        </p>

        <p>
          What is here was dangerous and repulsive to us.

          <br>

          This message is a warning about danger.

          <br>

          The danger is still present, in your time, as it was in ours.
        </p>

        <p>
          This place is best shunned and left uninhabited.
        </p>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }
  end
end
