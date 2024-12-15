class CreateCourseContentsJob < ApplicationJob
  queue_as :default

  def perform(course_id:, user_id:)
    course = Course.find(course_id)
    course.create_chapter_and_topics
    course.broadcast_contents_created(user_id:)
  end
end
