crumb :root do
  link "Home", root_path
end

crumb :courses do
  link "コンテンツ一覧", courses_path
end

crumb :course do |course|
  link course.title, course
  parent :courses
end

crumb :user_thread do |user_thread|
  link user_thread.topic.title, user_thread_path(user_thread)
  parent :course, user_thread.topic.chapter.course
end

crumb :topic do |topic|
  link topic.title, topic_path(topic)
  parent :course, topic.chapter.course
end
