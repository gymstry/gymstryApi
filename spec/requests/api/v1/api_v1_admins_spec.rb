require 'rails_helper'

RSpec.describe "Api::V1::Admins", type: :request do
  let!(:admins) {create_list(:admin,10)}
  let(:id) {admins.first.id}
  let(:ids) { [admins[0].id,admins[1].id] }
  let(:valid_attributes) {
    {
      admin: {
        ids: ids
      }
    }
  }
  let(:search) { {q: "andres"} }
  describe "GET /api/v1/admins" do
    it "should return a status code 200" do
      get api_v1_admins_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET api/v1/admins/:id" do
    context 'when the record exists' do
      before { get api_v1_admin_path(id) }
      it 'should return the admin id' do
        expect(json).not_to be_empty
        expect(json["data"]["id"]).to eq(id)
      end
      it 'should return a status code 200' do
        expect(response).to have_http_status(:ok)
      end

    end
    context 'when the record does not exists'  do
      before { get api_v1_admin_path(-1) }
      it 'should return a status code 404' do
        expect(response).to have_http_status(:not_found)
      end
      it 'should return a error message' do
        expect(json["data"]["error"]).to eq("We can't find a valid record")
      end
    end
  end

  describe "GET api/v1/admins/admins-by-ids" do
    before { get admins_by_ids_api_v1_admins_path, params: valid_attributes }
    it 'should return a status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET api/v1/admins/admins-by-not-ids" do
    before { get admins_by_not_ids_api_v1_admins_path, params: valid_attributes }
    it 'should return a status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET api/v1/admins/admins-by-search" do
    context 'when the request is valid' do
      before { get admins_by_search_api_v1_admins_path, params: search }
      it 'should return a status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the request is not valid' do
      before { get admins_by_search_api_v1_admins_path }
      it 'should return a status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'should return a error message' do
        expect(json["data"]["error"]).to eq("We can't find a parameter to search")
      end
    end
  end
end
