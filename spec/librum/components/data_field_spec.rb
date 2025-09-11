# frozen_string_literal: true

require 'cuprum/rails'

require 'librum/components/data_field'

RSpec.describe Librum::Components::DataField, type: :component do
  let(:component_options) { { data:, field: } }
  let(:data) do
    {
      'title'  => 'Gideon the Ninth',
      'author' => 'Tammsyn Muir'
    }
  end
  let(:field) { { key: 'title' } }

  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  describe '::Definition' do
    subject(:definition) { described_class::Definition.new(**properties) }

    let(:properties) { { key: } }
    let(:key)        { 'title' }

    describe '#key' do
      include_examples 'should define reader', :key, -> { key }
    end

    describe '#transform' do
      include_examples 'should define reader', :transform, nil

      context 'when initialized with type: value' do
        let(:properties) { super().merge(transform: 'titleize') }

        it { expect(definition.transform).to be == 'titleize' }
      end
    end

    describe '#truncate' do
      include_examples 'should define reader', :truncate, nil

      context 'when initialized with type: value' do
        let(:properties) { super().merge(truncate: 80) }

        it { expect(definition.truncate).to be 80 }
      end
    end

    describe '#type' do
      include_examples 'should define reader', :type, :text

      context 'when initialized with type: value' do
        let(:properties) { super().merge(type: 'custom') }

        it { expect(definition.type).to be == 'custom' }
      end
    end
  end

  include_deferred 'should define component option',
    :data,
    value: { 'summary' => 'value' }

  describe '.new' do
    include_deferred 'should validate the presence of option', :data

    describe 'with field: nil' do
      let(:component_options) { super().merge(field: nil) }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'field'
        )
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with field: an Object' do
      let(:component_options) { super().merge(field: Object.new.freeze) }
      let(:error_message) do
        'field is not a Hash or Definition'
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with field: an empty Hash' do
      let(:component_options) { super().merge(field: {}) }
      let(:error_message) do
        tools.assertions.error_message_for(
          'sleeping_king_studios.tools.assertions.presence',
          as: 'field'
        )
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with field: a Hash with missing keys' do
      let(:component_options) { super().merge(field: { type: :text }) }
      let(:error_message) do
        'field is missing required property :key'
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with field: a Hash with extra keys' do
      let(:component_options) do
        super().merge(
          field: { key: 'title', invalid: 'invalid', other: 'other' }
        )
      end
      let(:error_message) do
        'field has unknown properties :invalid, :other'
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end
  end

  describe '#call' do
    it { expect(rendered).to be == data[component.field.key] }

    describe 'with value: an HTML string' do
      let(:value)    { '<h1>Greetings, Programs!</h1>' }
      let(:data)     { super().merge('title' => value) }
      let(:expected) { 'Greetings, Programs!' }

      it { expect(rendered).to be == expected }
    end

    describe 'with value: a safe HTML string' do
      let(:value) { '<h1>Greetings, Programs!</h1>'.html_safe }
      let(:data)  { super().merge('title' => value) }

      it { expect(rendered).to be == data[component.field.key] }
    end

    context 'with field: { transform: a Proc }' do
      let(:transform) { ->(str) { str + str } }
      let(:field)     { super().merge(transform:) }
      let(:expected)  { data[component.field.key] + data[component.field.key] }

      it { expect(rendered).to be == expected }
    end

    context 'with field: { transform: a String }' do
      let(:field)    { super().merge(transform: 'upcase') }
      let(:expected) { data[component.field.key].upcase }

      it { expect(rendered).to be == expected }
    end

    context 'with field: { transform: a Symbol }' do
      let(:field)    { super().merge(transform: :upcase) }
      let(:expected) { data[component.field.key].upcase }

      it { expect(rendered).to be == expected }
    end

    context 'with field: { transform: an invalid value }' do
      let(:field) { super().merge(transform: Object.new.freeze) }

      it { expect(rendered).to be == data[component.field.key] }
    end

    context 'with field: { truncate: value }' do
      let(:field) { super().merge(truncate: 21) }

      it { expect(rendered).to be == data[component.field.key] }

      context 'when a raw value longer than the threshold' do
        let(:data) do
          {
            'title'  => "There and Back Again: A Hobbit's Tale",
            'author' => 'J.R.R. Tolkien'
          }
        end
        let(:expected) { 'There and Back Again…' }

        it { expect(rendered).to be == expected }
      end
    end

    context 'with field: { type: :actions }' do
      let(:resource) do
        Cuprum::Rails::Resource.new(name: 'books')
      end
      let(:routes) do
        Cuprum::Rails::Routing::PluralRoutes.new(base_path: '/books')
      end
      let(:field) { super().merge(type: :actions) }
      let(:component_options) do
        super().merge(resource:, routes:)
      end
      let(:snapshot) do
        <<~HTML
          <span style="color: #f00;">Missing Component Resources::TableActions</span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      wrap_deferred 'with components' do
        let(:snapshot) do
          <<~HTML
            <a>Show</a>

            <a>Edit</a>

            <a>Destroy</a>
          HTML
        end

        example_class 'Spec::Resources::TableActions',
          Librum::Components::Base \
        do |klass|
          klass.option :data
          klass.option :routes
          klass.option :resource

          klass.define_method :call do
            <<~HTML.html_safe # rubocop:disable Rails/OutputSafety
              <a>Show</a>

              <a>Edit</a>

              <a>Destroy</a>
            HTML
          end
        end

        before(:example) do
          namespace = Librum::Components.provider.get('components')
          namespace.const_set(:Resources, Spec::Resources)
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    context 'with field: { type: :boolean }' do
      let(:field) { super().merge(key: 'published', type: :boolean) }

      it { expect(rendered).to be == 'False' }

      context 'when the value is false' do
        let(:data) { super().merge('published' => false) }

        it { expect(rendered).to be == 'False' }
      end

      context 'when the value is true' do
        let(:data) { super().merge('published' => true) }

        it { expect(rendered).to be == 'True' }
      end
    end

    context 'with field: { type: :text }' do
      let(:field) { super().merge(type: :text) }

      it { expect(rendered).to be == data[component.field.key] }
    end

    context 'with field: { type: unknown }' do
      let(:field) { super().merge(type: :invalid_type) }

      let(:snapshot) do
        <<~HTML
          <span style="color: #f00;">Unknown Type :invalid_type</span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      wrap_deferred 'with components' do
        let(:snapshot) do
          <<~HTML
            <span class="text-danger icon-bug">Unknown Type :invalid_type</span>
          HTML
        end

        example_class 'Spec::Label', Librum::Components::Base do |klass|
          klass.option :color
          klass.option :icon
          klass.option :text

          klass.define_method :call do
            <<~HTML.html_safe # rubocop:disable Rails/OutputSafety
              <span class="text-#{color} icon-#{icon}">#{text}</span>
            HTML
          end
        end

        before(:example) do
          namespace = Librum::Components.provider.get('components')
          namespace.const_set(:Label, Spec::Label)
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end
  end

  describe '#field' do
    include_examples 'should define reader', :field

    context 'when initialized with field: a Definition' do
      let(:field) { described_class::Definition.new(**super()) }

      it { expect(component.field).to be == field }
    end

    context 'when initialized with field: a Hash' do
      let(:expected) { described_class::Definition.new(**field) }

      it { expect(component.field).to be == expected }
    end
  end
end
