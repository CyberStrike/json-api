require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  let!(:todos) { create_list :todo_with_items, 10, item_count: rand(1..10) }
  let!(:todo) { Todo.order("RANDOM()").first }
  let(:item) { todo.items.order("RANDOM()").first }

  describe 'GET /todos/:todo_id/items' do
    context 'when todo exists' do
      before { get todo_items_path(todo) }

      it "returns response" do
        expect(json).not_to be_empty
      end

      it "returns all the todos items" do
        expect(json.size).to eq todo.items.count
      end
    end

    context 'when todo does not exist' do
      before { get todo_items_path(Todo.last.id + 1) }

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe 'GET /todos/:id/item/:id' do
    before { get todo_item_path(todo, item) }

    context 'when item exists' do
      before { get todo_items_path(todo) }

      it "returns response" do
        expect(json).not_to be_empty
      end

      it "returns the todo item" do
        expect(json.size).to eq todo.items.count
      end
    end

    context 'when item does not exist' do
      before { get todo_items_path(Todo.last.id + 1) }

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe 'POST /todos/:id/items' do
    let!(:item_stub) { build :item }
    let(:invalid_item) { { item: { name: ''} } }

    context 'when the request is valid' do
      before do
        post todo_items_path(todo), params: item_stub.as_json
      end

      it 'creates an item' do
        # Check the system the way you would check the system
        get todo_item_path(todo, json['id'])
        expect(json['name']).to match item_stub[:name]
      end

      it 'returns status created' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'validates' do
      it 'presence of name' do
        post todo_items_path(todo), params: invalid_item.as_json
        expect(json['name']).to include(/can't be blank/)
      end
    end
  end
  #
  # describe 'PUT /todos' do
  #   let!(:todo_stub) { attributes_for(:todo) }
  #
  #   context 'with valid params' do
  #     before do
  #       put "/todos/#{todo_id}", params: {todo: {title: todo_stub[:title] } }
  #     end
  #
  #     it 'updates the requested todo' do
  #       expect(json['title']).to eq todo_stub[:title]
  #     end
  #
  #     it 'returns status :ok' do
  #       expect(response).to have_http_status(200)
  #     end
  #   end
  #
  #   context 'with no params' do
  #     before do
  #       put "/todos/#{todo_id}", params: {}
  #     end
  #
  #     it 'returns status :unprocessable_entity' do
  #       expect(response).to have_http_status(:unprocessable_entity)
  #     end
  #   end
  #
  #   context 'when the record does not exist' do
  #     let!(:invalid_todo_id) { Todo.count + 10}
  #
  #     before do
  #       put "/todos/#{:invalid_todo_id}", params: {todo: {title: todo_stub[:title] } }
  #     end
  #
  #     it 'returns status :not_found' do
  #       expect(response).to have_http_status(:not_found)
  #     end
  #   end
  # end
  #
  # describe 'DELETE /items', :focus do
  #   xit 'destroys the requested todo' do
  #     expect { delete "/todos/#{todo_id}" }.to change(Todo, :count).by(-1)
  #   end
  #
  #   xit 'destroys the requested todo' do
  #     delete "/todos/#{todo_id}"
  #     expect( response ).to have_http_status :gone
  #   end
  # end
end
