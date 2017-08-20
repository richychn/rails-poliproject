class ScansController < ApplicationController
  def create
    if Article.find_by url: params[:url]
      article = Article.find_by url: params[:url]
      Scan.create(user_id: current_user.id, article_id: article.id)
    else
      article = Article.create(url: params[:url], bias: true)
    end
  end
end
