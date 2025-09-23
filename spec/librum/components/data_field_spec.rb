# frozen_string_literal: true

require 'cuprum/rails'

require 'librum/components/data_field'
require 'librum/components/rspec/deferred/data_examples'

RSpec.describe Librum::Components::DataField, type: :component do
  include Librum::Components::RSpec::Deferred::DataExamples

  let(:component_options) { { data:, field: } }
  let(:data) do
    {
      'title'  => 'Gideon the Ninth',
      'author' => 'Tamsyn Muir'
    }
  end
  let(:field) { { key: 'title' } }

  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  describe '::Definition' do
    subject(:definition) { described_class.new(**properties) }

    let(:described_class) { super()::Definition }
    let(:properties) { { key: } }
    let(:key)        { 'title' }

    describe '.normalize' do
      let(:normalized) { described_class.normalize(value) }
      let(:expected) do
        {
          **described_class.members.index_with { |_| nil },
          key:,
          label: key.to_s.titleize,
          type:  :text
        }
      end

      it { expect(described_class).to respond_to(:normalize).with(1).argument }

      describe 'with a Definition' do
        let(:value) { described_class.new(**properties) }

        it { expect(normalized).to be_a described_class }

        it { expect(normalized.to_h).to be == expected }
      end

      describe 'with a Hash' do
        let(:value) { properties }

        it { expect(normalized).to be_a described_class }

        it { expect(normalized.to_h).to be == expected }
      end
    end

    describe '.validate' do
      deferred_examples 'should return an invalid field result' do
        it { expect(validate_field).to match error_message }
      end

      deferred_examples 'should return a valid field result' do
        it { expect(validate_field).to be nil }
      end

      define_method :validate_field do
        described_class.validate(field)
      end

      it 'should define the class method' do
        expect(described_class)
          .to respond_to(:validate)
          .with(1).argument
          .and_keywords(:as)
      end

      include_deferred 'should validate the data field'

      describe 'with as: value' do
        let(:as) { 'column' }

        define_method :validate_field do
          described_class.validate(field, as:)
        end

        include_deferred 'should validate the data field'
      end
    end

    describe '.validate_list' do
      deferred_examples 'should return an invalid field result' do
        it { expect(validate_list).to match error_message }
      end

      deferred_examples 'should return a valid field result' do
        it { expect(validate_list).to be nil }
      end

      define_method :validate_list do
        described_class.validate_list(fields)
      end

      it 'should define the class method' do
        expect(described_class)
          .to respond_to(:validate_list)
          .with(1).argument
          .and_keywords(:as)
      end

      include_deferred 'should validate the data field list'

      describe 'with as: value' do
        let(:as) { 'columns' }

        define_method :validate_list do
          described_class.validate_list(fields, as:)
        end

        include_deferred 'should validate the data field list'
      end
    end

    describe '#key' do
      include_examples 'should define reader', :key, -> { key }
    end

    describe '#align' do
      include_examples 'should define reader', :align, nil

      context 'when initialized with align: value' do
        let(:properties) { super().merge(align: 'right') }

        it { expect(definition.align).to be == 'right' }
      end
    end

    describe '#label' do
      include_examples 'should define reader', :label, -> { key.to_s.titleize }

      context 'when initialized with label: value' do
        let(:properties) { super().merge(label: 'Description') }

        it { expect(definition.label).to be == 'Description' }
      end
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

    describe '#value' do
      include_examples 'should define reader', :value, nil

      context 'when initialized with value: value' do
        let(:properties) { super().merge(value: 'Static Value') }

        it { expect(definition.value).to be == 'Static Value' }
      end
    end
  end

  include_deferred 'should define component option',
    :data,
    value: { 'summary' => 'value' }

  describe '.new' do
    let(:properties) { { key: 'title' } }

    deferred_examples 'should return an invalid field result' do
      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    deferred_examples 'should return a valid field result' do
      it 'should not raise an exception' do
        expect { described_class.new(**component_options) }.not_to raise_error
      end
    end

    include_deferred 'should validate the data field', required: true

    include_deferred 'should validate the presence of option', :field
  end

  describe '#call' do
    it { expect(rendered).to be == data[component.field.key] }

    describe 'with data: nil' do
      let(:data)     { nil }
      let(:expected) { "\u00A0" }

      it { expect(rendered).to be == expected }
    end

    describe 'with data: an empty Hash' do
      let(:data)     { {} }
      let(:expected) { "\u00A0" }

      it { expect(rendered).to be == expected }
    end

    describe 'with value: nil' do
      let(:data)     { super().merge('title' => nil) }
      let(:expected) { "\u00A0" }

      it { expect(rendered).to be == expected }

      context 'with field: { transform: value }' do
        let(:field) { super().merge(transform: 'upcase') }

        it { expect(rendered).to be == expected }
      end
    end

    describe 'with value: false' do
      let(:data)     { super().merge('title' => false) }
      let(:expected) { 'false' }

      it { expect(rendered).to be == expected }
    end

    describe 'with value: true' do
      let(:data)     { super().merge('title' => true) }
      let(:expected) { 'true' }

      it { expect(rendered).to be == expected }
    end

    describe 'with value: an Object' do
      let(:value)    { Object.new.freeze }
      let(:data)     { super().merge('title' => value) }
      let(:expected) { value.to_s.tr('<>', '()') }

      it { expect(rendered).to be == expected }
    end

    describe 'with value: an Integer' do
      let(:data)     { super().merge('title' => 13) }
      let(:expected) { '13' }

      it { expect(rendered).to be == expected }
    end

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
          <span style="color: #f00;">
            Missing Component Resources::TableActions
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      wrap_deferred 'with components' do
        let(:snapshot) do
          <<~HTML
            <a>
              Show
            </a>

            <a>
              Edit
            </a>

            <a>
              Destroy
            </a>
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
          <span style="color: #f00;">
            Unknown Type :invalid_type
          </span>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      wrap_deferred 'with components' do
        let(:snapshot) do
          <<~HTML
            <span class="text-danger icon-bug">
              Unknown Type :invalid_type
            </span>
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

        include_deferred 'with configuration', danger_color: 'danger'

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    context 'with field: { value: a String }' do
      let(:field) { super().merge(value: 'Static Value') }

      it { expect(rendered).to be == 'Static Value' }
    end

    context 'with field: { value: an HTML string }' do
      let(:field) { super().merge(value: '<h1>Greetings, Programs!</h1>') }

      it { expect(rendered).to be == 'Greetings, Programs!' }
    end

    context 'with field: { value: a safe HTML string }' do
      let(:field) do
        super().merge(value: '<h1>Greetings, Programs!</h1>'.html_safe)
      end

      it { expect(rendered).to be == field[:value] }
    end

    context 'with field: { value: a Proc }' do
      let(:field) do
        super().merge(value: ->(data) { data['title'].upcase })
      end

      it { expect(rendered).to be == data[component.field.key].upcase }
    end

    context 'with field: { value: a component }' do
      let(:component) do
        Librum::Components::Literal.new('<span>Actions</span>')
      end
      let(:field) { super().merge(value: component) }

      it { expect(rendered).to be == '<span>Actions</span>' }

      context 'when the component renders unsafe HTML' do
        let(:component) do
          Librum::Components::Literal.new(
            '<form><button type="submit" value="Click Me"></button></form>'
          )
        end
        let(:expected) do
          '<form><button type="submit" value="Click Me"></button></form>'
        end

        it { expect(rendered).to be == expected }
      end
    end

    context 'with field: { value: a component class }' do
      let(:field) do
        super().merge(value: Spec::DataComponent)
      end
      let(:expected) do
        '<span>Gideon the Ninth, by Tamsyn Muir</span>'
      end

      example_class 'Spec::DataComponent', Librum::Components::Base do |klass|
        klass.allow_extra_options

        klass.option :data

        klass.define_method(:call) do
          content_tag('span') { "#{data['title']}, by #{data['author']}" }
        end
      end

      it { expect(rendered).to be == expected }

      context 'when the data field has additional options' do
        let(:component_options) do
          super().merge('topics' => %w[necromancy romance])
        end
        let(:expected) do
          '<span>Gideon the Ninth, by Tamsyn Muir (topics: necromancy, ' \
            'romance)</span>'
        end

        before(:example) do
          Spec::DataComponent.define_method(:call) do
            content_tag('span') do
              "#{data['title']}, by #{data['author']} (topics: " \
                "#{options['topics'].join(', ')})"
            end
          end
        end

        it { expect(rendered).to be == expected }
      end

      context 'when the component class renders unsafe HTML' do
        let(:expected) do
          '<form><button type="submit" value="Click Me"></button></form>'
        end

        before(:example) do
          Spec::DataComponent.define_method(:call) do
            content_tag('form') do
              tag.button(type: 'submit', value: 'Click Me')
            end
          end
        end

        it { expect(rendered).to be == expected }
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
