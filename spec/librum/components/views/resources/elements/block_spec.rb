# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Views::Resources::Elements::Block,
  type: :component \
do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  deferred_context 'with a component subclass' do
    let(:described_class) { Spec::Component }

    example_class 'Spec::Component',
      Librum::Components::Views::Resources::Elements::Block # rubocop:disable RSpec/DescribedClass
  end

  include_deferred 'should be a view', allow_extra_options: true

  include_deferred 'should define component option', :data

  describe '#call' do
    let(:fields) do
      [
        { key: 'title' },
        { key: 'author', label: 'Author Name' },
        { key: 'published', type: :boolean }
      ]
    end

    before(:example) { Spec::Component.const_set(:FIELDS, fields) }

    include_deferred 'with a component subclass'

    include_deferred 'should render a missing component', 'DataList'

    context 'when the DataList component is defined' do
      let(:snapshot) do
        <<~HTML
          <ul>
            <li>
              Title:
            </li>

            <li>
              Author:
            </li>

            <li>
              Published:
            </li>
          </ul>
        HTML
      end

      before(:example) do
        stub_provider(
          Librum::Components.provider,
          :components,
          Spec::Components
        )
      end

      example_class 'Spec::Components::DataList', Librum::Components::Base \
      do |klass|
        klass.allow_extra_options

        klass.option :data
        klass.option :fields

        klass.define_method :call do
          content_tag('ul') do
            fields.reduce(ActiveSupport::SafeBuffer.new) do |buffer, field|
              buffer << content_tag('li') do
                "#{field[:key].titleize}: #{data&.[](field[:key])}"
              end
            end
          end
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with data: value' do
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
            <ul>
              <li>
                Title: Gideon the Ninth
              </li>

              <li>
                Author: Tamsyn Muir
              </li>

              <li>
                Published: true
              </li>
            </ul>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#fields' do
    let(:error_message) do
      "#{described_class.name} is an abstract class - implement a subclass " \
        'and define a #fields method'
    end

    include_examples 'should define private reader', :fields

    it 'should raise an exception' do
      expect { component.send :fields }.to raise_error error_message
    end

    wrap_deferred 'with a component subclass' do
      it 'should raise an exception' do
        expect { component.send :fields }.to raise_error error_message
      end

      context 'when the subclass defines :FIELDS' do
        let(:fields) do
          [
            { key: 'title' },
            { key: 'author', label: 'Author Name' },
            { key: 'published', type: :boolean }
          ]
        end

        before(:example) { Spec::Component.const_set(:FIELDS, fields) }

        it { expect(component.send(:fields)).to be == fields }

        context 'when the fieldset is a block' do
          let(:fields) do
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

          it { expect(component.send(:fields)).to be == expected }
        end
      end
    end
  end
end
