# frozen_string_literal: true

require 'cuprum/rails/resource'

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Resources::TableActions,
  framework: :bulma,
  type:      :component \
do
  let(:component_options) do
    {
      data:,
      resource:,
      routes:
    }
  end
  let(:data)             { { 'id' => 0 } }
  let(:resource_options) { {} }
  let(:resource) do
    Librum::Components::Resource.new(name: 'books', **resource_options)
  end
  let(:routes) do
    Cuprum::Rails::Routing::PluralRoutes.new(base_path: '/books')
  end

  include_deferred 'should be a view component'

  include_deferred 'should define component option', :data

  include_deferred 'should define component option', :resource

  include_deferred 'should define component option', :routes

  describe '.new' do
    include_deferred 'should validate the presence of option', :resource

    include_deferred 'should validate the presence of option', :routes
  end

  describe '#call' do
    let(:confirm_message) do
      'This will permanently delete book 0.\n\nConfirm deletion?'
    end
    let(:data_attributes) do
      <<~TEXT.strip
        data-action="submit->librum-components-confirm-form#submit" data-controller="librum-components-confirm-form" data-librum-components-confirm-form-message-value="#{confirm_message}"
      TEXT
    end
    let(:snapshot) do
      <<~HTML
        <div class="buttons is-right is-gapless">
          <a class="button has-text-info is-borderless is-shadowless mx-0 px-1 py-0" href="/books/0">
            Show
          </a>

          <a class="button has-text-warning is-borderless is-shadowless mx-0 px-1 py-0" href="/books/0/edit">
            Update
          </a>

          <form class="is-inline-block" #{data_attributes} action="/books/0" accept-charset="UTF-8" method="post">
            <input name="utf8" type="hidden" value="✓" autocomplete="off">

            <input type="hidden" name="_method" value="delete" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <button class="button has-text-danger is-borderless is-shadowless mx-0 px-1 py-0" type="submit">
              Destroy
            </button>
          </form>
        </div>
      HTML
    end

    before(:example) do
      allow(Librum::Components::Bulma::Button)
        .to receive(:new)
        .and_wrap_original do |original, **options|
          button = original.call(**options)

          allow(button).to receive_messages(
            form_authenticity_token:  '12345',
            protect_against_forgery?: true
          )

          button
        end
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with a resource without a show action' do
      let(:actions)          { %w[index edit destroy] }
      let(:resource_options) { super().merge(actions:) }
      let(:snapshot) do
        <<~HTML
          <div class="buttons is-right is-gapless">
            <a class="button has-text-warning is-borderless is-shadowless mx-0 px-1 py-0" href="/books/0/edit">
              Update
            </a>

            <form class="is-inline-block" #{data_attributes} action="/books/0" accept-charset="UTF-8" method="post">
              <input name="utf8" type="hidden" value="✓" autocomplete="off">

              <input type="hidden" name="_method" value="delete" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button class="button has-text-danger is-borderless is-shadowless mx-0 px-1 py-0" type="submit">
                Destroy
              </button>
            </form>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a resource without an edit action' do
      let(:actions)          { %w[index show destroy] }
      let(:resource_options) { super().merge(actions:) }
      let(:snapshot) do
        <<~HTML
          <div class="buttons is-right is-gapless">
            <a class="button has-text-info is-borderless is-shadowless mx-0 px-1 py-0" href="/books/0">
              Show
            </a>

            <form class="is-inline-block" #{data_attributes} action="/books/0" accept-charset="UTF-8" method="post">
              <input name="utf8" type="hidden" value="✓" autocomplete="off">

              <input type="hidden" name="_method" value="delete" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button class="button has-text-danger is-borderless is-shadowless mx-0 px-1 py-0" type="submit">
                Destroy
              </button>
            </form>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a resource without a destroy action' do
      let(:actions)          { %w[index show edit] }
      let(:resource_options) { super().merge(actions:) }
      let(:snapshot) do
        <<~HTML
          <div class="buttons is-right is-gapless">
            <a class="button has-text-info is-borderless is-shadowless mx-0 px-1 py-0" href="/books/0">
              Show
            </a>

            <a class="button has-text-warning is-borderless is-shadowless mx-0 px-1 py-0" href="/books/0/edit">
              Update
            </a>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a resource with remote_forms: true' do
      let(:resource_options) { super().merge(remote_forms: true) }
      let(:snapshot) do
        <<~HTML
          <div class="buttons is-right is-gapless">
            <a class="button has-text-info is-borderless is-shadowless mx-0 px-1 py-0" href="/books/0">
              Show
            </a>

            <a class="button has-text-warning is-borderless is-shadowless mx-0 px-1 py-0" href="/books/0/edit">
              Update
            </a>

            <form class="is-inline-block" #{data_attributes} action="/books/0" accept-charset="UTF-8" data-remote="true" method="post">
              <input name="utf8" type="hidden" value="✓" autocomplete="off">

              <input type="hidden" name="_method" value="delete" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button class="button has-text-danger is-borderless is-shadowless mx-0 px-1 py-0" type="submit">
                Destroy
              </button>
            </form>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with a resource with title_attribute: value' do
      let(:resource_options) { super().merge(title_attribute: 'title') }
      let(:data)             { { 'id' => 0, 'title' => 'Gideon the Ninth' } }
      let(:confirm_message) do
        'This will permanently delete book Gideon the Ninth.\n\n' \
          'Confirm deletion?'
      end

      it { expect(rendered).to match_snapshot(snapshot) }
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
end
