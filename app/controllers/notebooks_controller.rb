class NotebooksController < ApplicationController
  def index
    @notebooks = current_user.notebooks
  end

  def show
    @notebook = current_user.notebooks.find(params[:id])
  end
end
