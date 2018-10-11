require 'nokogiri'
require 'open-uri'
require "awesome_print"

PAGE_URL = "http://annuaire-des-mairies.com/val-d-oise.html"

def get_the_email_of_a_townhal_from_its_webpage(page)
  page = Nokogiri::HTML(open(page))
  text = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
  if text != ""
    return text
  else
    return "AUCUN EMAIL"
  end
end

def get_all_the_urls_of_val_doise_townhalls(page)
  url = page.chomp("val-d-oise.html")
  page = Nokogiri::HTML(open(page))
  municipalities = []
  count = 0.0
  page.css("a.lientxt").each do |municipality|
    municipalities << {"name" => municipality.text, "email" => get_the_email_of_a_townhal_from_its_webpage(url + municipality['href'].sub!("./", ""))}
    print "Scrapping : #{((count / page.css("a.lientxt").size) * 100).to_i}%   (Municipality : #{municipality.text.red})             \r".yellow
    count += 1
  end
  return municipalities
end

def perform
  municipalities = get_all_the_urls_of_val_doise_townhalls(PAGE_URL)
  for municipality in municipalities
    puts "L'email de la mairie de #{municipality["name"].red} est : #{municipality["email"].yellow}"
  end
end

perform
