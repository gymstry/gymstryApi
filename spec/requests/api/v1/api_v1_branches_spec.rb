require 'rails_helper'

RSpec.describe "Api::V1::Branches", type: :request do
  let!(:branches) {create_list(:branch,10)}
  let(:id) {branches.first.id}
  let(:ids) { [branches[0].id,branches[1].id] }
  let(:valid_attributes) {
    {
      branch: {
        ids: ids
      }
    }
  }
  let(:search) { {q: "andres"} }
  describe "GET /api/v1/branches" do
    it "should return a status code 200" do
      get api_v1_branches_path
      expect(response).to have_http_status(:ok)
    end
  end
  describe "GET /api/v1/branches/:id" do
    before {get api_v1_branch_path(id) }
    context "when the record exists" do
      it 'should return the branch id' do
        expect(json).not_to be_empty
        expect(json["data"]["id"]).to eq(id)
      end
      it 'should return a status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end
    context "when the record does not exists" do
      before { get api_v1_branch_path(-1) }
      it 'should return a status code 404' do
        expect(response).to have_http_status(:not_found)
      end
      it 'should return a error message' do
        expect(json["data"]["error"]).to eq("We can't find a valid record")
      end
    end
  end

  describe "GET /api/v1/branches/branches-by-ids" do
    before {get branches_by_ids_api_v1_branches_path, params: valid_attributes}
    it 'should return a status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/branches/branches-by-not-ids" do
    before {get branches_by_not_ids_api_v1_branches_path, params: valid_attributes}
    it 'should return a status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/branches/branches-by-search" do
    context "when the request is valid" do
      before { get branches_by_search_api_v1_branches_path, params: search }
      it 'should return a status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end
    context "when the request is not valid" do
      before { get branches_by_search_api_v1_branches_path }
      it 'should return a status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'should return a error message' do
        expect(json["data"]["error"]).to eq("We can't find a parameter to search")
      end
    end
  end

  describe "GET /api/v1/branches/branches-with-events" do
    before { get branches_with_events_api_v1_branches_path }
    it 'should return a status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/branches/branches-with-trainers" do
    before { get branches_with_trainers_api_v1_branches_path }
    it 'should return a status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/branches/branches-with-timetables" do
    before { get branches_with_timetables_api_v1_branches_path }
    it 'should return a status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/branches/branches-with-users" do
    before { get branches_with_users_api_v1_branches_path }
    it 'should return a status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/branches/branches-with-events-date" do
    before { get branches_with_events_date_api_v1_branches_path }
    it 'should return a status code 200' do
      expect(response).to have_http_status(:ok)

    end
  end
end
