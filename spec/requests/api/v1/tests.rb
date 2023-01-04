require 'rails_helper'

describe 'Test API' do
    context 'GET /api/v1/tests' do
      it 'success' do
        get '/import'

        expect(response.status).to eq 200
        expect(response.content_type).to include('application/json')
      end
    end
end
