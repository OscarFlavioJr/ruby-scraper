require 'sidekiq'
require_relative 'scraper'

class ScraperWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'default'
        
    def perform
       puts "iniciando o trabalho de scraping..."
       result = Scraper.novacoleta()
    puts "Scraping concluído!"
    end
end