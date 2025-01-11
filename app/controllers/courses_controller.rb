class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(params.require(:course).permit(:title, :description, :position))
    if @course.save
      CreateCourseContentsJob.perform_later(course_id: @course.id, user_id: current_user.id)
      render turbo_stream: turbo_stream.action(:redirect, course_path(@course))
    else
      flash[:danger] = "Course not created!"
      render :new, status: :unprocessable_content
    end
  end

  private

  def course_params
    params.require(:course).permit(:title, :description, :position)
  end
end
