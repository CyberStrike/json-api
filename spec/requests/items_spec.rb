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

  describe 'PUT /todos/:id/items' do
    let!(:item_stub) { attributes_for(:item) }

    context 'with valid params' do
      before do
        put todo_item_path(todo, item), params: item_stub.as_json
      end

      it 'updates the requested todo' do
        get todo_item_path(todo, json['id'])
        expect(json['name']).to match item_stub[:name]
      end

      it 'returns status :ok' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with no params' do
      before do
        put todo_item_path(todo, item), params: {name: ''}
      end

      it 'returns status :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the record does not exist' do
      let!(:invalid_item_id) { Item.count + 10}

      before do
        put todo_item_path(todo_id: 1, id: invalid_item_id), params: {item: {name: item_stub[:name] } }
      end

      it 'returns status :not_found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /items', :focus do
    it 'destroys the requested item' do
      expect {delete todo_item_path(todo, item)}.to change(Item, :count).by(-1)
    end

    it 'destroys the requested todo' do
      delete todo_item_path(todo, item)
      expect( response ).to have_http_status :gone
    end
  end
end
