# frozen_string_literal: true

RSpec.describe Zeitwerk do
  let(:loader) { Zeitwerk::Loader }

  it { expect { loader.eager_load_all }.not_to raise_error }
end
