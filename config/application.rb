require 'sidekiq'
require 'sidekiq-cron'

redis_url = ENV['REDIS_URL']

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }

  config.on(:startup) do
    schedule_file = File.expand_path("../config/sidekiq.yml", __FILE__)

    if File.exist?(schedule_file)
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
