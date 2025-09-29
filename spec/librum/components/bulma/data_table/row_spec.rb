# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::DataTable::Row,
  framework: :bulma,
  type:      :component \
do
  let(:component_options) { { columns: } }
  let(:columns) do
    [
      { key: 'title' },
      { key: 'author', label: 'Author Name' },
      { key: 'published', type: :boolean },
      {
        key:   'actions',
        align: 'right',
        label: '',
        value: Librum::Components::Literal.new('<span>Actions</span>')
      }
    ]
      .map { |hsh| Librum::Components::DataField::Definition.normalize(hsh) }
  end

  include_deferred 'should be a view component',
    allow_extra_options: true

  include_deferred 'should define component option', :class_name

  include_deferred 'should define component option',
    :columns,
    value: [{ key: 'title' }]

  include_deferred 'should define component option', :data

  describe '.new' do
    include_deferred 'should validate the class_name option'

    include_deferred 'should validate the presence of option',
      :columns,
      array: true
  end

  describe '#call' do
    # Wrap contents in a table to ensure HTML fragment is valid.
    let(:rendered) { "<table>#{super()}</table>" }
    let(:snapshot) do
      <<~HTML
        <table>
          <tbody>
            <tr>
              <td>
                &nbsp;
              </td>

              <td>
                &nbsp;
              </td>

              <td>
                False
              </td>

              <td class="has-text-right">
                <span>
                  Actions
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody>
              <tr class="custom-class">
                <td>
                  &nbsp;
                </td>

                <td>
                  &nbsp;
                </td>

                <td>
                  False
                </td>

                <td class="has-text-right">
                  <span>
                    Actions
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with data: a Hash with values' do
      let(:data) do
        {
          'title'     => 'Gideon the Ninth',
          'author'    => 'Tamsyn Muir',
          'published' => true
        }
      end
      let(:component_options) { super().merge(data:) }
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody>
              <tr>
                <td>
                  Gideon the Ninth
                </td>

                <td>
                  Tamsyn Muir
                </td>

                <td>
                  True
                </td>

                <td class="has-text-right">
                  <span>
                    Actions
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with data: a Struct with values' do
      let(:data) do
        Struct.new(:title, :author, :published).new(
          'title'     => 'Gideon the Ninth',
          'author'    => 'Tamsyn Muir',
          'published' => true
        )
      end
      let(:component_options) { super().merge(data:) }
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody>
              <tr>
                <td>
                  Gideon the Ninth
                </td>

                <td>
                  Tamsyn Muir
                </td>

                <td>
                  True
                </td>

                <td class="has-text-right">
                  <span>
                    Actions
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
