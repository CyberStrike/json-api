require 'rails_helper'

RSpec.describe Todo, type: :model do
  context 'Associations' do
    it 'has many items' do
      is_expected.to have_many(:items)
    end

    it { should have_many(:items).dependent(:destroy) }
  end

  context 'Validations' do
    it 'must have a title' do
      is_expected.to validate_presence_of :title
    end

    it 'must have created by' do
      is_expected.to validate_presence_of :created_by
    end
  end
end
