# frozen_string_literal: true

require 'cuprum/rails'

require 'librum/components'

RSpec.describe Librum::Components::Views::Resources::Elements::Form,
  type: :component \
do
  subject(:component) do
    described_class.new(**required_keywords, **component_options)
  end

  deferred_context 'with a component subclass' do
    let(:described_class) { Spec::Component }

    example_class 'Spec::Component',
      Librum::Components::Views::Resources::Elements::Form # rubocop:disable RSpec/DescribedClass
  end

  deferred_context 'with component stubs' do
    before(:example) do
      stub_provider(
        Librum::Components.provider,
        :components,
        Spec::Components
      )
    end

    example_class 'Spec::Components::Form', Librum::Components::Form

    example_class 'Spec::Components::Forms::Buttons',
      Librum::Components::Base \
    do |klass|
      klass.allow_extra_options

      klass.option :text

      klass.define_method(:call) do
        content_tag('button') { text }
      end
    end

    example_class 'Spec::Components::Forms::Field',
      Librum::Components::Base \
    do |klass|
      klass.allow_extra_options

      klass.option :name

      klass.define_method(:call) do
        tag.input(name:)
      end
    end
  end

  let(:component_options) { { routes: } }
  let(:resource_options)  { {} }
  let(:resource) do
    Librum::Components::Resource.new(name: 'books', **resource_options)
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
    :action,
    value: '/books/publish'

  include_deferred 'should define component option',
    :http_method,
    value: :patch

  include_deferred 'should define component option',
    :routes,
    value: Cuprum::Rails::Routes.new(base_path: 'tomes')

  describe '.new' do
    define_method :validate_options do
      described_class.new(**required_keywords, **component_options)
    end

    include_deferred 'should validate the type of option',
      :action,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate that option is a valid http method',
      :http_method

    include_deferred 'should validate the presence of option', :routes

    include_deferred 'should validate the type of option',
      :routes,
      allow_nil: true,
      expected:  Cuprum::Rails::Routes
  end

  describe '#call' do
    let(:fields) do
      lambda do |form|
        form.input 'book[title]'

        form.input 'book[author]'

        form.buttons(text: submit_text)
      end
    end
    let(:error_message) do
      "unhandled action name #{action_name.inspect}"
    end

    before(:example) { Spec::Component.const_set(:FIELDS, fields) }

    include_deferred 'with a component subclass'

    it 'should raise an exception' do
      expect { render_component(component) }.to raise_error error_message
    end

    context 'with action_name: "create"' do
      let(:action_name) { 'create' }

      include_deferred 'should render a missing component', 'Form'

      context 'when the Form component is defined' do
        let(:snapshot) do
          <<~HTML
            <form action="/books" accept-charset="UTF-8" method="post">
              <input name="utf8" type="hidden" value="✓" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <input name="book[title]">

              <input name="book[author]">

              <button>
                Create Book
              </button>
            </form>
          HTML
        end

        before(:example) do
          allow(Spec::Components::Form)
            .to receive(:new)
            .and_wrap_original do |original, **options|
              form = original.call(**options)

              allow(form).to receive_messages(
                form_authenticity_token:  '12345',
                protect_against_forgery?: true
              )

              form
            end
        end

        include_deferred 'with component stubs'

        it { expect(rendered).to match_snapshot(snapshot) }

        describe 'with a resource with remote_forms: true' do
          let(:resource_options) { super().merge(remote_forms: true) }
          let(:snapshot) do
            <<~HTML
              <form action="/books" accept-charset="UTF-8" data-remote="true" method="post">
                <input name="utf8" type="hidden" value="✓" autocomplete="off">

                <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

                <input name="book[title]">

                <input name="book[author]">

                <button>
                  Create Book
                </button>
              </form>
            HTML
          end

          it { expect(rendered).to match_snapshot(snapshot) }
        end
      end
    end

    context 'with action_name: "update"' do
      let(:action_name) { 'update' }

      include_deferred 'should render a missing component', 'Form'

      context 'when the Form component is defined' do
        let(:snapshot) do
          <<~HTML
            <form action="/books/example-book" accept-charset="UTF-8" method="post">
              <input name="utf8" type="hidden" value="✓" autocomplete="off">

              <input type="hidden" name="_method" value="patch" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <input name="book[title]">

              <input name="book[author]">

              <button>
                Update Book
              </button>
            </form>
          HTML
        end

        before(:example) do
          allow(Spec::Components::Form)
            .to receive(:new)
            .and_wrap_original do |original, **options|
              form = original.call(**options)

              allow(form).to receive_messages(
                form_authenticity_token:  '12345',
                protect_against_forgery?: true
              )

              form
            end
        end

        include_deferred 'with component stubs'

        it { expect(rendered).to match_snapshot(snapshot) }

        describe 'with a resource with remote_forms: true' do
          let(:resource_options) { super().merge(remote_forms: true) }
          let(:snapshot) do
            <<~HTML
              <form action="/books/example-book" accept-charset="UTF-8" data-remote="true" method="post">
                <input name="utf8" type="hidden" value="✓" autocomplete="off">

                <input type="hidden" name="_method" value="patch" autocomplete="off">

                <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

                <input name="book[title]">

                <input name="book[author]">

                <button>
                  Update Book
                </button>
              </form>
            HTML
          end

          it { expect(rendered).to match_snapshot(snapshot) }
        end
      end
    end
  end

  describe '#cancel_url' do
    include_examples 'should define reader', :cancel_url

    context 'with action_name: "create"' do
      let(:action_name) { 'create' }

      it { expect(component.cancel_url).to be == routes.index_path }
    end

    context 'with action_name: "edit"' do
      let(:action_name) { 'edit' }

      it { expect(component.cancel_url).to be == routes.show_path }
    end

    context 'with action_name: "new"' do
      let(:action_name) { 'new' }

      it { expect(component.cancel_url).to be == routes.index_path }
    end

    context 'with action_name: "update"' do
      let(:action_name) { 'update' }

      it { expect(component.cancel_url).to be == routes.show_path }
    end

    context 'with another action name' do
      let(:error_message) do
        "unhandled action name #{action_name.inspect}"
      end

      it 'should raise an exception' do
        expect { component.cancel_url }.to raise_error error_message
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
        let(:action_name) { 'create' }
        let(:fields) do
          lambda do |form|
            form.input 'book[title]'

            form.input 'book[author]'

            form.buttons(text: submit_text)
          end
        end
        let(:form_builder) do
          instance_double(
            Librum::Components::Form::Builder,
            buttons: nil,
            input:   nil
          )
        end

        before(:example) { Spec::Component.const_set(:FIELDS, fields) }

        it { expect(component.send(:fields)).to be_a Proc }

        it 'should evaluate the block in the context of the resource form',
          :aggregate_failures \
        do
          component.send(:fields).call(form_builder)

          expect(form_builder).to have_received(:input).with('book[author]')
          expect(form_builder).to have_received(:input).with('book[title]')

          expect(form_builder)
            .to have_received(:buttons)
            .with(text: 'Create Book')
        end
      end
    end
  end

  describe '#form_action' do
    include_examples 'should define reader', :form_action

    context 'when initialized with action: value' do
      let(:action)            { '/books/publish' }
      let(:component_options) { super().merge(action:) }

      it { expect(component.form_action).to be == action }
    end

    context 'with action_name: "create"' do
      let(:action_name) { 'create' }

      it { expect(component.form_action).to be == routes.create_path }
    end

    context 'with action_name: "edit"' do
      let(:action_name) { 'edit' }

      it { expect(component.form_action).to be == routes.update_path }
    end

    context 'with action_name: "new"' do
      let(:action_name) { 'new' }

      it { expect(component.form_action).to be == routes.create_path }
    end

    context 'with action_name: "update"' do
      let(:action_name) { 'update' }

      it { expect(component.form_action).to be == routes.update_path }
    end

    context 'with another action name' do
      let(:error_message) do
        "unhandled action name #{action_name.inspect}"
      end

      it 'should raise an exception' do
        expect { component.form_action }.to raise_error error_message
      end
    end
  end

  describe '#form_http_method' do
    include_examples 'should define reader', :form_http_method

    context 'when initialized with http_method: value' do
      let(:component_options) { super().merge(http_method: :patch) }

      it { expect(component.form_http_method).to be :patch }
    end

    context 'with action_name: "create"' do
      let(:action_name) { 'create' }

      it { expect(component.form_http_method).to be :post }
    end

    context 'with action_name: "edit"' do
      let(:action_name) { 'edit' }

      it { expect(component.form_http_method).to be :patch }
    end

    context 'with action_name: "new"' do
      let(:action_name) { 'new' }

      it { expect(component.form_http_method).to be :post }
    end

    context 'with action_name: "update"' do
      let(:action_name) { 'update' }

      it { expect(component.form_http_method).to be :patch }
    end

    context 'with another action name' do
      let(:error_message) do
        "unhandled action name #{action_name.inspect}"
      end

      it 'should raise an exception' do
        expect { component.form_http_method }.to raise_error error_message
      end
    end
  end

  describe '#remote?' do
    include_examples 'should define predicate', :remote?, false

    wrap_deferred 'with configuration', remote_forms: false do
      it { expect(component.remote?).to be false }
    end

    wrap_deferred 'with configuration', remote_forms: true do # rubocop:disable RSpec/MetadataStyle
      it { expect(component.remote?).to be true }
    end

    describe 'with a resource with remote_forms: false' do
      let(:resource_options) { super().merge(remote_forms: false) }

      it { expect(component.remote?).to be false }

      wrap_deferred 'with configuration', remote_forms: false do
        it { expect(component.remote?).to be false }
      end

      wrap_deferred 'with configuration', remote_forms: true do # rubocop:disable RSpec/MetadataStyle
        it { expect(component.remote?).to be false }
      end
    end

    describe 'with a resource with remote_forms: true' do
      let(:resource_options) { super().merge(remote_forms: true) }

      it { expect(component.remote?).to be true }

      wrap_deferred 'with configuration', remote_forms: false do
        it { expect(component.remote?).to be true }
      end

      wrap_deferred 'with configuration', remote_forms: true do # rubocop:disable RSpec/MetadataStyle
        it { expect(component.remote?).to be true }
      end
    end
  end

  describe '#submit_text' do
    include_examples 'should define reader', :submit_text

    context 'with action_name: "create"' do
      let(:action_name) { 'create' }

      it { expect(component.submit_text).to be == 'Create Book' }
    end

    context 'with action_name: "edit"' do
      let(:action_name) { 'edit' }

      it { expect(component.submit_text).to be == 'Update Book' }
    end

    context 'with action_name: "new"' do
      let(:action_name) { 'new' }

      it { expect(component.submit_text).to be == 'Create Book' }
    end

    context 'with action_name: "update"' do
      let(:action_name) { 'update' }

      it { expect(component.submit_text).to be == 'Update Book' }
    end

    context 'with another action name' do
      let(:error_message) do
        "unhandled action name #{action_name.inspect}"
      end

      it 'should raise an exception' do
        expect { component.submit_text }.to raise_error error_message
      end
    end
  end
end
