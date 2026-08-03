# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Bulma::Forms::Field,
  framework: :bulma,
  type:      :component \
do
  let(:component_options) { { name: } }
  let(:name)              { 'rocket[name]' }

  include_deferred 'with configuration',
    colors: %w[danger],
    sizes:  %w[small]

  include_deferred 'should be a view component', allow_extra_options: true

  include_deferred 'should define component option', :class_name

  include_deferred 'should define component option',
    :color,
    value: 'danger'

  include_deferred 'should define component option',
    :icon_left,
    value: 'radiation'

  include_deferred 'should define component option',
    :icon_right,
    value: 'radiation'

  include_deferred 'should define component option',
    :inline,
    boolean: true,
    default: true

  include_deferred 'should define component option', :label

  include_deferred 'should define component option', :message

  include_deferred 'should define component option', :name

  include_deferred 'should define component option',
    :type,
    default: 'text',
    value:   'email'

  describe '.new' do
    include_deferred 'should validate the class_name option'

    include_deferred 'should validate that option is a valid color', :color

    include_deferred 'should validate that option is a valid icon', :icon_left

    include_deferred 'should validate that option is a valid icon', :icon_right

    include_deferred 'should validate the presence of option', :name

    include_deferred 'should validate that option is a valid name', :type

    describe 'with id: nil' do
      let(:component_options) { super().merge(id: nil) }

      it 'should not raise an exception' do
        expect { described_class.new(**component_options) }.not_to raise_error
      end
    end

    describe 'with id: an Object' do
      let(:component_options) { super().merge(id: Object.new.freeze) }
      let(:error_message) do
        tools.assertions.error_message_for(:name, as: 'id')
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with id: an empty String' do
      let(:component_options) { super().merge(id: '') }
      let(:error_message) do
        tools.assertions.error_message_for(:presence, as: 'id')
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with label: an Object' do
      let(:component_options) { super().merge(label: Object.new.freeze) }
      let(:error_message) do
        failure_message = 'label is not a String or a component'

        "invalid options for #{described_class.name} - #{failure_message}"
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with message: an Object' do
      let(:component_options) { super().merge(message: Object.new.freeze) }
      let(:error_message) do
        failure_message = 'message is not a String or a component'

        "invalid options for #{described_class.name} - #{failure_message}"
      end

      it 'should raise an exception' do
        expect { described_class.new(**component_options) }
          .to raise_error ArgumentError, error_message
      end
    end
  end

  describe '#call' do
    let(:snapshot) do
      <<~HTML
        <div class="field">
          <label class="label" for="rocket_name">
            Name
          </label>

          <div class="control">
            <input id="rocket_name" name="rocket[name]" class="input" type="text">
          </div>
        </div>
      HTML
    end

    it { expect(rendered).to match_snapshot }

    describe 'with class_name: value' do
      let(:component_options) { super().merge(class_name: 'custom-class') }
      let(:snapshot) do
        <<~HTML
          <div class="field custom-class">
            <label class="label" for="rocket_name">
              Name
            </label>

            <div class="control">
              <input id="rocket_name" name="rocket[name]" class="input" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with color: value' do
      let(:component_options) { super().merge(color: 'danger') }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="rocket_name">
              Name
            </label>

            <div class="control">
              <input id="rocket_name" name="rocket[name]" class="input is-danger" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with icon_left: value' do
      let(:component_options) { super().merge(icon_left: 'rocket') }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="rocket_name">
              Name
            </label>

            <div class="control has-icons-left">
              <input id="rocket_name" name="rocket[name]" class="input" type="text">

              <span class="icon is-small is-left">
                <i class="fa-solid fa-rocket"></i>
              </span>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with icon_right: value' do
      let(:component_options) { super().merge(icon_right: 'radiation') }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="rocket_name">
              Name
            </label>

            <div class="control has-icons-right">
              <input id="rocket_name" name="rocket[name]" class="input" type="text">

              <span class="icon is-small is-right">
                <i class="fa-solid fa-radiation"></i>
              </span>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with id: a String' do
      let(:component_options) { super().merge(id: 'custom_id') }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="custom_id">
              Name
            </label>

            <div class="control">
              <input id="custom_id" name="rocket[name]" class="input" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with label: a String' do
      let(:label)             { 'Refuel Rocket' }
      let(:component_options) { super().merge(label:) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="rocket_name">
              Refuel Rocket
            </label>

            <div class="control">
              <input id="rocket_name" name="rocket[name]" class="input" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with label: an HTML string' do
      let(:label) do
        '<span class="has-text-red">Refuel Rocket</span>'
      end
      let(:component_options) { super().merge(label:) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="rocket_name">
              Refuel Rocket
            </label>

            <div class="control">
              <input id="rocket_name" name="rocket[name]" class="input" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with label: a safe HTML string' do
      let(:label) do
        '<label class="has-text-danger">Refuel Rocket</label>'.html_safe
      end
      let(:component_options) { super().merge(label:) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="has-text-danger">
              Refuel Rocket
            </label>

            <div class="control">
              <input id="rocket_name" name="rocket[name]" class="input" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with label: a component' do
      let(:label) do
        Librum::Components::Literal.new(
          '<label class="has-text-danger">Refuel Rocket</label>'
        )
      end
      let(:component_options) { super().merge(label:) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="has-text-danger">
              Refuel Rocket
            </label>

            <div class="control">
              <input id="rocket_name" name="rocket[name]" class="input" type="text">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with message: a String' do
      let(:message)           { 'Rocket is out of fuel' }
      let(:component_options) { super().merge(message:) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="rocket_name">
              Name
            </label>

            <div class="control">
              <input id="rocket_name" name="rocket[name]" class="input" type="text">
            </div>

            <p class="help">
              Rocket is out of fuel
            </p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with message: an HTML string' do
      let(:message) do
        '<p class="has-text-danger">Rocket is out of fuel</p>'
      end
      let(:component_options) { super().merge(message:) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="rocket_name">
              Name
            </label>

            <div class="control">
              <input id="rocket_name" name="rocket[name]" class="input" type="text">
            </div>

            <p class="help">
              Rocket is out of fuel
            </p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with message: a safe HTML string' do
      let(:message) do
        '<p class="has-text-danger">Rocket is out of fuel</p>'.html_safe
      end
      let(:component_options) { super().merge(message:) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="rocket_name">
              Name
            </label>

            <div class="control">
              <input id="rocket_name" name="rocket[name]" class="input" type="text">
            </div>

            <p class="has-text-danger">
              Rocket is out of fuel
            </p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with message: a component' do
      let(:message) do
        Librum::Components::Literal.new(
          '<p class="has-text-danger">Rocket is out of fuel</p>'
        )
      end
      let(:component_options) { super().merge(message:) }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="rocket_name">
              Name
            </label>

            <div class="control">
              <input id="rocket_name" name="rocket[name]" class="input" type="text">
            </div>

            <p class="has-text-danger">
              Rocket is out of fuel
            </p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with type: value' do
      let(:component_options) { super().merge(type: 'password') }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="rocket_name">
              Name
            </label>

            <div class="control">
              <input id="rocket_name" name="rocket[name]" class="input" type="password">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with value: value' do
      let(:component_options) { super().merge(value: 'Hellhound IV') }
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="rocket_name">
              Name
            </label>

            <div class="control">
              <input id="rocket_name" name="rocket[name]" class="input" type="text" value="Hellhound IV">
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with multiple options' do
      let(:component_options) do
        super().merge(
          class_name:  'custom-class',
          color:       'danger',
          icon_left:   'rocket',
          icon_right:  'radiation',
          id:          'custom_id',
          label:       'Rocket Name',
          message:     'Rocket is out of fuel',
          placeholder: 'Name of Rocket',
          required:    true,
          value:       'Hellhound IV'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="field custom-class">
            <label class="label" for="custom_id">
              Rocket Name
            </label>

            <div class="control has-icons-left has-icons-right">
              <input id="custom_id" name="rocket[name]" class="input is-danger" placeholder="Name of Rocket" required="required" type="text" value="Hellhound IV">

              <span class="icon is-small is-left">
                <i class="fa-solid fa-rocket"></i>
              </span>

              <span class="icon is-small is-right">
                <i class="fa-solid fa-radiation"></i>
              </span>
            </div>

            <p class="help is-danger">
              Rocket is out of fuel
            </p>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }
    end

    describe 'with type: checkbox' do
      let(:component_options) do
        super().merge(
          name: 'rocket[refuel]',
          type: 'checkbox'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <div class="control">
              <label class="checkbox" for="rocket_refuel">
                <input autocomplete="off" name="rocket[refuel]" type="hidden" value="0">

                <input id="rocket_refuel" name="rocket[refuel]" type="checkbox" value="1">

                <span class="ml-1">
                  Refuel
                </span>
              </label>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }

      describe 'with id: a String' do
        let(:component_options) { super().merge(id: 'custom_id') }
        let(:snapshot) do
          <<~HTML
            <div class="field">
              <div class="control">
                <label class="checkbox" for="custom_id">
                  <input autocomplete="off" name="rocket[refuel]" type="hidden" value="0">

                  <input id="custom_id" name="rocket[refuel]" type="checkbox" value="1">

                  <span class="ml-1">
                    Refuel
                  </span>
                </label>
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot }
      end

      describe 'with inline: false' do
        let(:component_options) { super().merge(inline: false) }
        let(:snapshot) do
          <<~HTML
            <div class="field">
              <label class="label" for="rocket_refuel">
                &nbsp;
              </label>

              <div class="control px-1 py-2">
                <label class="checkbox" for="rocket_refuel">
                  <input autocomplete="off" name="rocket[refuel]" type="hidden" value="0">

                  <input id="rocket_refuel" name="rocket[refuel]" type="checkbox" value="1">

                  <span class="ml-1">
                    Refuel
                  </span>
                </label>
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot }
      end

      describe 'with multiple options' do
        let(:component_options) do
          super().merge(
            checked:  true,
            color:    'danger',
            label:    'Refuel Rocket',
            message:  'Rocket is out of fuel',
            required: true
          )
        end
        let(:snapshot) do
          <<~HTML
            <div class="field">
              <div class="control">
                <label class="checkbox" for="rocket_refuel">
                  <input autocomplete="off" name="rocket[refuel]" type="hidden" value="0">

                  <input id="rocket_refuel" name="rocket[refuel]" type="checkbox" checked="checked" required="required" value="1">

                  <span class="ml-1">
                    Refuel Rocket
                  </span>
                </label>
              </div>

              <p class="help is-danger">
                Rocket is out of fuel
              </p>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot }
      end
    end

    describe 'with type: select' do
      let(:values) do
        [
          { label: 'Avalon Heavy Industries',  value: 'ahi' },
          { label: 'Morningstar Technologies', value: 'mst' }
        ]
      end
      let(:component_options) do
        super().merge(
          name:   'game[space_program]',
          type:   'select',
          values:
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="game_space_program">
              Space Program
            </label>

            <div class="control">
              <div class="select is-block">
                <select id="game_space_program" name="game[space_program]">
                  <option value="ahi">
                    Avalon Heavy Industries
                  </option>

                  <option value="mst">
                    Morningstar Technologies
                  </option>
                </select>
              </div>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }

      describe 'with id: a String' do
        let(:component_options) { super().merge(id: 'custom_id') }
        let(:snapshot) do
          <<~HTML
            <div class="field">
              <label class="label" for="custom_id">
                Space Program
              </label>

              <div class="control">
                <div class="select is-block">
                  <select id="custom_id" name="game[space_program]">
                    <option value="ahi">
                      Avalon Heavy Industries
                    </option>

                    <option value="mst">
                      Morningstar Technologies
                    </option>
                  </select>
                </div>
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot }
      end

      describe 'with multiple options' do
        let(:component_options) do
          super().merge(
            color:       'danger',
            label:       'Select Space Program',
            message:     'Rockets are out of fuel',
            placeholder: 'Space Program',
            required:    true,
            value:       'mst'
          )
        end
        let(:snapshot) do
          <<~HTML
            <div class="field">
              <label class="label" for="game_space_program">
                Select Space Program
              </label>

              <div class="control">
                <div class="select is-danger is-block">
                  <select id="game_space_program" name="game[space_program]" required="required">
                    <option value="">
                      Space Program
                    </option>

                    <option value="ahi">
                      Avalon Heavy Industries
                    </option>

                    <option value="mst" selected="selected">
                      Morningstar Technologies
                    </option>
                  </select>
                </div>
              </div>

              <p class="help is-danger">
                Rockets are out of fuel
              </p>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot }
      end
    end

    describe 'with type: textarea' do
      let(:component_options) do
        super().merge(
          name: 'rocket[description]',
          type: 'textarea'
        )
      end
      let(:snapshot) do
        <<~HTML
          <div class="field">
            <label class="label" for="rocket_description">
              Description
            </label>

            <div class="control">
              <textarea id="rocket_description" name="rocket[description]" class="textarea"></textarea>
            </div>
          </div>
        HTML
      end

      it { expect(rendered).to match_snapshot }

      describe 'with id: a String' do
        let(:component_options) { super().merge(id: 'custom_id') }
        let(:snapshot) do
          <<~HTML
            <div class="field">
              <label class="label" for="custom_id">
                Description
              </label>

              <div class="control">
                <textarea id="custom_id" name="rocket[description]" class="textarea"></textarea>
              </div>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot }
      end

      describe 'with multiple options' do
        let(:value) do
          <<~TEXT
            And thou, Mercurius, that with wingèd brow
            Dost mount aloft into the yielding sky,
            And thro' Heav'n's halls thy airy flight dost throw,
            Entering with holy feet to where on high
            Jove weighs the counsel of futurity;
          TEXT
        end
        let(:component_options) do
          super().merge(
            color:    'danger',
            label:    'Decribe The Rocket',
            message:  'Rocket is out of fuel',
            required: true,
            value:
          )
        end
        let(:snapshot) do
          <<~HTML
            <div class="field">
              <label class="label" for="rocket_description">
                Decribe The Rocket
              </label>

              <div class="control">
                <textarea id="rocket_description" name="rocket[description]" class="textarea is-danger" required="required">
                  And thou, Mercurius, that with wingèd brow
                  Dost mount aloft into the yielding sky,
                  And thro' Heav'n's halls thy airy flight dost throw,
                  Entering with holy feet to where on high
                  Jove weighs the counsel of futurity;
                </textarea>
              </div>

              <p class="help is-danger">
                Rocket is out of fuel
              </p>
            </div>
          HTML
        end

        it { expect(rendered).to match_snapshot }
      end
    end
  end
end
