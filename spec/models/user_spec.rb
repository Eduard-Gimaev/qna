require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(true) }
  it { should have_many(:answers).dependent(true) }

  let(:user1) { create(:user) }
  let(:question1) { create(:question, user: user1) }
  let(:answer1) { create(:answer, question: question1, user: user1) }

  let(:user2) { create(:user) }
  let(:question2) { create(:question, user: user2) }
  let(:answer2) { create(:answer, question: question2, user: user2) }

  it 'should have a correct author' do
    expect(user1).to be_author(question1)
    expect(user1).to be_author(answer1)
    expect(user2).to be_author(question2)
    expect(user2).to be_author(answer2)


  end
end
