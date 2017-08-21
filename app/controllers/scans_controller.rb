class ScansController < ApplicationController

  def create
    if Article.find_by url: params[:url]
      article = Article.find_by url: params[:url]
      Scan.create(user_id: current_user.id, article: article)
    else
      bias = url_bias(params[:url])
      article = Article.create(url: params[:url], bias: bias)
      Scan.create(user_id: current_user.id, article: article)
    end
    if user_signed_in?
      redirect_to user_path(current_user)
    end
  end

  private

  def url_bias(url)
    text = webpage_to_text(url)
  end

  def webpage_to_text(url)
    html_file = open(url)
    html_doc = Nokogiri::HTML(html_file)
    text = ""
    html_doc.search('p').each do |element|
      byebug
      text += element.text
    end
    return text
  end
end
