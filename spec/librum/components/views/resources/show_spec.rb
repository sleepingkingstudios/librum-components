# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Views::Resources::Show, type: :component do
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
          Show Book
        </h1>

        <div style="color: #f00;">
          Missing Component Block
        </div>
      HTML
    end

    include_deferred 'with component stubs for a resource view'

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a resource with a block component' do
      let(:resource_options) do
        super().merge(components: Spec::Books)
      end
      let(:snapshot) do
        <<~HTML
          <h1>
            Show Book
          </h1>

          <p>
            Title: (none)
          </p>
        HTML
      end

      example_class 'Spec::Books::Block', Librum::Components::Base do |klass|
        klass.allow_extra_options
        klass.option :data

        klass.define_method(:call) do
          content_tag('p') { "Title: #{data&.[]('title') || '(none)'}" }
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with a result with non-empty data' do
        let(:confirm_message) do
          'This will permanently delete book 0.\n\nConfirm deletion?'
        end
        let(:data) do
          {
            'id'        => 0,
            'slug'      => 'gideon-the-ninth',
            'title'     => 'Gideon the Ninth',
            'author'    => 'Tamsyn Muir',
            'published' => true
          }
        end
        let(:result) do
          Cuprum::Rails::Result.new(
            **super().properties,
            value: { 'book' => data }
          )
        end
        let(:snapshot) do
          <<~HTML
            <h1>
              Show Book
            </h1>

            <button type="link" url="/books/gideon-the-ninth/edit">
              [pencil] Update Book
            </button>

            <button type="form" url="/books/gideon-the-ninth" data-confirm="#{confirm_message}">
              Destroy Book
            </button>

            <p>
              Title: Gideon the Ninth
            </p>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }

        describe 'with a resource without a destroy action' do
          let(:actions)          { %w[index new edit] }
          let(:resource_options) { super().merge(actions:) }
          let(:snapshot) do
            <<~HTML
              <h1>
                Show Book
              </h1>

              <button type="link" url="/books/gideon-the-ninth/edit">
                [pencil] Update Book
              </button>

              <p>
                Title: Gideon the Ninth
              </p>
            HTML
          end

          it { expect(rendered).to match_snapshot(snapshot) }
        end

        describe 'with a resource without an edit action' do
          let(:actions)          { %w[index new destroy] }
          let(:resource_options) { super().merge(actions:) }
          let(:snapshot) do
            <<~HTML
              <h1>
                Show Book
              </h1>

              <button type="form" url="/books/gideon-the-ninth" data-confirm="#{confirm_message}">
                Destroy Book
              </button>

              <p>
                Title: Gideon the Ninth
              </p>
            HTML
          end

          it { expect(rendered).to match_snapshot(snapshot) }
        end
      end
    end

    describe 'with a resource with a title attribute' do
      let(:resource_options) { super().merge(title_attribute: 'title') }

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with a result with non-empty data' do
        let(:confirm_message) do
          'This will permanently delete book Gideon the Ninth.\n\n' \
            'Confirm deletion?'
        end
        let(:data) do
          {
            'id'        => 0,
            'slug'      => 'gideon-the-ninth',
            'title'     => 'Gideon the Ninth',
            'author'    => 'Tamsyn Muir',
            'published' => true
          }
        end
        let(:result) do
          Cuprum::Rails::Result.new(
            **super().properties,
            value: { 'book' => data }
          )
        end
        let(:snapshot) do
          <<~HTML
            <h1>
              Gideon the Ninth
            </h1>

            <button type="link" url="/books/gideon-the-ninth/edit">
              [pencil] Update Book
            </button>

            <button type="form" url="/books/gideon-the-ninth" data-confirm="#{confirm_message}">
              Destroy Book
            </button>

            <div style="color: #f00;">
              Missing Component Block
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end
end
