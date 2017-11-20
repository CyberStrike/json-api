require 'rails_helper'

RSpec.describe 'Authentication Endpoint', type: :request do
  describe 'POST /auth/login' do
    # create test user
    let!(:user) { create(:user) }
    let!(:user_stub) { build(:user) }
    # set headers for authorization
    let(:headers) { valid_headers.except('Authorization') }
    # set test valid and invalid credentials
    let(:valid_credentials) { { email: user.email,  password: user.password }.to_json }
    let(:invalid_credentials) { { email: user_stub.email, password: user_stub.password_digest }.to_json }

    # set request.headers to our custom headers
    # before { allow(request).to receive(:headers).and_return(headers) }

    context 'When request is valid' do
      before do
        post '/auth/login', params: valid_credentials, headers: headers
      end

      it 'returns an authentication token' do
        expect(json['token']).not_to be_nil
      end

      it 'returns status accepted' do
        expect(response).to have_http_status(:accepted)
      end
    end

    context 'When request is invalid' do
      before { post '/auth/login', params: invalid_credentials, headers: headers }

      it 'returns error message "Invalid credentials"' do
        expect(json['message']).to match(/Invalid credentials/)
      end

      it 'returns status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end