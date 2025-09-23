# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Views::Resources::Index, type: :component do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  let(:resource_options) { {} }
  let(:resource) do
    Librum::Components::Resource.new(name: 'books', **resource_options)
  end

  include_deferred 'should be a resource view'

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <h1>
          Books
        </h1>

        <button type="link" url="/books/new">
          [plus] Create Book
        </button>

        <div style="color: #f00;">
          Missing Component Table
        </div>
      HTML
    end

    include_deferred 'with component stubs for a resource view'

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a resource without a new action' do
      let(:actions)          { %w[index edit destroy] }
      let(:resource_options) { super().merge(actions:) }
      let(:snapshot) do
        <<~HTML
          <h1>
            Books
          </h1>

          <div style="color: #f00;">
            Missing Component Table
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a resource with a table component' do
      let(:resource_options) do
        super().merge(components: Spec::Books)
      end
      let(:snapshot) do
        <<~HTML
          <h1>
            Books
          </h1>

          <button type="link" url="/books/new">
            [plus] Create Book
          </button>

          <div>
            There are 0 books.
          </div>
        HTML
      end

      example_class 'Spec::Books::Table', Librum::Components::Base do |klass|
        klass.allow_extra_options
        klass.option :data

        klass.define_method(:call) do
          content_tag('div') { "There are #{data&.count || 0} books." }
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with a result with non-empty data' do
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
        let(:result) do
          Cuprum::Rails::Result.new(
            **super().properties,
            value: { 'books' => data }
          )
        end
        let(:snapshot) do
          <<~HTML
            <h1>
              Books
            </h1>

            <button type="link" url="/books/new">
              [plus] Create Book
            </button>

            <div>
              There are 4 books.
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end
end
