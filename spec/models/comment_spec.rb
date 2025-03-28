require 'rails_helper'

RSpec.describe Comment do
  it { is_expected.to belong_to(:commentable) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:body) }
end
