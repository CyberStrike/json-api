require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let!(:user ) { create :user }
  let!(:luigi ) { create :user }

  let!(:luigi_todos) { create_list(:todo, 10, user: luigi) }
  let!(:todos) { create_list(:todo, 10, user: user) }
  let(:todo_id) { fetch_todos.first['id'] }

  describe 'GET /todos' do
    before { get todos_path, headers: valid_headers }

    it 'returns response' do
      expect(json).not_to be_empty
    end

    it 'returns 10 todos' do
      expect(json.size).to eq 10
    end

    it 'returns 10 todos that belong to the user' do
      expect(json.to_s).to match(todos.first.title)
    end
  end

  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}", headers: valid_headers }

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

    context 'when the todo doesn\'t belong to the user' do

      before { get "/todos/#{luigi_todos.first.id}", headers: valid_headers }

      it 'returns an error' do
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'POST /todos' do
    let!(:todo_stub) { attributes_for(:todo) }
    let!(:invalid_todo) { { todo: { title: '', created_by: ''} } }

    context 'when the request is valid' do
      before do
        post '/todos', params: todo_stub.to_json, headers: valid_headers
      end

      it 'creates a todo' do
        expect(json['title']).to eq todo_stub[:title]
      end
    end

    context 'validates' do
      it 'presence of title' do
        post '/todos', params: invalid_todo.to_json, headers: valid_headers
        expect(json['title']).to include(/can't be blank/)
      end
    end
  end

  describe 'PUT /todos' do
    let!(:todo_stub) { attributes_for(:todo) }

    context 'with valid params' do
      before do
        put "/todos/#{todos.first.id}", params: todo_stub.to_json, headers: valid_headers
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
        put "/todos/#{todos.first.id}", params: {}, headers: valid_headers
      end

      it 'returns status :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the record does not exist' do
      let!(:invalid_todo_id) { Todo.count + 10}

      before do
        put "/todos/#{:invalid_todo_id}", params: todo_stub.to_json, headers: valid_headers
      end

      it 'returns status :not_found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /todos' do
    context 'with valid request' do
      let! (:todo_id) { fetch_todos.first['id']    }
       let (:luigi_todo_id) { luigi_todos.first['id'] }

      it 'returns status gone' do
        delete "/todos/#{todo_id}", headers: valid_headers
        expect( response ).to have_http_status :gone
      end

      it 'destroys a todo belonging to the user' do
        expect { delete "/todos/#{todo_id}", headers: valid_headers }
          .to change{fetch_todos.count}.by(-1)
      end

      it 'cannot destroy a todo belonging to another user' do
        expect { delete "/todos/#{luigi_todo_id}", headers: valid_headers }
        .to change(Todo, :count).by(0)
      end

      it 'cannot delete a non-existent todo' do
        delete '/todos/99999', headers: valid_headers
        expect( response ).to have_http_status :not_found
      end
    end
  end
end
