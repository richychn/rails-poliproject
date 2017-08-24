require 'open-uri'
require 'nokogiri'
# require "google/cloud/language"

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
    if scan_text(text) < 0.79
      return true
    else
      return false
    end
    # syntax = text_analysis(text)

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

  # def text_analysis(text)
  #   language  = Google::Cloud::Language.new project: PROJECT_ID
  #   document  = language.document text
  #   return document.syntax
  # end

  def scan_text(text)
    array = text_to_array(text)
    total = array.length
    # array = rm_stop_words!(array)
    nouns = no_of_part_hash2(array, "N")
    p nouns / total.to_f
    return nouns / array.length.to_f
  end

  def text_to_array(text)
    array = text.downcase.gsub(/[^a-z0-9\s]/i, " ").split
    return array
  end

  def no_of_part_hash2(array, part)
    pool = ThreadPool.new(size: 200)
    nhash = frequency(array)
    pool.schedule do
      nhash.each do |key, value|
        nhash[key] = 0 unless check(key, part)
      end
    end
    pool.shutdown
    return nhash.values.inject(&:+)
  end
end
