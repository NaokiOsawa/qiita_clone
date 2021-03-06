require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    before do
      create_list(:article, 3, status: "published")
    end

    it "公開設定にしている記事一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
      expect(res[0]["user"].keys).to eq ["id", "account", "name"]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したidの記事が存在する場合" do
      let(:article) { create(:article, status: "published") }
      let(:article_id) { article.id }

      it "記事の値が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["id"]).to eq article.id
        expect(res["body"]).to eq article.body
        expect(res["title"]).to eq article.title
        expect(res["updated_at"]).to be_present
        expect(res["status"]).to eq "published"
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"]["account"]).to eq article.user.account
        expect(res["user"]["name"]).to eq article.user.name
      end
    end

    context "指定したidの記事が存在しない場合" do
      let(:article_id) { 1000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "記事が下書きの場合" do
      let(:article) { create(:article, status: "draft") }
      let(:article_id) { article.id }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "公開設定の場合" do
      let(:params) { { article: attributes_for(:article, status: "published") } }

      it "公開設定の記事が作成できる" do
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "published"
        expect(response).to have_http_status(:ok)
      end
    end

    context "下書き設定の場合" do
      let(:params) { { article: attributes_for(:article, status: "draft") } }

      it "下書き設定の記事が作成できる" do
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "draft"
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:article) { create(:article, user: current_user) }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "記事の更新ができる" do
      expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                            change { article.reload.body }.from(article.body).to(params[:article][:body]) &
                            not_change { article.reload.created_at }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article.id), headers: headers) }

    let!(:article) { create(:article, user: current_user) }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "記事の削除ができる" do
      expect { subject }.to change { Article.count }.by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end
