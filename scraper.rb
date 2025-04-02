require "httparty"
require "nokogiri"
require "selenium-webdriver"

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
puts "#{num_vagas} disponíveis, sendo elas:"

vagas = document.css("div.informacoes-header")

vagas.each do |vaga|
  cargo = vaga.at_css("h2.cargo")&.text&.strip
  link = vaga.at_css("h2.cargo a.link-detalhes-vaga")&.[]("href")

  puts "Cargo: #{cargo}"
  puts "Link: https://www.vagas.com.br#{link}"
end

driver.quit
