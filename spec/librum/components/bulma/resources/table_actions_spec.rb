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
    Cuprum::Rails::Resource.new(name: 'books', **resource_options)
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
    let(:snapshot) do
      <<~HTML
        <div class="buttons is-gapless">
          <a class="button has-text-info is-borderless mx-0 px-1 py-0" href="/books/0">Show</a>

          <a class="button has-text-warning is-borderless mx-0 px-1 py-0" href="/books/0/edit">Update</a>

          <form class="is-inline-block" action="/books/0" accept-charset="UTF-8" data-remote="true" method="post">
            <input name="utf8" type="hidden" value="✓" autocomplete="off">

            <input type="hidden" name="_method" value="delete" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <button class="button has-text-danger is-borderless mx-0 px-1 py-0" type="submit">Destroy</button>
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
          <div class="buttons is-gapless">
            <a class="button has-text-warning is-borderless mx-0 px-1 py-0" href="/books/0/edit">Update</a>

            <form class="is-inline-block" action="/books/0" accept-charset="UTF-8" data-remote="true" method="post">
              <input name="utf8" type="hidden" value="✓" autocomplete="off">

              <input type="hidden" name="_method" value="delete" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button class="button has-text-danger is-borderless mx-0 px-1 py-0" type="submit">Destroy</button>
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
          <div class="buttons is-gapless">
            <a class="button has-text-info is-borderless mx-0 px-1 py-0" href="/books/0">Show</a>

            <form class="is-inline-block" action="/books/0" accept-charset="UTF-8" data-remote="true" method="post">
              <input name="utf8" type="hidden" value="✓" autocomplete="off">

              <input type="hidden" name="_method" value="delete" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button class="button has-text-danger is-borderless mx-0 px-1 py-0" type="submit">Destroy</button>
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
          <div class="buttons is-gapless">
            <a class="button has-text-info is-borderless mx-0 px-1 py-0" href="/books/0">Show</a>

            <a class="button has-text-warning is-borderless mx-0 px-1 py-0" href="/books/0/edit">Update</a>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
