# frozen_string_literal: true

namespace :rp do # rubocop:todo Metrics/BlockLength
  desc "Apply database schema"
  task apply: :environment do
    apply(Rails.env)
    apply("test") if Rails.env.development?
    export(Rails.env)
    Rake::Task["annotate_models"].invoke if Rails.env.development?
  end

  desc "export database schema"
  task export: :environment do
    export(Rails.env)
  end

  desc "Apply database schema for test"
  task apply_for_test: :environment do
    apply("test")
  end

  desc "Apply database schema for parallel_test"
  task apply_for_parallel_test: :environment do
    ParallelTests::Tasks.run_in_parallel([ $PROGRAM_NAME, "ridgepole:apply_for_test" ])
  end

  private

  def apply(rails_env)
    ridgepole("--apply", "-f #{schema_file}", "-E #{rails_env}", "-c #{config_file}", "--drop-table")
  end

  def export(rails_env)
    ridgepole("--export", "-o #{schema_file}", "-E #{rails_env}", "-c #{config_file}")
  end

  def schema_file
    Rails.root.join("db/Schemafile.rb")
  end

  def config_file
    Rails.root.join("config/database.yml")
  end

  def ridgepole(*options)
    command = [ "bundle exec ridgepole" ]
    system([ command + options ].join(" "))
  end
end
