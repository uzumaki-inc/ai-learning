Rake::Task["db:migrate"].enhance do
  Rake::Task["rp:export"].invoke
end
