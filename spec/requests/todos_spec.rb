require 'rails_helper'

RSpec.describe "Todos", type: :request do
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { Todo.order("RANDOM()").first.id }

  describe "GET /todos" do
    before { get todos_path }

    it "returns response" do
      expect(json).not_to be_empty
    end

    it "returns 10 todos" do
      expect(json.size).to eq 10
    end
  end

  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}" }

    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe 'POST /todos' do
    let!(:todo_stub) { {todo: attributes_for(:todo) } }

    context 'when the request is valid' do
      before do
        post '/todos', params: todo_stub
      end

      it 'creates a todo' do
        expect(json[:title]).to equal todo_stub[:title]
      end
    end
  end
end
