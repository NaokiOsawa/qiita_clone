require "rails_helper"

RSpec.describe Article, type: :model do
  describe "正常系のテスト" do
    context "body,titleが指定されている場合" do
      let(:article) { build(:article) }
      it "記事が作られる" do
        expect(article).to be_valid
      end
    end
    context "body,title,下書きが設定されている場合" do
      let(:article) { build(:article, status: 0) }
      it "下書き設定した記事が作られる" do
        expect(article).to be_valid
        expect(article.status).to eq "draft"
      end
    end
    context "body,title,公開が設定されている場合" do
      let(:article) { build(:article, status: 1) }
      it "公開設定した記事が作られる" do
        expect(article).to be_valid
        expect(article.status).to eq "published"
      end
    end
  end

  describe "異常系のテスト" do
    context "bodyが指定されていない場合" do
      let(:article) { build(:article, body: nil) }
      it "エラーする(can't be blank)" do
        article.valid?
        expect(article.errors.messages[:body]).to include "can't be blank"
      end
    end

    context "titleが指定されていない場合" do
      let(:article) { build(:article, title: nil) }
      it "エラーする(can't be blank)" do
        article.valid?
        expect(article.errors.messages[:title]).to include "can't be blank"
      end
    end
  end
end
