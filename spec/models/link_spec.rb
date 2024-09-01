require 'rails_helper'

RSpec.describe Link do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user:) }
  let!(:answer) { create(:answer, question:, user:) }
  let!(:gist_url_answer) { create(:link, linkable: answer, name: 'gist_url_answer', url: 'https://gist.github.com/Eduard-Gimaev/514a5411559d7e42a2d1c74ad56f18bf') }
  let!(:gist_url_question) { create(:link, linkable: question, name: 'gist_url_question', url: 'https://gist.github.com/Eduard-Gimaev/514a5411559d7e42a2d1c74ad56f18bf') }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }
  it { is_expected.to belong_to(:linkable) }
  it { is_expected.to allow_value('http://example.com').for(:url) }
  it { is_expected.to allow_value('https://example.com').for(:url) }

  context 'when answer has links' do
    describe 'link.gist?' do
      it 'return true when a link referces to the gist' do
        expect(gist_url_answer.gist?).to be true
      end
    end

    describe 'link.gist_url' do
      it 'return ID from link.url' do
        expect(gist_url_answer.gist_url).to eq '514a5411559d7e42a2d1c74ad56f18bf'
      end
    end
  end

  context 'when question has links' do
    describe 'link.gist?' do
      it 'return true when a link referces to the gist' do
        expect(gist_url_question.gist?).to be true
      end
    end

    describe 'link.gist_url' do
      it 'return ID from link.url' do
        expect(gist_url_question.gist_url).to eq '514a5411559d7e42a2d1c74ad56f18bf'
      end
    end
  end
end
