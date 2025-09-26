# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Resources::DestroyButton,
  framework: :bulma,
  type:      :component \
do
  let(:component_options) { { url: } }
  let(:url)               { '/rockets' }

  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :icon,
    default: 'eraser',
    value:   'bomb'

  include_deferred 'should define component option',
    :text,
    default: 'Destroy',
    value:   'Self-Destruct'

  include_deferred 'should define component option',
    :url,
    value: '/facility/self-destruct'

  describe '.new' do
    include_deferred 'should validate that option is a valid icon', :icon

    include_deferred 'should validate the type of option',
      :text,
      allow_nil: true,
      expected:  String

    include_deferred 'should validate the presence of option', :url

    include_deferred 'should validate the type of option',
      :url,
      allow_nil: true,
      expected:  String
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <form class="is-inline-block" action="/rockets" accept-charset="UTF-8" method="post">
          <input name="utf8" type="hidden" value="✓" autocomplete="off">

          <input type="hidden" name="_method" value="delete" autocomplete="off">

          <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

          <button class="button is-danger is-outlined" type="submit">
            <span class="icon">
              <i class="fa-solid fa-eraser"></i>
            </span>

            <span>
              Destroy
            </span>
          </button>
        </form>
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

    include_deferred 'with configuration',
      default_icon_family: 'fa-solid',
      icon_families:       %w[fa-solid]

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with icon: value' do
      let(:component_options) { super().merge(icon: 'bomb') }
      let(:snapshot) do
        <<~HTML
          <form class="is-inline-block" action="/rockets" accept-charset="UTF-8" method="post">
            <input name="utf8" type="hidden" value="✓" autocomplete="off">

            <input type="hidden" name="_method" value="delete" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <button class="button is-danger is-outlined" type="submit">
              <span class="icon">
                <i class="fa-solid fa-bomb"></i>
              </span>

              <span>
                Destroy
              </span>
            </button>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with text: value' do
      let(:component_options) { super().merge(text: 'Self-Destruct') }
      let(:snapshot) do
        <<~HTML
          <form class="is-inline-block" action="/rockets" accept-charset="UTF-8" method="post">
            <input name="utf8" type="hidden" value="✓" autocomplete="off">

            <input type="hidden" name="_method" value="delete" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <button class="button is-danger is-outlined" type="submit">
              <span class="icon">
                <i class="fa-solid fa-eraser"></i>
              </span>

              <span>
                Self-Destruct
              </span>
            </button>
          </form>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
