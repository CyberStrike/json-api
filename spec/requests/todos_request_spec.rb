require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { Todo.order("RANDOM()").first.id }

  describe 'GET /todos' do
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

      it 'returns a response' do
        expect(json).not_to be_empty
      end

      it 'returns the todo' do
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
    let!(:invalid_todo) { { todo: { title: '', created_by: ''} } }

    context 'when the request is valid' do
      before do
        post '/todos', params: todo_stub
      end

      it 'creates a todo' do
        expect(json[:title]).to equal todo_stub[:title]
      end
    end

    context 'validates' do
      it 'presence of title' do
        post '/todos', params: invalid_todo
        expect(json['title']).to include(/can't be blank/)
      end

      it 'presence of created_by' do
        post '/todos', params: invalid_todo
        expect(json['created_by']).to include(/can't be blank/)
      end
    end
  end

  describe 'PUT /todos' do
    let!(:todo_stub) { attributes_for(:todo) }

    context 'with valid params' do
      before do
        put "/todos/#{todo_id}", params: {todo: {title: todo_stub[:title] } }
      end

      it 'updates the requested todo' do
        expect(json['title']).to eq todo_stub[:title]
      end

      it 'returns status :ok' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with no params' do
      before do
        put "/todos/#{todo_id}", params: {}
      end

      it 'returns status :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the record does not exist' do
      let!(:invalid_todo_id) { Todo.count + 10}

      before do
        put "/todos/#{:invalid_todo_id}", params: {todo: {title: todo_stub[:title] } }
      end

      it 'returns status :not_found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /todos' do
    it 'destroys the requested todo' do
      expect { delete "/todos/#{todo_id}" }.to change(Todo, :count).by(-1)
    end

    it 'destroys the requested todo' do
      delete "/todos/#{todo_id}"
      expect( response ).to have_http_status :gone
    end
  end
end
