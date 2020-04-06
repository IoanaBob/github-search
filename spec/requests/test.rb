# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Test', type: :request do
  subject { true }

  it { is_expected.to be_truthy }
end
