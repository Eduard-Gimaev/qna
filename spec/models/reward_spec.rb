require 'rails_helper'

RSpec.describe Reward do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to have_one_attached(:image) }
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user).optional }
end
