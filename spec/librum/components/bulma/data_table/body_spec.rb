# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::DataTable::Body,
  framework: :bulma,
  type:      :component \
do
  let(:component_options) { { columns:, data: } }
  let(:data)              { [] }
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

  include_deferred 'should define component option',
    :data,
    value: []

  include_deferred 'should define component option',
    :empty_message,
    default: 'There are no items matching the criteria.',
    value:   'This is not a place of honor.'

  include_deferred 'should define component option', :row_class_name

  include_deferred 'should define component option',
    :row_component,
    default: Librum::Components::Bulma::DataTable::Row,
    value:   Class.new(ViewComponent::Base)

  describe '.new' do
    include_deferred 'should validate the class_name option'

    include_deferred 'should validate the presence of option',
      :columns,
      array: true

    include_deferred 'should validate the type of option',
      :data,
      expected: Array

    include_deferred 'should validate the type of option',
      :row_class_name,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate the type of option',
      :row_component,
      allow_nil: true,
      expected:  Class

    describe 'with empty_message: an Object' do
      let(:component_options) do
        super().merge(empty_message: Object.new.freeze)
      end
      let(:error_message) do
        failure_message = 'empty_message is not a String or a component'

        "invalid options for #{described_class.name} - #{failure_message}"
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end
  end

  describe '#call' do
    # Wrap contents in a table to ensure HTML fragment is valid.
    let(:rendered) { "<table>#{super()}</table>" }
    let(:snapshot) do
      <<~HTML
        <table>
          <tbody>
            <tr>
              <td colspan="4">
                There are no items matching the criteria.
              </td>
            </tr>
          </tbody>
        </table>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-body') }
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody class="custom-body">
              <tr>
                <td colspan="4">
                  There are no items matching the criteria.
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with data: a non-empty Array' do
        let(:data) do
          [
            {
              'title'     => 'Gideon the Ninth',
              'author'    => 'Tamsyn Muir',
              'published' => true
            }
          ]
        end
        let(:snapshot) do
          <<~HTML
            <table>
              <tbody class="custom-body">
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

    describe 'with data: a non-empty Array' do
      let(:data) do
        [
          {
            'title'     => 'Gideon the Ninth',
            'author'    => 'Tamsyn Muir',
            'published' => true
          },
          {
            'title'     => 'Harrow the Ninth',
            'author'    => 'Tamsyn Muir',
            'published' => true
          },
          {
            'title'     => 'Nona the Ninth',
            'author'    => 'Tamsyn Muir',
            'published' => true
          },
          {
            'title'     => 'Alecto the Ninth',
            'author'    => 'Tamsyn Muir',
            'published' => false
          }
        ]
      end
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

              <tr>
                <td>
                  Harrow the Ninth
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

              <tr>
                <td>
                  Nona the Ninth
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

              <tr>
                <td>
                  Alecto the Ninth
                </td>

                <td>
                  Tamsyn Muir
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

    describe 'with empty_message: a String' do
      let(:empty_message)     { 'This is not a place of honor.' }
      let(:component_options) { super().merge(empty_message:) }
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody>
              <tr>
                <td colspan="4">
                  This is not a place of honor.
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with empty_message: an HTML string' do
      let(:empty_message) do
        '<span class="has-text-danger">This is not a place of honor.</span>'
      end
      let(:component_options) { super().merge(empty_message:) }
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody>
              <tr>
                <td colspan="4">
                  This is not a place of honor.
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with empty_message: a safe HTML string' do
      let(:empty_message) do
        '<span class="has-text-danger">This is not a place of honor.</span>'
          .html_safe
      end
      let(:component_options) { super().merge(empty_message:) }
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody>
              <tr>
                <td colspan="4">
                  <span class="has-text-danger">
                    This is not a place of honor.
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with empty_message: a component' do
      let(:empty_message) do
        Librum::Components::Literal.new(
          '<span class="has-text-danger">This is not a place of honor.</span>'
        )
      end
      let(:component_options) { super().merge(empty_message:) }
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody>
              <tr>
                <td colspan="4">
                  <span class="has-text-danger">
                    This is not a place of honor.
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with row_class_name: value' do
      let(:component_options) { super().merge(row_class_name: 'custom-row') }
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody>
              <tr>
                <td colspan="4">
                  There are no items matching the criteria.
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with data: a non-empty Array' do
        let(:data) do
          [
            {
              'title'     => 'Gideon the Ninth',
              'author'    => 'Tamsyn Muir',
              'published' => true
            }
          ]
        end
        let(:snapshot) do
          <<~HTML
            <table>
              <tbody>
                <tr class="custom-row">
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

    describe 'with row_component: value' do
      let(:component_options) do
        super().merge(row_component: Spec::RowComponent)
      end

      example_class 'Spec::RowComponent', Librum::Components::Base do |klass|
        klass.allow_extra_options

        klass.option :columns

        klass.option :data

        klass.define_method(:call) do
          content_tag('tr') do
            content_tag('td', colspan: columns.size) do
              "Title: #{data&.[]('title')}"
            end
          end
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with data: a non-empty Array' do
        let(:data) do
          [
            {
              'title'     => 'Gideon the Ninth',
              'author'    => 'Tamsyn Muir',
              'published' => true
            },
            {
              'title'     => 'Harrow the Ninth',
              'author'    => 'Tamsyn Muir',
              'published' => true
            },
            {
              'title'     => 'Nona the Ninth',
              'author'    => 'Tamsyn Muir',
              'published' => true
            },
            {
              'title'     => 'Alecto the Ninth',
              'author'    => 'Tamsyn Muir',
              'published' => false
            }
          ]
        end
        let(:snapshot) do
          <<~HTML
            <table>
              <tbody>
                <tr>
                  <td colspan="4">
                    Title: Gideon the Ninth
                  </td>
                </tr>

                <tr>
                  <td colspan="4">
                    Title: Harrow the Ninth
                  </td>
                </tr>

                <tr>
                  <td colspan="4">
                    Title: Nona the Ninth
                  </td>
                </tr>

                <tr>
                  <td colspan="4">
                    Title: Alecto the Ninth
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
end
