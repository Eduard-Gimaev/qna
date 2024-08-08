# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user_first) { create(:user) }
  let(:question_first) { create(:question, user: user_first) }
  let(:answer_first) { create(:answer, question: question_first, user: user_first) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many(:questions).dependent(true) }
  it { is_expected.to have_many(:answers).dependent(true) }

  it 'has a correct author for an answer' do
    expect(user_first).to be_author(answer_first)
  end
end
