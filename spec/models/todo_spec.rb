require 'rails_helper'

RSpec.describe Todo, type: :model do
  it { is_expected.to have_many(:items) }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :created_by}
  it { should have_many(:items).dependent(:destroy) }
end
