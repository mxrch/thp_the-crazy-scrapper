require 'nokogiri'
require 'open-uri'
require 'awesome_print'

PAGE = Nokogiri::XML(open("https://www.nosdeputes.fr/deputes/enmandat/xml"))
#Récupère le contenu XML du lien donné

def scraping(page)

	#Nom de famille
	@last_name = []
	page.css("nom_de_famille").each do |name| #Pour chaque nom de famille dans ce sélecteur css
		@last_name << name.text #On l'ajoute dans l'array des noms de famille
	end

	#Prénom
	@first_name = []
	page.css("prenom").each do |name| #Pour chaque prénom dans ce sélecteur css
		@first_name << name.text #On l'ajoute dans l'array des prénoms
	end

	#Email
	@emails = []
	page.css("email[1]").each do |email| #Pour chaque adresse email dans ce sélecteur css
		@emails << email.text #On l'ajoute dans l'array des adresses email
	end
	return makeHash(@first_name, @last_name, @emails) #On fabrique le hash grâce aux trois arrays
end

def makeHash(firstName, lastName, emails) #Permet de construire
	fullList = [] #Va comporter les hashs de tous les députés
	count = 0
	for deputy in count..firstName.length - 1
		if firstName[count] == "Jean-Luc" && lastName[count] == "Poudroux" #Il n'a pas d'adresse email renseignée, donc on gère l'exception
			fullList << {"first_name" => firstName[count], "last_name" => lastName[count], "email" => "Pas d'email renseigné"}
			count += 1
			fullList << {"first_name" => firstName[count], "last_name" => lastName[count], "email" => emails[count - 1]}
			break
		end
		fullList << {"first_name" => firstName[count], "last_name" => lastName[count], "email" => emails[count]} #On range les hashs des députés dans l'array
		count += 1
	end
	return fullList #On retourne l'array contenant tous les députés
end

def perform
	print "Scrapping en cours...                            \r".yellow
	deputies = scraping(PAGE)
	for deputy in deputies
		puts "L'email de #{(deputy["first_name"] + " " + deputy["last_name"]).red} est : #{deputy["email"].yellow}"
	end
end

perform
