require 'rails_helper'

RSpec.describe "Moments", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/moments/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/moments/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/moments/index"
      expect(response).to have_http_status(:success)
    end
  end

end
