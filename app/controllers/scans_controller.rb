require 'open-uri'
require 'nokogiri'
require "google/cloud/language"

PROJECT_ID = "mywissen-177218"

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
    syntax = text_analysis(text)
    total = syntax.tokens.count
    nouns = 0
    syntax.tokens.each do |token|
      nouns += 1 if token.part_of_speech.tag == :NOUN
    end
    return nouns.to_f / total
  end

  def webpage_to_text(url)
    html_file = open(url)
    html_doc = Nokogiri::HTML(html_file)
    text = ""
    html_doc.search('p').each do |element|
      text += element.text
    end
    return text
  end

  def text_analysis(text)
    language  = Google::Cloud::Language.new project: PROJECT_ID
    document  = language.document text
    return document.syntax
  end

end
