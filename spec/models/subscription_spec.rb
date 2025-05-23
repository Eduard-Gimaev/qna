require 'rails_helper'

RSpec.describe Subscription do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:question) }
  end

  describe 'validations' do
    subject { create(:subscription) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:question_id) }
  end
end
