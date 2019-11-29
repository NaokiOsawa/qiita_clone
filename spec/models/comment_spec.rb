require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "正常系のテスト" do
    context "bodyが指定されている場合" do
      let(:comment) { build(:comment) }
      it "コメントが作られる" do
        expect(comment).to be_valid
      end
    end
  end

  describe "異常系のテスト" do
    context "bodyが指定されていない場合" do
      let(:comment) { build(:comment, body: nil) }
      it "エラーする(can't be blank)" do
        comment.valid?
        expect(comment.errors.messages[:body]).to include "can't be blank"
      end
    end
  end
end
