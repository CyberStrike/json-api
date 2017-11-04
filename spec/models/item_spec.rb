require 'rails_helper'

RSpec.describe Item, type: :model do
  context 'Associations' do
    it { is_expected.to belong_to(:todo) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
