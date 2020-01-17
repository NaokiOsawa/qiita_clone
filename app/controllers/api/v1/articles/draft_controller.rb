class Api::V1::Articles::DraftController < Api::V1::ApiController
  def index
    articles = Article.draft
    render json: articles
  end

  def show
    article = Article.draft.find(params[:id])
    render json: article
  end
end
