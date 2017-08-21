class UsersController < ApplicationController
  def show
    @last_article = current_user.scans.last.article
  end
end
