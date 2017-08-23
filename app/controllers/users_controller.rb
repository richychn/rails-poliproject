class UsersController < ApplicationController
  def show
    if current_user.scans.any?
      @last_article = current_user.scans.last.article
    end
  end
end
