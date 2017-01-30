require 'rails_helper'

RSpec.describe OpenSearch::DescriptionsController, type: :controller do
  describe 'GET #show' do
    it 'returns http success' do
      get :show, format: :osd_xml
      expect(response).to have_http_status(:success)
    end
  end
end
