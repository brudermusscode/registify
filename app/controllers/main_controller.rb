class MainController < ApplicationController
  def index
    @lists_count = List.all.count
    @users_count = User.all.count
  end
end
