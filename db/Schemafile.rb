# -*- mode: ruby -*-
# vi: set ft=ruby :
create_table "assistants", force: :cascade do |t|
  t.string "assistant_identifier"
  t.bigint "topic_id", null: false
  t.integer "type"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["topic_id"], name: "index_assistants_on_topic_id"
end

create_table "chapter_progresses", force: :cascade do |t|
  t.bigint "user_id", null: false
  t.bigint "chapter_id", null: false
  t.integer "status"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["chapter_id"], name: "index_chapter_progresses_on_chapter_id"
  t.index ["user_id"], name: "index_chapter_progresses_on_user_id"
end

create_table "chapters", force: :cascade do |t|
  t.string "title"
  t.text "description"
  t.integer "position"
  t.bigint "course_id", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["course_id"], name: "index_chapters_on_course_id"
end

create_table "courses", force: :cascade do |t|
  t.string "title"
  t.text "description"
  t.integer "position"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
end

create_table "messages", force: :cascade do |t|
  t.bigint "user_thread_id", null: false
  t.string "content"
  t.integer "sender_type"
  t.string "message_identifier"
  t.integer "status"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["user_thread_id"], name: "index_messages_on_user_thread_id"
end

create_table "notebooks", force: :cascade do |t|
  t.string "title"
  t.text "content"
  t.bigint "user_id", null: false
  t.bigint "topic_id", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["topic_id"], name: "index_notebooks_on_topic_id"
  t.index ["user_id"], name: "index_notebooks_on_user_id"
end

create_table "solid_cable_messages", force: :cascade do |t|
  t.binary "channel", null: false
  t.binary "payload", null: false
  t.datetime "created_at", null: false
  t.bigint "channel_hash", null: false
  t.index ["channel"], name: "index_solid_cable_messages_on_channel"
  t.index ["channel_hash"], name: "index_solid_cable_messages_on_channel_hash"
  t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
end

create_table "solid_cache_entries", force: :cascade do |t|
  t.binary "key", null: false
  t.binary "value", null: false
  t.datetime "created_at", null: false
  t.bigint "key_hash", null: false
  t.integer "byte_size", null: false
  t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
  t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
  t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
end

create_table "solid_queue_blocked_executions", force: :cascade do |t|
  t.bigint "job_id", null: false
  t.string "queue_name", null: false
  t.integer "priority", default: 0, null: false
  t.string "concurrency_key", null: false
  t.datetime "expires_at", null: false
  t.datetime "created_at", null: false
  t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
  t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
  t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
end

create_table "solid_queue_claimed_executions", force: :cascade do |t|
  t.bigint "job_id", null: false
  t.bigint "process_id"
  t.datetime "created_at", null: false
  t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
  t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
end

create_table "solid_queue_failed_executions", force: :cascade do |t|
  t.bigint "job_id", null: false
  t.text "error"
  t.datetime "created_at", null: false
  t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
end

create_table "solid_queue_jobs", force: :cascade do |t|
  t.string "queue_name", null: false
  t.string "class_name", null: false
  t.text "arguments"
  t.integer "priority", default: 0, null: false
  t.string "active_job_id"
  t.datetime "scheduled_at"
  t.datetime "finished_at"
  t.string "concurrency_key"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
  t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
  t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
  t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
  t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
end

create_table "solid_queue_pauses", force: :cascade do |t|
  t.string "queue_name", null: false
  t.datetime "created_at", null: false
  t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
end

create_table "solid_queue_processes", force: :cascade do |t|
  t.string "kind", null: false
  t.datetime "last_heartbeat_at", null: false
  t.bigint "supervisor_id"
  t.integer "pid", null: false
  t.string "hostname"
  t.text "metadata"
  t.datetime "created_at", null: false
  t.string "name", null: false
  t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
  t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
  t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
end

create_table "solid_queue_ready_executions", force: :cascade do |t|
  t.bigint "job_id", null: false
  t.string "queue_name", null: false
  t.integer "priority", default: 0, null: false
  t.datetime "created_at", null: false
  t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
  t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
  t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
end

create_table "solid_queue_recurring_executions", force: :cascade do |t|
  t.bigint "job_id", null: false
  t.string "task_key", null: false
  t.datetime "run_at", null: false
  t.datetime "created_at", null: false
  t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
  t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
end

create_table "solid_queue_recurring_tasks", force: :cascade do |t|
  t.string "key", null: false
  t.string "schedule", null: false
  t.string "command", limit: 2048
  t.string "class_name"
  t.text "arguments"
  t.string "queue_name"
  t.integer "priority", default: 0
  t.boolean "static", default: true, null: false
  t.text "description"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
  t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
end

create_table "solid_queue_scheduled_executions", force: :cascade do |t|
  t.bigint "job_id", null: false
  t.string "queue_name", null: false
  t.integer "priority", default: 0, null: false
  t.datetime "scheduled_at", null: false
  t.datetime "created_at", null: false
  t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
  t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
end

create_table "solid_queue_semaphores", force: :cascade do |t|
  t.string "key", null: false
  t.integer "value", default: 1, null: false
  t.datetime "expires_at", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
  t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
  t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
end

create_table "source_documents", force: :cascade do |t|
  t.string "title"
  t.bigint "uploaded_by_id", null: false
  t.bigint "assistant_id", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["assistant_id"], name: "index_source_documents_on_assistant_id"
  t.index ["uploaded_by_id"], name: "index_source_documents_on_uploaded_by_id"
end

create_table "topics", force: :cascade do |t|
  t.string "title"
  t.text "question"
  t.text "model_answer"
  t.integer "position"
  t.bigint "chapter_id", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["chapter_id"], name: "index_topics_on_chapter_id"
end

create_table "user_thread_progresses", force: :cascade do |t|
  t.bigint "user_thread_id", null: false
  t.integer "status"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["user_thread_id"], name: "index_user_thread_progresses_on_user_thread_id"
end

create_table "user_threads", force: :cascade do |t|
  t.bigint "user_id", null: false
  t.bigint "topic_id", null: false
  t.string "thread_identifier"
  t.string "latest_run_identifier"
  t.integer "status"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["topic_id"], name: "index_user_threads_on_topic_id"
  t.index ["user_id"], name: "index_user_threads_on_user_id"
end

create_table "user_topic_progresses", force: :cascade do |t|
  t.bigint "user_id", null: false
  t.bigint "topic_id", null: false
  t.integer "status"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["topic_id"], name: "index_user_topic_progresses_on_topic_id"
  t.index ["user_id"], name: "index_user_topic_progresses_on_user_id"
end

create_table "users", force: :cascade do |t|
  t.string "name"
  t.string "email"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.string "password_digest"
  t.string "demo_user_identifier"
end

add_foreign_key "assistants", "topics"
add_foreign_key "chapter_progresses", "chapters"
add_foreign_key "chapter_progresses", "users"
add_foreign_key "chapters", "courses"
add_foreign_key "messages", "user_threads"
add_foreign_key "notebooks", "topics"
add_foreign_key "notebooks", "users"
add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
add_foreign_key "source_documents", "assistants"
add_foreign_key "source_documents", "users", column: "uploaded_by_id"
add_foreign_key "topics", "chapters"
add_foreign_key "user_thread_progresses", "user_threads"
add_foreign_key "user_threads", "topics"
add_foreign_key "user_threads", "users"
add_foreign_key "user_topic_progresses", "topics"
add_foreign_key "user_topic_progresses", "users"
