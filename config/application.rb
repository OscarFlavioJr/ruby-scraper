require 'sidekiq'
require 'sidekiq-cron'

redis_url = ENV['REDIS_URL'] || raise("Environment variable REDIS_URL is not set")
redis_namespace = 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url, namespace: redis_namespace }

  schedule_file = File.expand_path("../config/sidekiq.yml", __FILE__)
  schedule_file_exists = File.exist?(schedule_file)

  config.on(:startup) do
    if schedule_file_exists
      Sidekiq::Cron::Job.load_from_hash YAML.safe_load(File.read(schedule_file), permitted_classes: [Symbol])
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
