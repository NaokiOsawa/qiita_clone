require "rails_helper"

RSpec.describe User, type: :model do
  describe "正常系のテスト" do
    context "account,password,name,emailが指定されている場合" do
      let(:user) { build(:user) }
      it "ユーザーが作られる" do
        expect(user).to be_valid
      end
    end
  end

  describe "異常系のテスト" do
    context "accountが指定されていない場合" do
      let(:user) { build(:user, account: nil) }
      it "エラーする(can't be blank)" do
        user.valid?
        expect(user.errors.messages[:account]).to include "can't be blank"
      end
    end

    context "同名のaccountが既に存在する場合" do
      before { create(:user, account: "naoki681") }

      let(:user) { build(:user, account: "naoki681") }
      it "エラーする(has already been taken)" do
        user.valid?
        expect(user.errors.messages[:account]).to include "has already been taken"
      end
    end

    context "nameが指定されていない場合" do
      let(:user) { build(:user, name: nil) }
      it "エラーする(can't be blank)" do
        user.valid?
        expect(user.errors.messages[:name]).to include "can't be blank"
      end
    end
  end
end
