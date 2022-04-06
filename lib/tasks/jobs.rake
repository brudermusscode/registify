namespace :db do
  desc 'Schedule all cron jobs'
  task :schedule_jobs => :environment do
    # load all jobs from app/jobs/*
    glob = Rails.root.join('app', 'jobs', '**', '*_job.rb')

    # loop through all files found by glob variable and require them in subclasses
    # for 'CronJob'-job
    Dir.glob(glob).each { |file| require file }

    # schedule each subclass aka. cron job from CronJob's subclasses
    CronJob.subclasses.each &:schedule
  end
end

# invoke schedule_jobs automatically after every migration and schema load.
%w(db:migrate db:schema:load).each do |task|
  Rake::Task[task].enhance do
    Rake::Task['db:schedule_jobs'].invoke
  end
end