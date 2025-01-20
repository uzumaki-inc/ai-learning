# == Schema Information
#
# Table name: topics
#
#  id           :integer          not null, primary key
#  title        :string
#  question     :text
#  model_answer :text
#  position     :integer
#  chapter_id   :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_topics_on_chapter_id  (chapter_id)
#

class Topic < ApplicationRecord
  belongs_to :chapter
  has_one :course, through: :chapter
  has_one :assistant, dependent: :destroy
  has_many :user_topic_progresses, dependent: :destroy

  # AIとのチャットを始めるメソッド
  def start_by!(user)
    target_user_thread = UserThread.find_by(user_id: user.id, topic_id: id)
    # すでにスレッド作成済みの場合は処理中断
    # TODO: 仮に今後何度も同じトピックを開始できるようにする場合はこの条件分岐を削除する
    return if target_user_thread.present?

    new_user_thread, user_message, assistant_message = transaction do
      # チャプターごとの進捗は現時点ではいらないのでコメントアウト
      # chapter_progress = ChapterProgress.find_or_create_by!(user_id: user.id, chapter_id: chapter.id) do |chapter_progress|
      #   chapter_progress.status = :in_progress
      # end
      UserTopicProgress.find_or_create_by!(user_id: user.id, topic_id: id)
      user_thread = UserThread.create!(user_id: user.id, topic_id: id, status: :unprocessed).tap do |user_thread|
        UserThreadProgress.create!(user_thread: user_thread, status: :in_progress)
      end

      user_message = Message.create!(content: "理解度の確認を開始。ハルシネーションは起こさないでください。", sender_type: :user, user_thread_id: user_thread.id, status: :completed)
      assistant_message = Message.create!(content: "", sender_type: :assistant, user_thread_id: user_thread.id, status: :before_processing)
      [user_thread, user_message, assistant_message]
    end

    PostMessageToAiJob.perform_later(user_message_id: user_message.id, assistant_message_id: assistant_message.id)
    new_user_thread
  end

  def create_open_ai_assistant
    Assistant.create_open_ai_assistant(self)
  end
end
