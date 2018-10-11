require 'nokogiri'
require 'open-uri'
require 'awesome_print'

PAGE_URL = "https://coinmarketcap.com/all/views/all"

def prices(page)
  page = Nokogiri::HTML(open(page))
  @prices = []
  page.css("a.price").each do |price|
    @prices << price.text
  end
  return @prices
end

def cryptos(page)
  page = Nokogiri::HTML(open(page))
  @cryptos = []
  page.css("a.currency-name-container").each do |crypto|
    @cryptos << crypto.text
  end
  return @cryptos
end

def loop(page)
  while 1
    hash = Hash[cryptos(page).zip(prices(page))]
    for crypto in hash.keys
      puts "Le cours de la cryptomonnaie #{crypto.red} est à : #{hash[crypto].yellow}"
    end
    print "\n\n"
    count = 3600
    for second in 0..count
      print "Actualisation dans : #{Time.at(count).utc.strftime("%H:%M:%S").red}   #{"[CTRL-C pour quitter]".yellow}\r"
      sleep(1)
      count -= 1
    end
    puts "Actualisation en cours...                            ".yellow
  end
end

def perform
  print "Scrapping en cours...                            \r".yellow
  loop(PAGE_URL)
end

perform
