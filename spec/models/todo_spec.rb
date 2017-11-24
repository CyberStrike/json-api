require 'rails_helper'

RSpec.describe Todo, type: :model do
  context 'Associations' do
    it { is_expected.to have_many(:items) }
    it { is_expected.to have_many(:items).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :user }
  end
end
