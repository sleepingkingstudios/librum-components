# frozen_string_literal: true

require 'librum/components/bulma/data_list'

RSpec.describe Librum::Components::Bulma::DataList,
  framework: :bulma,
  type:      :component \
do
  let(:component_options) { { data:, fields: } }
  let(:data)              { nil }
  let(:fields) do
    [
      { key: 'title' },
      { key: 'author', label: 'Author Name' },
      { key: 'published', type: :boolean }
    ]
      .map { |hsh| Librum::Components::DataField::Definition.normalize(hsh) }
  end

  include_deferred 'should be a view component',
    allow_extra_options: true

  include_deferred 'should define component option',
    :data,
    value: {}

  include_deferred 'should define component option',
    :fields,
    value: [Librum::Components::DataField::Definition.new(key: 'title')]

  describe '.new' do
    include_deferred 'should validate the presence of option',
      :fields,
      array: true
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <div class="fixed-grid has-0-cols has-4-cols-tablet has-6-cols-desktop">
          <div class="grid">
            <div class="cell has-text-weight-semibold">
              Title
            </div>

            <div class="cell is-col-span-3 is-col-span-5-desktop">
              &nbsp;
            </div>

            <div class="cell has-text-weight-semibold">
              Author Name
            </div>

            <div class="cell is-col-span-3 is-col-span-5-desktop">
              &nbsp;
            </div>

            <div class="cell has-text-weight-semibold">
              Published
            </div>

            <div class="cell is-col-span-3 is-col-span-5-desktop">
              False
            </div>
          </div>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <div class="fixed-grid has-0-cols has-4-cols-tablet has-6-cols-desktop custom-class">
            <div class="grid">
              <div class="cell has-text-weight-semibold">
                Title
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                &nbsp;
              </div>

              <div class="cell has-text-weight-semibold">
                Author Name
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                &nbsp;
              </div>

              <div class="cell has-text-weight-semibold">
                Published
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                False
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with data: value' do
      let(:data) do
        {
          'title'     => 'Gideon the Ninth',
          'author'    => 'Tamsyn Muir',
          'published' => true
        }
      end
      let(:snapshot) do
        <<~HTML
          <div class="fixed-grid has-0-cols has-4-cols-tablet has-6-cols-desktop">
            <div class="grid">
              <div class="cell has-text-weight-semibold">
                Title
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                Gideon the Ninth
              </div>

              <div class="cell has-text-weight-semibold">
                Author Name
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                Tamsyn Muir
              </div>

              <div class="cell has-text-weight-semibold">
                Published
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                True
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with multiple options' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:data) do
        {
          'title'     => 'Gideon the Ninth',
          'author'    => 'Tamsyn Muir',
          'published' => true
        }
      end
      let(:snapshot) do
        <<~HTML
          <div class="fixed-grid has-0-cols has-4-cols-tablet has-6-cols-desktop custom-class">
            <div class="grid">
              <div class="cell has-text-weight-semibold">
                Title
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                Gideon the Ninth
              </div>

              <div class="cell has-text-weight-semibold">
                Author Name
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                Tamsyn Muir
              </div>

              <div class="cell has-text-weight-semibold">
                Published
              </div>

              <div class="cell is-col-span-3 is-col-span-5-desktop">
                True
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
