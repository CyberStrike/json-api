require 'rails_helper'

RSpec.describe "Todos", type: :request do
  # initialize test data
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  describe "GET /todos" do
    before { get todos_path }

    it "returns response" do
      expect(json).not_to be_empty
    end

    it "returns 10 todos" do
      expect(json.size).to eq 10
    end

  end
end