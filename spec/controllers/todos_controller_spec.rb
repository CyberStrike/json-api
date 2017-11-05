require 'rails_helper'


RSpec.describe TodosController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Todo. As you add validations to Todo, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TodosController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "DELETE #destroy" do
    it "destroys the requested todo" do
      todo = Todo.create! valid_attributes
      expect {
        delete :destroy, params: {id: todo.to_param}, session: valid_session
      }.to change(Todo, :count).by(-1)
    end
  end

end
