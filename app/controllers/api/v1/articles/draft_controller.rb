class Api::V1::Articles::DraftController < Api::V1::ApiController
  before_action :authenticate_user!, only: [:index, :show]

  def index
    articles = current_user.articles.draft
    render json: articles
  end

  def show
    article = current_user.articles.draft.find(params[:id])
    render json: article
  end
end
