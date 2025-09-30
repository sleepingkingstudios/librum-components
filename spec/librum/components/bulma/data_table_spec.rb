# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::DataTable,
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

  include_deferred 'should define component option', :body_class_name

  include_deferred 'should define component option',
    :body_component,
    default: described_class::Body,
    value:   Class.new(ViewComponent::Base)

  include_deferred 'should define component option', :class_name

  include_deferred 'should define component option',
    :columns,
    value: [Librum::Components::DataField::Definition.new(key: 'title')]

  include_deferred 'should define component option',
    :data,
    value: []

  include_deferred 'should define component option',
    :empty_message,
    value: 'This is not a place of honor.'

  include_deferred 'should define component option', :footer_class_name

  include_deferred 'should define component option',
    :footer_component,
    value: Class.new(ViewComponent::Base)

  include_deferred 'should define component option',
    :full_width,
    boolean: true,
    default: true

  include_deferred 'should define component option', :header_class_name

  include_deferred 'should define component option',
    :header_component,
    default: described_class::Header,
    value:   Class.new(ViewComponent::Base)

  include_deferred 'should define component option', :row_class_name

  include_deferred 'should define component option',
    :row_component,
    default: described_class::Row,
    value:   Class.new(ViewComponent::Base)

  describe '.new' do
    include_deferred 'should validate the type of option',
      :body_class_name,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate the type of option',
      :body_component,
      allow_nil: true,
      expected:  Class

    include_deferred 'should validate the class_name option'

    include_deferred 'should validate the presence of option',
      :columns,
      array: true

    include_deferred 'should validate the type of option',
      :data,
      expected: Array

    include_deferred 'should validate the type of option',
      :footer_class_name,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate the type of option',
      :footer_component,
      allow_nil: true,
      expected:  Class

    include_deferred 'should validate the type of option',
      :header_class_name,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate the type of option',
      :header_component,
      allow_nil: true,
      expected:  Class

    include_deferred 'should validate the type of option',
      :row_class_name,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate the type of option',
      :row_component,
      allow_nil: true,
      expected:  Class
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <table class="table is-fullwidth">
          <thead>
            <tr>
              <th>
                Title
              </th>

              <th>
                Author Name
              </th>

              <th>
                Published
              </th>

              <th></th>
            </tr>
          </thead>

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

    describe 'with body_class_name: value' do
      let(:component_options) { super().merge(body_class_name: 'custom-body') }
      let(:snapshot) do
        <<~HTML
          <table class="table is-fullwidth">
            <thead>
              <tr>
                <th>
                  Title
                </th>

                <th>
                  Author Name
                </th>

                <th>
                  Published
                </th>

                <th></th>
              </tr>
            </thead>

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
    end

    describe 'with body_component: value' do
      let(:component_options) do
        super().merge(body_component: Spec::BodyComponent)
      end
      let(:snapshot) do
        <<~HTML
          <table class="table is-fullwidth">
            <thead>
              <tr>
                <th>
                  Title
                </th>

                <th>
                  Author Name
                </th>

                <th>
                  Published
                </th>

                <th></th>
              </tr>
            </thead>

            <tbody>
              <tr>
                <td colspan="4">
                  There are 0 items.
                </td>
              </tr>
            </tbody>
          </table>
        HTML
      end

      example_class 'Spec::BodyComponent', Librum::Components::Base do |klass|
        klass.allow_extra_options

        klass.option :columns

        klass.option :data

        klass.define_method(:call) do
          content_tag('tr') do
            content_tag('td', colspan: columns.size) do
              "There are #{data.count} items."
            end
          end
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-table') }
      let(:snapshot) do
        <<~HTML
          <table class="table is-fullwidth custom-table">
            <thead>
              <tr>
                <th>
                  Title
                </th>

                <th>
                  Author Name
                </th>

                <th>
                  Published
                </th>

                <th></th>
              </tr>
            </thead>

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
          <table class="table is-fullwidth">
            <thead>
              <tr>
                <th>
                  Title
                </th>

                <th>
                  Author Name
                </th>

                <th>
                  Published
                </th>

                <th></th>
              </tr>
            </thead>

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

    describe 'with empty_message: value' do
      let(:component_options) do
        super().merge(empty_message: 'This is not a place of honor.')
      end
      let(:snapshot) do
        <<~HTML
          <table class="table is-fullwidth">
            <thead>
              <tr>
                <th>
                  Title
                </th>

                <th>
                  Author Name
                </th>

                <th>
                  Published
                </th>

                <th></th>
              </tr>
            </thead>

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

    describe 'with footer_class_name: value' do
      let(:component_options) do
        super().merge(footer_class_name: 'custom-footer')
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with footer_component: value' do
      let(:component_options) do
        super().merge(footer_component: Spec::FooterComponent)
      end
      let(:snapshot) do
        <<~HTML
          <table class="table is-fullwidth">
            <thead>
              <tr>
                <th>
                  Title
                </th>

                <th>
                  Author Name
                </th>

                <th>
                  Published
                </th>

                <th></th>
              </tr>
            </thead>

            <tbody>
              <tr>
                <td colspan="4">
                  There are no items matching the criteria.
                </td>
              </tr>
            </tbody>

            <tfoot>
              <tr>
                <td colspan="4">
                  There are 0 items.
                </td>
              </tr>
            </tfoot>
          </table>
        HTML
      end

      example_class 'Spec::FooterComponent', Librum::Components::Base do |klass|
        klass.allow_extra_options

        klass.option :class_name

        klass.option :columns

        klass.option :data

        klass.define_method(:call) do
          content_tag('tfoot', class: class_name) do
            content_tag('tr') do
              content_tag('td', colspan: columns.size) do
                "There are #{data.count} items."
              end
            end
          end
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with footer_class_name: value' do
        let(:component_options) do
          super().merge(footer_class_name: 'custom-footer')
        end
        let(:snapshot) do
          <<~HTML
            <table class="table is-fullwidth">
              <thead>
                <tr>
                  <th>
                    Title
                  </th>

                  <th>
                    Author Name
                  </th>

                  <th>
                    Published
                  </th>

                  <th></th>
                </tr>
              </thead>

              <tbody>
                <tr>
                  <td colspan="4">
                    There are no items matching the criteria.
                  </td>
                </tr>
              </tbody>

              <tfoot class="custom-footer">
                <tr>
                  <td colspan="4">
                    There are 0 items.
                  </td>
                </tr>
              </tfoot>
            </table>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with header_class_name: value' do
      let(:component_options) do
        super().merge(header_class_name: 'custom-header')
      end
      let(:snapshot) do
        <<~HTML
          <table class="table is-fullwidth">
            <thead class="custom-header">
              <tr>
                <th>
                  Title
                </th>

                <th>
                  Author Name
                </th>

                <th>
                  Published
                </th>

                <th></th>
              </tr>
            </thead>

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
    end

    describe 'with header_component: value' do
      let(:component_options) do
        super().merge(header_component: Spec::HeaderComponent)
      end
      let(:snapshot) do
        <<~HTML
          <table class="table is-fullwidth">
            <tbody>
              <tr>
                <td colspan="4">
                  There are 0 items.
                </td>
              </tr>
            </tbody>

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

      example_class 'Spec::HeaderComponent', Librum::Components::Base do |klass|
        klass.allow_extra_options

        klass.option :columns

        klass.option :data

        klass.define_method(:call) do
          content_tag('tr') do
            content_tag('td', colspan: columns.size) do
              "There are #{data.count} items."
            end
          end
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with row_class_name: value' do
      let(:component_options) { super().merge(row_class_name: 'custom-row') }

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
            <table class="table is-fullwidth">
              <thead>
                <tr>
                  <th>
                    Title
                  </th>

                  <th>
                    Author Name
                  </th>

                  <th>
                    Published
                  </th>

                  <th></th>
                </tr>
              </thead>

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
            <table class="table is-fullwidth">
              <thead>
                <tr>
                  <th>
                    Title
                  </th>

                  <th>
                    Author Name
                  </th>

                  <th>
                    Published
                  </th>

                  <th></th>
                </tr>
              </thead>

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
