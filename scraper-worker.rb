require 'sidekiq'
require_relative 'scraper'

class ScraperWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    puts "Iniciando o trabalho de scraping..."
    Scraper.novacoleta 
    puts "Scraping concluído!"
  end
end
