require 'rails_helper'

RSpec.describe 'Authenticate', type: :service do

  # Create test user
  let(:user) { create(:user) }
  # Mock `Authorization` header

  describe '#user' do
    context ' with valid request' do
      it 'returns an authentication token' do
      end
    end
  end

  describe '#request' do
    # returns user object when request is valid
    context 'with valid request' do
      let(:header) { { 'Authorization' => token_generator(user.id) } }

      it 'returns user object' do
        result = Authenticate.request(valid_headers)
        expect(result).to eq(user)
      end
    end

    # returns error message when invalid request
    context 'with invalid request' do
      let(:no_token) { { 'Authorization' => '' } }
      let(:bad_user_token) { {'Authorization' => token_generator(5)} }

      context 'is missing token' do
        it 'raises a MissingToken error' do
          expect{ Authenticate.request(no_token) }
              .to raise_error(ExceptionHandler::MissingToken, 'Missing token')
        end
      end

      context 'has an invalid token' do
        let(:bad_request) { Authenticate.request( bad_user_token ) }

        it 'raises an InvalidToken error' do
          expect{ bad_request }.to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      context 'when token is expired' do
        it 'raises ExceptionHandler::ExpiredSignature error' do
          expect{ Authenticate.request('Authorization' => expired_token_generator(user.id)) }
              .to raise_error( ExceptionHandler::ExpiredSignature, 'Signature has expired'
                  )
        end
      end
    end
  end
end
