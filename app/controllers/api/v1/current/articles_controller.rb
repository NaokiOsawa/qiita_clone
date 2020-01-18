class Api::V1::Current::ArticlesController < Api::V1::ApiController
  before_action :authenticate_user!, only: [:index, :show]

  def index
    articles = current_user.articles.published
    render json: articles
  end

  def show
    article = current_user.articles.published.find(params[:id])
    render json: article
  end
end
