require 'rails_helper'

RSpec.describe 'Authenticate', type: :service do

  # Create test user
  let(:user) { create(:user) }
  # Mock `Authorization` header
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  # Invalid request subject
  subject(:invalid_request) { Authenticate.new({}) }
  # Valid request subject
  subject (:valid_request) do
    Authenticate.new(header)
  end

  describe '#call' do
    # returns user object when request is valid
    context 'with valid request' do
      it 'returns user object' do
        result = valid_request.call
        expect(result[:user]).to eq(user)
      end
    end

    # returns error message when invalid request
    context 'with invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken error' do
          expect{ invalid_request.call }
              .to raise_error(ExceptionHandler::MissingToken, 'Missing token')
        end
      end

      context 'when invalid token' do
        subject(:invalid_request_obj) do
          # custom helper method `token_generator`
          Authenticate.new('Authorization' => token_generator(5))
        end

        it 'raises an InvalidToken error' do
          expect { invalid_request_obj.call }
              .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      context 'when token is expired' do
        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
        subject(:request_obj) { Authenticate.new(header) }

        it 'raises ExceptionHandler::ExpiredSignature error' do
          expect { request_obj.call }
              .to raise_error( ExceptionHandler::ExpiredSignature, 'Signature has expired'
                  )
        end
      end
    end
  end
end