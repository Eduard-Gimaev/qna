require 'rails_helper'

RSpec.describe Link do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }
  it { is_expected.to belong_to(:linkable) }
  it { is_expected.to allow_value('http://example.com').for(:url) }
  it { is_expected.to allow_value('https://example.com').for(:url) }
end
