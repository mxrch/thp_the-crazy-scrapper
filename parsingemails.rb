require 'nokogiri'
require 'open-uri'
require "awesome_print"

PAGE = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
#Récupère le contenu HTML du lien donné

def get_the_email_of_a_townhal_from_its_webpage(page) #Récupère l'email de la mairie du lien donné
  text = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text #Récupère l'email
  if text != "" #Si il y a un email
    return text #Le retourner
  else #Sinon
    return "AUCUN EMAIL" #Retourner "AUCUN EMAIL"
  end
end

def get_all_the_urls_of_val_doise_townhalls(page) #Récupére les liens des mairies de Val d'Oise
  url = page.chomp("val-d-oise.html") #On garde juste la racine du lien
  municipalities = [] #Pour stocker tous les hashs des villes
  count = 0.0
  page.css("a.lientxt").each do |municipality| #On récupère chaque ville grâce à un sélecteur css
    municipalities << {"name" => municipality.text, "email" => get_the_email_of_a_townhal_from_its_webpage(url + municipality['href'].sub!("./", ""))}
    #Ci-dessus, on stock le nom de la ville dans "name" et l'email dans "email"
    #On appelle la fonction qui va récupérer une adresse email d'une ville, avec l'url fabriquée grâce à la racine + le lien de la page de la ville
    print "Scrapping : #{((count / page.css("a.lientxt").size) * 100).to_i}%   (Municipality : #{municipality.text.red})             \r".yellow
    #On fait un pourcentage de progression grâce à un produit en croix
    count += 1
  end
  return municipalities #On retourne tous les hashs des villes
end

def perform
  municipalities = get_all_the_urls_of_val_doise_townhalls(PAGE)
  for municipality in municipalities #Pour chaque hash de ville dans la liste
    puts "L'email de la mairie de #{municipality["name"].red} est : #{municipality["email"].yellow}"
  end
end

perform
