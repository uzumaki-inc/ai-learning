require 'csv'

course = Course.create(
  title: 'パーソナルトレーナー研修',
  description: 'パーソナルトレーナーになるための研修です。',
  position: 1
)



CSV.foreach('db/fixtures/training.csv', headers: true) do |row|
  chapter = Chapter.find_or_create_by!(title: row['chapter'], course: course)
  topic = Topic.find_or_create_by!(title: row['topic_title'], question: row['topic_question'], model_answer: row['model_answer'], chapter: chapter)
end

course = Course.create(
  title: 'Webエンジニア研修',
  description: 'Webエンジニアになるための研修です。',
  position: 1
)

CSV.foreach('db/fixtures/web.csv', headers: true) do |row|
  chapter = Chapter.find_or_create_by!(title: row['chapter'], course: course)
  topic = Topic.find_or_create_by!(title: row['topic_title'], question: row['topic_question'], model_answer: row['model_answer'], chapter: chapter)
end
