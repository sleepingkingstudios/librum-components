# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Views::Resources::New, type: :component do
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
          Create Book
        </h1>

        <div style="color: #f00;">
          Missing Component CreateForm
        </div>
      HTML
    end

    example_class 'Spec::Components::Heading', Librum::Components::Base \
    do |klass|
      klass.option :actions
      klass.option :level
      klass.option :text

      klass.define_method :call do
        content_tag("h#{level}") { text }
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

    describe 'with a resource with a create form component' do
      let(:resource_options) do
        super().merge(components: Spec::Books)
      end
      let(:snapshot) do
        <<~HTML
          <h1>
            Create Book
          </h1>

          <form>
            <input>
          </form>
        HTML
      end

      example_class 'Spec::Books::CreateForm', Librum::Components::Base \
      do |klass|
        klass.allow_extra_options
        klass.option :data

        klass.define_method(:call) do
          content_tag('form') { tag.input(value: data&.[]('title')) }
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with a result with non-empty data' do
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
              Create Book
            </h1>

            <form>
              <input value="Gideon the Ninth">
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with a resource with a form component' do
      let(:resource_options) do
        super().merge(components: Spec::Books)
      end
      let(:snapshot) do
        <<~HTML
          <h1>
            Create Book
          </h1>

          <form>
            <input>
          </form>
        HTML
      end

      example_class 'Spec::Books::Form', Librum::Components::Base do |klass|
        klass.allow_extra_options
        klass.option :data

        klass.define_method(:call) do
          content_tag('form') { tag.input(value: data&.[]('title')) }
        end
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with a result with non-empty data' do
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
              Create Book
            </h1>

            <form>
              <input value="Gideon the Ninth">
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end
end
