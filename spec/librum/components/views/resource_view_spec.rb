# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Views::ResourceView, type: :component do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  include_deferred 'should be a resource view'

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <h1>
          Publish Books
        </h1>
      HTML
    end

    example_class 'Spec::Components::Heading',
      Librum::Components::Base \
    do |klass|
      klass.option :actions
      klass.option :level
      klass.option :text

      klass.define_method :call do
        buffer = content_tag("h#{level}") { text }

        return buffer if actions.blank?

        actions.each do |action|
          tag_name = action[:button] ? 'button' : 'span'

          buffer << content_tag(tag_name) { action[:text] } << "\n"
        end

        buffer
      end
    end

    before(:example) do
      stub_provider(
        Librum::Components.provider,
        :components,
        Spec::Components
      )
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with content' do
      let(:component) do
        super().with_content('<p>Resource Content</p>'.html_safe)
      end
      let(:snapshot) do
        <<~HTML
          <h1>
            Publish Books
          </h1>

          <p>
            Resource Content
          </p>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'when initialized with a plural resource' do
      let(:described_class) { Spec::ExampleView }
      let(:resource) do
        Cuprum::Rails::Resource.new(name: 'books')
      end
      let(:snapshot) do
        <<~HTML
          <h1>
            Publish Books
          </h1>

          <span>
            There are 0 items.
          </span>
        HTML
      end

      example_class 'Spec::ExampleView', described_class do |klass|
        klass.define_method(:render_content) do
          content_tag('span') do
            "There are #{resource_data&.count || 0} items."
          end
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with a result with empty data' do
        let(:result) do
          Cuprum::Rails::Result.new(
            **super().properties,
            value: { 'books' => [] }
          )
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

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
              Publish Books
            </h1>

            <span>
              There are 4 items.
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    context 'when initialized with a singular resource' do
      let(:described_class) { Spec::ExampleView }
      let(:resource) do
        Cuprum::Rails::Resource.new(name: 'books', singular: true)
      end
      let(:snapshot) do
        <<~HTML
          <h1>
            Publish Book
          </h1>

          <span>
            There is not an item.
          </span>
        HTML
      end

      example_class 'Spec::ExampleView', described_class do |klass|
        klass.define_method(:render_content) do
          content_tag('span') do
            "There #{resource_data.present? ? 'is' : 'is not'} an item."
          end
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with a result with data' do
        let(:data) do
          {
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
              Publish Book
            </h1>

            <span>
              There is an item.
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    context 'when initialized with member_action: true' do
      let(:described_class) { Spec::ExampleView }
      let(:result) do
        Cuprum::Rails::Result.new(
          **super().properties,
          metadata: super().metadata.merge('member_action' => true)
        )
      end
      let(:snapshot) do
        <<~HTML
          <h1>
            Publish Book
          </h1>

          <span>
            There is not an item.
          </span>
        HTML
      end

      example_class 'Spec::ExampleView', described_class do |klass|
        klass.define_method(:render_content) do
          content_tag('span') do
            "There #{resource_data.present? ? 'is' : 'is not'} an item."
          end
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with a result with data' do
        let(:data) do
          {
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
              Publish Book
            </h1>

            <span>
              There is an item.
            </span>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    context 'with a view that defines actions' do
      let(:described_class) { Spec::ExampleView }
      let(:snapshot) do
        <<~HTML
          <h1>
            Publish Books
          </h1>

          <span>
            Cancel
          </span>

          <button>
            Confirm
          </button>
        HTML
      end

      example_class 'Spec::ExampleView', described_class do |klass|
        klass.define_method(:heading_actions) do
          [
            { text: 'Cancel' },
            { text: 'Confirm', button: true }
          ]
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    context 'with a view that defines after_content' do
      let(:described_class) { Spec::ExampleView }
      let(:snapshot) do
        <<~HTML
          <h1>
            Publish Books
          </h1>

          <p>
            After Content
          </p>
        HTML
      end

      example_class 'Spec::ExampleView', described_class do |klass|
        klass.define_method(:render_after_content) do
          content_tag('p') { 'After Content' }
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with content' do
        let(:component) do
          super().with_content('<p>Resource Content</p>'.html_safe)
        end
        let(:snapshot) do
          <<~HTML
            <h1>
              Publish Books
            </h1>

            <p>
              Resource Content
            </p>

            <p>
              After Content
            </p>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    context 'with a view that defines before_content' do
      let(:described_class) { Spec::ExampleView }
      let(:snapshot) do
        <<~HTML
          <h1>
            Publish Books
          </h1>

          <p>
            Before Content
          </p>
        HTML
      end

      example_class 'Spec::ExampleView', described_class do |klass|
        klass.define_method(:render_before_content) do
          content_tag('p') { 'Before Content' }
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with content' do
        let(:component) do
          super().with_content('<p>Resource Content</p>'.html_safe)
        end
        let(:snapshot) do
          <<~HTML
            <h1>
              Publish Books
            </h1>

            <p>
              Before Content
            </p>

            <p>
              Resource Content
            </p>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    context 'with a view that defines before_ and after_content' do
      let(:described_class) { Spec::ExampleView }
      let(:snapshot) do
        <<~HTML
          <h1>
            Publish Books
          </h1>

          <p>
            Before Content
          </p>

          <p>
            After Content
          </p>
        HTML
      end

      example_class 'Spec::ExampleView', described_class do |klass|
        klass.define_method(:render_after_content) do
          content_tag('p') { 'After Content' }
        end

        klass.define_method(:render_before_content) do
          content_tag('p') { 'Before Content' }
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with content' do
        let(:component) do
          super().with_content('<p>Resource Content</p>'.html_safe)
        end
        let(:snapshot) do
          <<~HTML
            <h1>
              Publish Books
            </h1>

            <p>
              Before Content
            </p>

            <p>
              Resource Content
            </p>

            <p>
              After Content
            </p>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end
end
