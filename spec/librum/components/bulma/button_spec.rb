# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Button,
  framework: :bulma,
  type:      :component \
do
  include ViewComponent::TestHelpers

  define_method :tools do
    SleepingKingStudios::Tools::Toolbelt.instance
  end

  include_deferred 'with configuration',
    colors:              %w[red orange yellow green blue indigo violet],
    default_icon_family: 'fa-solid',
    icon_families:       %w[fa-solid],
    sizes:               %w[min mid max]

  include_deferred 'should be a view component'

  include_deferred 'should define component option',
    :color,
    value: 'violet'

  include_deferred 'should define component option',
    :disabled,
    default: false,
    boolean: true

  include_deferred 'should define component option',
    :http_method,
    default: 'post',
    value:   'get'

  include_deferred 'should define component option', :icon

  include_deferred 'should define component option',
    :loading,
    default: false,
    boolean: true

  include_deferred 'should define component option',
    :size,
    value: 'mid'

  include_deferred 'should define component option',
    :target,
    value: 'blank'

  include_deferred 'should define component option',
    :type,
    default: 'button',
    value:   'reset'

  include_deferred 'should define component option', :url

  describe '.new' do
    include_deferred 'should validate that option is a valid color', :color

    include_deferred 'should validate the inclusion of option',
      :http_method,
      expected: %w[delete get patch post put]

    include_deferred 'should validate that option is a valid icon', :icon

    include_deferred 'should validate that option is a valid size', :size

    include_deferred 'should validate the inclusion of option',
      :target,
      expected: %w[blank self]

    describe 'with type: "form"' do
      let(:component_options) { super().merge(type: 'form') }

      describe 'with url: nil' do
        let(:component_options) { super().merge(url: nil) }
        let(:error_message) do
          tools.assertions.error_message_for(
            'sleeping_king_studios.tools.assertions.presence',
            as: 'url'
          )
        end

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error ArgumentError, error_message
        end
      end

      describe 'with url: an Object' do
        let(:component_options) { super().merge(url: Object.new.freeze) }
        let(:error_message) do
          tools.assertions.error_message_for(
            'sleeping_king_studios.tools.assertions.instance_of',
            as:       'url',
            expected: String
          )
        end

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error ArgumentError, error_message
        end
      end
    end

    describe 'with type: "link"' do
      let(:component_options) { super().merge(type: 'link') }

      describe 'with url: nil' do
        let(:component_options) { super().merge(url: nil) }
        let(:error_message) do
          tools.assertions.error_message_for(
            'sleeping_king_studios.tools.assertions.presence',
            as: 'url'
          )
        end

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error ArgumentError, error_message
        end
      end

      describe 'with url: an Object' do
        let(:component_options) { super().merge(url: Object.new.freeze) }
        let(:error_message) do
          tools.assertions.error_message_for(
            'sleeping_king_studios.tools.assertions.instance_of',
            as:       'url',
            expected: String
          )
        end

        it 'should raise an exception' do
          expect { described_class.new(**component_options) }
            .to raise_error ArgumentError, error_message
        end
      end
    end
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <button class="button" type="button"></button>
      HTML
    end

    it { expect(rendered).to match_snapshot(snapshot) }

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <button class="button custom-class" type="button"></button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with color: value' do
      let(:component_options) { super().merge(color: 'violet') }
      let(:snapshot) do
        <<~HTML
          <button class="button is-violet" type="button"></button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with disabled: true' do
      let(:component_options) { super().merge(disabled: true) }
      let(:snapshot) do
        <<~HTML
          <button class="button" disabled="disabled" type="button"></button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with icon: value' do
      let(:component_options) { super().merge(icon: 'radiation') }
      let(:snapshot) do
        <<~HTML
          <button class="button" type="button">
            <span class="icon">
              <i class="fa-solid fa-radiation"></i>
            </span>
          </button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with loading: true' do
      let(:component_options) { super().merge(loading: true) }
      let(:snapshot) do
        <<~HTML
          <button class="button is-loading" type="button"></button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with size: value' do
      let(:component_options) { super().merge(size: 'mid') }
      let(:snapshot) do
        <<~HTML
          <button class="button is-mid" type="button"></button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with text: value' do
      let(:component_options) { super().merge(text: 'Click Me') }
      let(:snapshot) do
        <<~HTML
          <button class="button" type="button">Click Me</button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with type: "form"' do
      let(:component_options) do
        super().merge(
          type: 'form',
          url:  '/path/to/resource'
        )
      end
      let(:snapshot) do
        <<~HTML
          <form class="is-inline-block" action="/path/to/resource" accept-charset="UTF-8" data-remote="true" method="post">
            <input name="utf8" type="hidden" value="✓" autocomplete="off">

            <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

            <button class="button" type="submit"></button>
          </form>
        HTML
      end

      before(:example) do
        allow(component).to receive_messages(
          form_authenticity_token:  '12345',
          protect_against_forgery?: true
        )
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with http_method: value' do
        let(:component_options) { super().merge(http_method: 'delete') }
        let(:snapshot) do
          <<~HTML
            <form class="is-inline-block" action="/path/to/resource" accept-charset="UTF-8" data-remote="true" method="post">
              <input name="utf8" type="hidden" value="✓" autocomplete="off">

              <input type="hidden" name="_method" value="delete" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button class="button" type="submit"></button>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with icon: value' do
        let(:component_options) { super().merge(icon: 'radiation') }
        let(:snapshot) do
          <<~HTML
            <form class="is-inline-block" action="/path/to/resource" accept-charset="UTF-8" data-remote="true" method="post">
              <input name="utf8" type="hidden" value="✓" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button class="button" type="submit">
                <span class="icon">
                  <i class="fa-solid fa-radiation"></i>
                </span>
              </button>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with text: value' do
        let(:component_options) { super().merge(text: 'Click Me') }
        let(:snapshot) do
          <<~HTML
            <form class="is-inline-block" action="/path/to/resource" accept-charset="UTF-8" data-remote="true" method="post">
              <input name="utf8" type="hidden" value="✓" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button class="button" type="submit">Click Me</button>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with multiple options' do
        let(:component_options) do
          super().merge(
            color:       'red',
            http_method: 'delete',
            icon:        'radiation',
            text:        'Click Me'
          )
        end
        let(:snapshot) do
          <<~HTML
            <form class="is-inline-block" action="/path/to/resource" accept-charset="UTF-8" data-remote="true" method="post">
              <input name="utf8" type="hidden" value="✓" autocomplete="off">

              <input type="hidden" name="_method" value="delete" autocomplete="off">

              <input type="hidden" name="authenticity_token" value="[token]" autocomplete="off">

              <button class="button is-red" type="submit">
                <span class="icon">
                  <i class="fa-solid fa-radiation"></i>
                </span>

                <span>Click Me</span>
              </button>
            </form>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with type: "link"' do
      let(:component_options) do
        super().merge(
          type: 'link',
          url:  '/path/to/resource'
        )
      end
      let(:snapshot) do
        <<~HTML
          <a class="button" href="/path/to/resource"></a>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }

      describe 'with icon: value' do
        let(:component_options) { super().merge(icon: 'radiation') }
        let(:snapshot) do
          <<~HTML
            <a class="button" href="/path/to/resource">
              <span class="icon">
                <i class="fa-solid fa-radiation"></i>
              </span>
            </a>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with text: value' do
        let(:component_options) { super().merge(text: 'Click Me') }
        let(:snapshot) do
          <<~HTML
            <a class="button" href="/path/to/resource">Click Me</a>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end

      describe 'with multiple options' do
        let(:component_options) do
          super().merge(
            color: 'red',
            icon:  'radiation',
            text:  'Click Me'
          )
        end
        let(:snapshot) do
          <<~HTML
            <a class="button is-red" href="/path/to/resource">
              <span class="icon">
                <i class="fa-solid fa-radiation"></i>
              </span>

              <span>Click Me</span>
            </a>
          HTML
        end

        it { expect(rendered).to match_snapshot(snapshot) }
      end
    end

    describe 'with type: "reset"' do
      let(:component_options) { super().merge(type: 'reset') }
      let(:snapshot) do
        <<~HTML
          <button class="button" type="reset"></button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with type: "submit"' do
      let(:component_options) { super().merge(type: 'submit') }
      let(:snapshot) do
        <<~HTML
          <button class="button" type="submit"></button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end

    describe 'with multiple options' do
      let(:component_options) do
        super().merge(
          class_name: 'custom-class',
          color:      'violet',
          disabled:   true,
          icon:       'radiation',
          size:       'mid',
          text:       'Click Me',
          type:       'submit'
        )
      end
      let(:snapshot) do
        <<~HTML
          <button class="button is-violet is-mid custom-class" disabled="disabled" type="submit">
            <span class="icon">
              <i class="fa-solid fa-radiation"></i>
            </span>

            <span>Click Me</span>
          </button>
        HTML
      end

      it { expect(rendered).to match_snapshot(snapshot) }
    end
  end
end
