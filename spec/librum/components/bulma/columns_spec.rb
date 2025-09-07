# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Columns,
  framework: :bulma,
  type:      :component \
do
  let(:component_options) { { columns: } }
  let(:columns) do
    [
      Librum::Components::Literal.new('<div>Column 1</div>'),
      Librum::Components::Literal.new('<div>Column 2</div>'),
      Librum::Components::Literal.new('<div>Column 3</div>')
    ]
  end

  include_deferred 'should define component option',
    :columns,
    value: [Librum::Components::Literal.new('<div>Column</div>')]

  describe '.new' do
    include_deferred 'should validate the presence of option',
      :columns,
      array: true

    include_deferred 'should validate that option is a valid array',
      :columns
  end

  describe '#call' do
    let(:rendered) { render_component(component) }
    let(:snapshot) do
      <<~HTML
        <div class="columns">
          <div class="column">
            <div>Column 1</div>
          </div>

          <div class="column">
            <div>Column 2</div>
          </div>

          <div class="column">
            <div>Column 3</div>
          </div>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    context 'with configuration: { bulma_prefix: value }' do
      let(:snapshot) do
        <<~HTML
          <div class="bulma-columns">
            <div class="bulma-column">
              <div>Column 1</div>
            </div>

            <div class="bulma-column">
              <div>Column 2</div>
            </div>

            <div class="bulma-column">
              <div>Column 3</div>
            </div>
          </div>
        HTML
      end

      include_deferred 'with configuration', bulma_prefix: 'bulma-'

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
