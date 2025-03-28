# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer do
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many_attached(:files) }
  it { is_expected.to have_many(:links).dependent(true) }
  it { is_expected.to accept_nested_attributes_for(:links) }
end
