require 'rails_helper'

RSpec.describe 'Authentication Endpoint', type: :request do
  let!(:user_stub) { build(:user) }
  let!(:user) { create(:user) }

  let(:invalid_credentials) { { email: user_stub.email, password: user_stub.password_digest }.to_json }
  let(:valid_credentials) { {email: user.email, password: user.password} }

  let(:headers) { valid_headers.except('Authorization') }

  describe 'User Login POST "/auth/login"' do
    context 'with valid request' do
      before do
        post '/auth/login', params: valid_credentials.to_json, headers: headers
      end

      it { is_expected.not_to be_nil }

      it 'returns an authentication token' do
        expect(json['token']).not_to be_nil
      end

      it 'returns status accepted' do
        expect(response).to have_http_status(:accepted)
      end
    end

    context 'with valid request' do
      before { post '/auth/login', params: invalid_credentials, headers: headers }

      it 'returns error message "Invalid credentials"' do
        expect(json['message']).to match(/Invalid credentials/)
      end

      it 'returns status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'User Registration POST "/auth/register"' do
    let(:valid_credentials) { attributes_for(:user) }

    context 'when valid request' do
      before { post '/auth/register', params: valid_credentials.to_json, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status :created
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account Created/)
      end

      it 'returns a valid authentication token' do
        # Normally we wouldn't need to use a tool the user doesn't have access to
        # in an acceptance test but due to the nature of encrypted tokens we have to verify
        # we are being a sent a valid key.

        # Maybe try to validate a request with the returned key on another end point?

        expect{ JsonWebToken.decode(json['token']) }.not_to raise_error
      end

      context 'cannot register the same email twice' do
        before { post '/auth/register', params: valid_credentials.to_json, headers: headers }

        it 'returns error message' do
          expect(json['message']).to match /Email has already been taken/
        end

        it 'responds with a status of :unprocessable_entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when invalid request' do
      before { post '/auth/register', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message']).to match(/Validation failed: Password can't be blank, Name can't be blank, Email can't be blank, Password digest can't be blank/)
      end
    end
  end

  describe 'User request validation GET "/auth/validate"' do
    let(:headers) { valid_headers }
    let(:invalid_headers) { valid_headers.except('Authorization') }

    context 'with valid request' do
      before { get '/auth/validate', params: valid_credentials.to_json, headers: headers }

      it 'returns a success status' do
        expect(response).to have_http_status :accepted
      end

      it 'returns message "Valid request"' do
        expect(json['message']).to match(/Valid request/)
      end
    end

    context 'with invalid request' do
      before { get '/auth/validate', params: valid_credentials.to_json, headers: invalid_headers }

      it 'returns a failure status' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end
end