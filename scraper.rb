require "httparty"
require "nokogiri"
require "selenium-webdriver"
require "json"

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument("--headless") 
driver = Selenium::WebDriver.for :chrome, options: options
driver.navigate.to "https://www.vagas.com.br/vagas-de-Fleury"

sleep 3  

while true
  begin
    button = driver.find_element(id: "maisVagas")
    driver.execute_script("arguments[0].scrollIntoView();", button)
    button.click
    sleep 2  
  rescue Selenium::WebDriver::Error::NoSuchElementError
    puts "Todas as vagas foram carregadas!"
    break
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    puts "Elemento atualizado, tentando novamente..."
    next
  end
end    

html = driver.page_source
document = Nokogiri::HTML(html)

num_vagas = document.at_css("div.faixa.clearfix h1")&.text&.strip

vagas = document.css("div.informacoes-header")

vagas.each do |vaga|
  cargo = vaga.at_css("h2.cargo")&.text&.strip
  link = vaga.at_css("h2.cargo a.link-detalhes-vaga")&.[]("href")
  
  puts "Cargo: #{cargo}"
  puts "Link: https://www.vagas.com.br#{link}"
  
  File.open("vagas.json", "w") do |f|
    f.write(JSON.pretty_generate(vagas.map do |vaga|
      {
        cargo: vaga.at_css("h2.cargo")&.text&.strip,
        link: "https://www.vagas.com.br#{vaga.at_css("h2.cargo a.link-detalhes-vaga")&.[]("href")}"
      }
    end))
  end
end

puts "#{num_vagas} disponíveis"
driver.quit
