# frozen_string_literal: true

require 'cuprum/rails'

require 'librum/components'

RSpec.describe Librum::Components::Views::Resources::Elements::Table,
  type: :component \
do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  deferred_context 'with a component subclass' do
    let(:described_class) { Spec::Component }

    example_class 'Spec::Component',
      Librum::Components::Views::Resources::Elements::Table # rubocop:disable RSpec/DescribedClass
  end

  let(:component_options) { { routes: } }
  let(:resource) do
    Cuprum::Rails::Resource.new(name: 'books')
  end
  let(:routes) do
    Cuprum::Rails::Routing::PluralRoutes
      .new(base_path: '/books')
      .with_wildcards('id' => 'example-book')
  end

  include_deferred 'should be a view',
    allow_extra_options: true,
    require_resource:    true

  include_deferred 'should define component option',
    :data,
    value: []

  include_deferred 'should define component option',
    :routes,
    value: Cuprum::Rails::Routes.new(base_path: 'tomes')

  describe '.new' do
    define_method :validate_options do
      described_class.new(**required_keywords, **component_options)
    end

    include_deferred 'should validate the type of option',
      :data,
      allow_nil: true,
      expected:  Array

    include_deferred 'should validate the type of option',
      :routes,
      allow_nil: true,
      expected:  Cuprum::Rails::Routes
  end

  describe '#call' do
    let(:columns) do
      [
        { key: 'title' },
        { key: 'author', label: 'Author Name' },
        { key: 'published', type: :boolean }
      ]
    end

    before(:example) { Spec::Component.const_set(:COLUMNS, columns) }

    include_deferred 'with a component subclass'

    include_deferred 'should render a missing component', 'DataTable'

    context 'when the DataTable component is defined' do
      let(:snapshot) do
        <<~HTML
          <table>
            <tbody>
              <tr>
                <th>
                  title
                </th>

                <th>
                  author
                </th>

                <th>
                  published
                </th>
              </tr>
            </tbody>
          </table>
        HTML
      end

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          Spec::Components
        )
      end

      example_class 'Spec::Components::DataTable', Librum::Components::Base \
      do |klass|
        klass.allow_extra_options

        klass.option :columns
        klass.option :data

        klass.define_method :call do # rubocop:disable Metrics/MethodLength
          content_tag('table') do
            table = ActiveSupport::SafeBuffer.new

            table << content_tag('tr') do
              columns.reduce(ActiveSupport::SafeBuffer.new) do |cells, column|
                cells << content_tag('th') { column[:key] }
              end
            end

            table << data&.reduce(ActiveSupport::SafeBuffer.new) do |rows, item|
              rows << content_tag('tr') do
                columns.reduce(ActiveSupport::SafeBuffer.new) do |cells, column|
                  cells << content_tag('td') { item&.[](column[:key]).to_s }
                end
              end
            end

            table
          end
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with data: value' do
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
        let(:component_options) { super().merge(data:) }
        let(:snapshot) do
          <<~HTML
            <table>
              <tbody>
                <tr>
                  <th>
                    title
                  </th>

                  <th>
                    author
                  </th>

                  <th>
                    published
                  </th>
                </tr>

                <tr>
                  <td>
                    Gideon the Ninth
                  </td>

                  <td>
                    Tamsyn Muir
                  </td>

                  <td>
                    true
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
                    true
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
                    true
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
                    false
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

  describe '#columns' do
    let(:error_message) do
      "#{described_class.name} is an abstract class - implement a subclass " \
        'and define a #columns method'
    end

    include_examples 'should define private reader', :columns

    it 'should raise an exception' do
      expect { component.send :columns }.to raise_error error_message
    end

    wrap_deferred 'with a component subclass' do
      it 'should raise an exception' do
        expect { component.send :columns }.to raise_error error_message
      end

      context 'when the subclass defines :COLUMNS' do
        let(:columns) do
          [
            { key: 'title' },
            { key: 'author', label: 'Author Name' },
            { key: 'published', type: :boolean }
          ]
        end

        before(:example) { Spec::Component.const_set(:COLUMNS, columns) }

        it { expect(component.send(:columns)).to be == columns }

        context 'when the column definitions are a block' do
          let(:columns) do
            lambda do
              [
                { key: 'title' },
                { key: 'author', label: 'Author Name' },
                { key: 'published', type: :boolean },
                { key: 'secret', value: secret_key }
              ]
            end
          end
          let(:expected) do
            [
              { key: 'title' },
              { key: 'author', label: 'Author Name' },
              { key: 'published', type: :boolean },
              { key: 'secret', value: '12345' }
            ]
          end

          before(:example) do
            Spec::Component.define_method(:secret_key) { '12345' }
          end

          it { expect(component.send(:columns)).to be == expected }
        end
      end
    end
  end
end
