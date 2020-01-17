require 'rails_helper'

RSpec.describe "Api::V1::Articles::Draft", type: :request do
  describe "GET /api/v1/articles/draft" do
    subject { get(api_v1_articles_draft_index_path, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }
    let!(:article1){ create(:article, user: current_user, status:"draft")}
    let!(:article2){ create(:article, user: current_user, status:"draft")}
    let!(:article3){ create(:article, user: current_user, status:"published")}
    let!(:article4){ create(:article, status:"draft")}
    let!(:article5){ create(:article, status:"published")}

    it "ログインユーザーの下書き設定にしている記事一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 2
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
      expect(res[0]["user"].keys).to eq ["id", "account", "name"]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/articles/draft/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    context "ログインユーザーの指定したidの下書き記事が存在する場合" do
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }
      let(:article) { create(:article, user: current_user, status: "draft") }
      let(:article_id) { article.id }

      it "記事の値が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["id"]).to eq article.id
        expect(res["body"]).to eq article.body
        expect(res["title"]).to eq article.title
        expect(res["updated_at"]).to be_present
        expect(res["status"]).to eq "draft"
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"]["account"]).to eq article.user.account
        expect(res["user"]["name"]).to eq article.user.name
      end
    end

    context "ログインユーザーの指定したidの下書き記事が存在しない場合" do
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }
      let(:article_id) { 1000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "ログインユーザーの指定したidの記事が公開設定の場合" do
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }
      let(:article) { create(:article, user: current_user, status: "published") }
      let(:article_id) { article.id }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "ログインユーザー以外の指定したidの記事の場合" do
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

  end

end
