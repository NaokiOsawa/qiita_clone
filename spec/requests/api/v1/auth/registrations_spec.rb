require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "ユーザー登録に必要な情報が正しく送信された時" do
      let(:params) { attributes_for(:user) }

      it "ユーザー登録できる" do
        expect { subject }.to change { User.count }.by(1)
        expect(response.headers["uid"]).to be_present
        expect(response.headers["access-token"]).to be_present
        expect(response.headers["client"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "ユーザー登録に必要な情報が正しく送信されない時(nameがnil)" do
      let(:params) { attributes_for(:user, name: nil) }

      it "ユーザー登録されない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
      end
    end

    context "ユーザー登録に必要な情報が正しく送信されない時(accountがnil)" do
      let(:params) { attributes_for(:user, account: nil) }

      it "ユーザー登録されない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
      end
    end

    context "ユーザー登録に必要な情報が正しく送信されない時(emailがnil)" do
      let(:params) { attributes_for(:user, email: nil) }

      it "ユーザー登録されない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
      end
    end

    context "ユーザー登録に必要な情報が正しく送信されない時(passwordがnil)" do
      let(:params) { attributes_for(:user, password: nil) }

      it "ユーザー登録されない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
      end
    end
  end

  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "登録されているユーザーの必要な情報が正しく送信された時" do
      let(:current_user) { create(:user) }
      let(:params) { { email: current_user.email, password: current_user.password } }
      it "ログインできる" do
        subject
        expect(response.headers["uid"]).to be_present
        expect(response.headers["access-token"]).to be_present
        expect(response.headers["client"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "登録されていないユーザーの情報が送信された時(メールアドレス誤)" do
      let(:current_user) { create(:user) }
      let(:params) { { email: "xxxx", password: current_user.password } }
      it "ログインできない" do
        subject
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "登録されていないユーザーの情報が送信された時(パスワード誤)" do
      let(:current_user) { create(:user) }
      let(:params) { { email: current_user.email, password: "xxxx" } }
      it "ログインできない" do
        subject
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "ログアウトできる" do
      subject
      expect(current_user.reload.tokens).to be_blank
      expect(response.headers["uid"]).to be_blank
      expect(response.headers["access-token"]).to be_blank
      expect(response.headers["client"]).to be_blank
      expect(response).to have_http_status(:ok)
    end
  end
end
