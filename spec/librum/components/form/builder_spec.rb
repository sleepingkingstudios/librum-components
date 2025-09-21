# frozen_string_literal: true

require 'librum/components'

RSpec.describe Librum::Components::Form::Builder do
  subject(:builder) { described_class.new(fields:, form:) }

  let(:form) do
    instance_double(
      Librum::Components::Form,
      buttons:   '<button type="submit">Submit</button>',
      checkbox:  '<input type="checkbox" />',
      input:     '<input />',
      select:    '<input type="select" />',
      text_area: '<textarea />'
    )
  end
  let(:fields) { [] }

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0).arguments
        .and_keywords(:fields, :form)
    end
  end

  describe '#buttons' do
    let(:options) { {} }

    it 'should define the method' do
      expect(builder)
        .to respond_to(:buttons)
        .with_any_keywords
    end

    it { expect(builder.buttons(**options)).to be builder }

    it 'should delegate to the form' do
      builder.buttons(**options)

      expect(form).to have_received(:buttons).with(no_args)
    end

    it 'should add the buttons to the form fields', :aggregate_failures do
      expect { builder.buttons(**options) }
        .to change(fields, :count)
        .by(1)

      expect(fields.last).to be == form.buttons(**options)
    end

    describe 'with options' do
      let(:options) do
        super().merge(color: 'danger', text: 'Launch Rocket')
      end

      it 'should delegate to the form' do
        builder.buttons(**options)

        expect(form).to have_received(:buttons).with(**options)
      end
    end
  end

  describe '#checkbox' do
    let(:name)    { 'rocket[refuel]' }
    let(:options) { {} }

    it 'should define the method' do
      expect(builder)
        .to respond_to(:checkbox)
        .with(1).arguments
        .and_any_keywords
    end

    it { expect(builder.checkbox(name, **options)).to be builder }

    it 'should delegate to the form' do
      builder.checkbox(name, **options)

      expect(form).to have_received(:checkbox).with(name, **options)
    end

    it 'should add the field to the form fields', :aggregate_failures do
      expect { builder.checkbox(name, **options) }
        .to change(fields, :count)
        .by(1)

      expect(fields.last).to be == form.checkbox(name, **options)
    end

    describe 'with options' do
      let(:options) do
        super().merge(label: 'Refuel Rocket', required: true)
      end

      it 'should delegate to the form' do
        builder.checkbox(name, **options)

        expect(form).to have_received(:checkbox).with(name, **options)
      end
    end
  end

  describe '#fields' do
    include_examples 'should define reader', :fields, -> { fields }
  end

  describe '#form' do
    include_examples 'should define reader', :form, -> { form }
  end

  describe '#input' do
    let(:name)    { 'rocket[name]' }
    let(:options) { {} }

    it 'should define the method' do
      expect(builder)
        .to respond_to(:input)
        .with(1).arguments
        .and_any_keywords
    end

    it { expect(builder.input(name, **options)).to be builder }

    it 'should delegate to the form' do
      builder.input(name, **options)

      expect(form).to have_received(:input).with(name, **options)
    end

    it 'should add the field to the form fields', :aggregate_failures do
      expect { builder.input(name, **options) }
        .to change(fields, :count)
        .by(1)

      expect(fields.last).to be == form.input(name, **options)
    end

    describe 'with options' do
      let(:options) do
        super().merge(placeholder: 'Rocket Name', required: true)
      end

      it 'should delegate to the form' do
        builder.input(name, **options)

        expect(form).to have_received(:input).with(name, **options)
      end
    end
  end

  describe '#select' do
    let(:name)    { 'rocket[space_program]' }
    let(:options) { { values: [] } }

    it 'should define the method' do
      expect(builder)
        .to respond_to(:select)
        .with(1).arguments
        .and_any_keywords
    end

    it { expect(builder.select(name, **options)).to be builder }

    it 'should delegate to the form' do
      builder.select(name, **options)

      expect(form).to have_received(:select).with(name, **options)
    end

    it 'should add the field to the form fields', :aggregate_failures do
      expect { builder.select(name, **options) }
        .to change(fields, :count)
        .by(1)

      expect(fields.last).to be == form.select(name, **options)
    end

    describe 'with options' do
      let(:options) do
        super().merge(placeholder: 'Select Space Program', required: true)
      end

      it 'should delegate to the form' do
        builder.input(name, **options)

        expect(form).to have_received(:input).with(name, **options)
      end
    end
  end

  describe '#text_area' do
    let(:name)    { 'rocket[description]' }
    let(:options) { { values: [] } }

    it 'should define the method' do
      expect(builder)
        .to respond_to(:text_area)
        .with(1).arguments
        .and_any_keywords
    end

    it { expect(builder.text_area(name, **options)).to be builder }

    it 'should delegate to the form' do
      builder.text_area(name, **options)

      expect(form).to have_received(:text_area).with(name, **options)
    end

    it 'should add the field to the form fields', :aggregate_failures do
      expect { builder.text_area(name, **options) }
        .to change(fields, :count)
        .by(1)

      expect(fields.last).to be == form.text_area(name, **options)
    end

    describe 'with options' do
      let(:options) do
        super().merge(placeholder: 'Describe Your Rocket', required: true)
      end

      it 'should delegate to the form' do
        builder.input(name, **options)

        expect(form).to have_received(:input).with(name, **options)
      end
    end
  end
end
