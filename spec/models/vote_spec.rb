require 'rails_helper'

RSpec.describe Vote do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:votable) }
end
