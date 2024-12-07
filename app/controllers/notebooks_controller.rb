class NotebooksController < ApplicationController
  def index
    @notebooks = current_user.notebooks
  end
end
