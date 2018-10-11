require 'nokogiri'
require 'open-uri'
require 'awesome_print'

PAGE = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all"))
#Récupère le contenu HTML du lien donné

def prices(page) #Récupère le cours des cryptomonnaies
  @prices = []
  page.css("a.price").each do |price| #Pour chaque prix dans ce sélecteur css
    @prices << price.text #On les range dans un array
  end
  return @prices #On retourne l'array des prix
end

def cryptos(page) #Récupère les noms des cryptomonnaies
  @cryptos = []
  page.css("a.currency-name-container").each do |crypto| #Pour chaque cryptomonnaie dans ce sélecteur css
    @cryptos << crypto.text #On les range dans un array
  end
  return @cryptos #On retourne l'array des noms des cryptomonnaies
end

def loop(page)
  begin
    while 1 #Boucle infinie
      hash = Hash[cryptos(page).zip(prices(page))] #On récupère les cryptomonnaies avec leur cours (prix)
      for crypto in hash.keys #Pour chaque cryptomonnaie dans le hash
        puts "Le cours de la cryptomonnaie #{crypto.red} est à : #{hash[crypto].yellow}" #On affiche son nom et son prix
      end
      print "\n\n" #On espace un peu l'affichage
      timer = 3600 #Est égal à 1 heure
      for second in 0..timer #Chaque seconde
        print "Actualisation dans : #{Time.at(timer).utc.strftime("%H:%M:%S").red}   #{"[CTRL-C pour quitter]".yellow}\r"
        #Actualiser le timer
        sleep(1) #Attendre une seconde
        timer -= 1 #Soustraire la seconde aux secondes restantes
      end
      puts "Actualisation en cours...                            ".yellow
      #Quand c'est fini, on recommence les instructions pour actualiser
    end
  rescue Interrupt #Si l'utilisateur fait CTRL-C
    puts "\n\nAu revoir !".green
  end
end

def perform
  print "Scrapping en cours...                            \r".yellow
  loop(PAGE) #On lance la boucle infinie pour actualiser toutes les heures
end

perform
