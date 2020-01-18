require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }
    let!(:article1) { create(:article, user: current_user, status: "draft") }
    let!(:article2) { create(:article, user: current_user, status: "published") }
    let!(:article3) { create(:article, user: current_user, status: "published") }
    let!(:article4) { create(:article, status: "draft") }
    let!(:article5) { create(:article, status: "published") }

    it "ログインユーザーの公開設定にしている記事一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 2
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
      expect(res[0]["user"].keys).to eq ["id", "account", "name"]
      expect(response).to have_http_status(:ok)
    end
  end
end
