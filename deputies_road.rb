require 'nokogiri'
require 'open-uri'
require 'awesome_print'

PAGE_URL = Nokogiri::XML(open("https://www.nosdeputes.fr/deputes/enmandat/xml"))

def scraping(page)

	#Nom de famille
	@last_name = []
	page.css("nom_de_famille").each do |name|
		@last_name << name.text
	end

	#Prénom
	@first_name = []
	page.css("prenom").each do |name|
		@first_name << name.text
	end

	#Email
	@emails = []
	page.css("email[1]").each do |email|
		@emails << email.text
	end
	return makeHash(@first_name, @last_name, @emails)
end

def makeHash(firstName, lastName, emails)
	fullList = []
	count = 0
	for deputy in count..firstName.length - 1
		if firstName[count] == "Jean-Luc" && lastName[count] == "Poudroux"
			fullList << {"first_name" => firstName[count], "last_name" => lastName[count], "email" => "Pas d'email renseigné"}
			count += 1
			fullList << {"first_name" => firstName[count], "last_name" => lastName[count], "email" => emails[count - 1]}
			break
		end
		fullList << {"first_name" => firstName[count], "last_name" => lastName[count], "email" => emails[count]}
		count += 1
	end
	return fullList
end

def perform
	print "Scrapping en cours...                            \r".yellow
	deputies = scraping(PAGE_URL)
	for deputy in deputies
		puts "L'email de #{(deputy["first_name"] + " " + deputy["last_name"]).red} est : #{deputy["email"].yellow}"
	end
end

perform
