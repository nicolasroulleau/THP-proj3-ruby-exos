# https://www.thehackingproject.org/week/2/day/1

DEBUG = false # les guys, histoire de capter un peu mon code, vous pouvez mettre à true pour afficher quelques "explications" sur la console

# 1. Multiples de 3 et 5
def multiples(range)
  total = 0
  range.times { |num| total += num if (num % 3 == 0 or num % 5 == 0) }
  total
end

# 2. Chiffrer des données
# Vous pouvez faire ça plus court / bien mieux probablement (encore une fois, il y a N solutions) mais le code qui suit a pour vocation de "montrer" une méthode que je propose pour démarrer d'une page blanche
# = "découpage" fonctionnel (ou très caricaturalemet, les fondamentaux de l'algorithmie), évoquée à ceux / celles qui étaient au debrief journalier (= les boîtes avec les entrées / sorties, etc.)
def chiffre_de_cesar(string, offset)
  return string if offset == 0 # ne pas consommer de ressources si ce n'est pas nécessaire (même si ce n'est pas impactant ici, c'est une bonne pratique dans d'autres contextes) ... le return force la sortie ... peut-être qu'il y a moyen de faire plus propre en Ruby ... wait & see !
  result = "" # initialisation de la variable dans laquelle sera concaténée la lettre décalé ou le signe (de ponctuation) non modifié
  offset = offset % 26 if offset % 26 > 0 # des fois que l'offset passé soit supérieur à l'intervalle "autorisé" (quelque soit la "philophosie" de Ruby sur la question ... VÉRIFIEZ la validité/conformité des paramètres reçus est TOUJOURS une bonne pratique)
  string.each_byte do |char_code| # itérations (= je boucle) sur chaque lettre de la chaîne (byte = 2 puissance 8 = 0 à 255 = ASCII = 1 charactère) ... char_code = le code ASCII de la lettre et non la lettre elle-même
    letter = char_code.chr # je gère le cas par défaut ... les exceptions au cas général viennent ensuite ... ex.: 65.chr renvoie 'A' donc letter "contient" désormais la valeur 'A'
    if (char_code > 64 and char_code < 90) or (char_code > 96 and char_code < 123) # Si c'est une lettre : A-Z => 65-90 et a-z => 97-122
      if (char_code > 64 and char_code < 90) # Si c'est une minuscule
        if char_code + offset > 90 # Si on dépasse la lettre 'Z' ... (u passage, on évite l'affichage de signes "bizarres")
          new_char_code = char_code + offset - 26 # ... bah on revient en arrière (comme si on avait "bouclé sur l'alphabet")
        elsif char_code + offset < 65 # Si on reçoit un offset négatif (décalage vers la gauche) ...
          new_char_code = char_code + offset + 26 # ... bah on s'assure de "remonter" sur les bonnes valeurs
        else # sinon c'est que l'addition de l'index (ex.: A = 65) et du décalage (offset = 1) reste dans la plage des 26 lettres de l'alphabet (et pas 27 comme je l'avais écrit précédemment ... Alzheimer que je vous dis !)
          new_char_code = char_code + offset
        end
      else # (char_code > 96 and char_code < 123)  # Si c'est une majuscule ... bah c'est la même logique que précédemment (on aurait pu mixer les 2) ... mais là on y va step-by-step ... pour les mordus du code le plus short (et le plus incompréhensible) ... il y a 2 / 3 trucs qui devraient vous titiller par la suite !
        if char_code + offset > 122
          new_char_code = char_code + offset - 26
        elsif char_code + offset < 97
          new_char_code = char_code + offset + 26
        else
          new_char_code = char_code + offset
        end
      end
      letter = new_char_code.chr #maintenant qu'on a fini de faire tous les p'tits calculs pour décaller le code numérique correspondant à la lettre ... bah on reconvertit en charactère (string)!
    end
    result << letter # ... et on stocke le résultat de cette boucle à la suite des résultats précédent => on est en train de "réécrire" la string d'origine = de la crypter !
  end
  result # J'ai enlevé le return vu qu'on m'a dit que ce n'était pas nécessaire / souhaité
end

# 3. Stock picker
# On pourrait raccourcir mais les étapes intermédiaires rendent plus lisible le code
# (ex.: delay_to_sell_at_best n'est utile que pour afficher le message dans chaque tour de boucle)
def trader_du_dimanche(prices)
  puts "[DEBUG] trader_du_dimanche()> prices: #{prices}" if DEBUG
  best_deal = []
  delay_to_sell_at_best = nil
  earnings = []
  max_earnings = []

  prices.each_with_index do |buying_price, day_index|
    # notation << est équivalente à earnings[day_index] = prices...
    earnings << prices[day_index..-1].map { |selling_price| selling_price - buying_price > 0 ? selling_price - buying_price : 0 }
    max_earnings << earnings[day_index].max # pour chaque jour d'achat possible ... bah on stocke le gain max possible sur les jours suivants
    delay_to_sell_at_best = earnings[day_index].index(earnings[day_index].max) # au passage on en profite pour récupérer l'index du jour réalisant le max de gain
    best_deal << { buy_index: day_index, sell_delay: delay_to_sell_at_best, earning: earnings[day_index].max } # on stocke toutes ses infos dans un tableau (chaque 'ligne' = chaque jour) de hash
    if DEBUG # ça c'est pour aider les potes à comprendre en affchant quelques infos à chaque tour de boucle
      puts
      puts "[DEBUG] trader_du_dimanche()> current day index = #{day_index}"
      puts "[DEBUG] trader_du_dimanche()> prices    = #{prices[day_index..-1]}"
      puts "[DEBUG] trader_du_dimanche()> earnings  = #{earnings[day_index]}"
      # puts "[DEBUG] trader_du_dimanche()> best     = #{earnings[day_index].max} on day #{delay_to_sell_at_best}"
      puts "[DEBUG] trader_du_dimanche()> best deal = #{best_deal[day_index]}"
    end
  end
  best_day_to_buy = max_earnings.index(max_earnings.max)
  best_day_to_sell = best_day_to_buy + best_deal[best_day_to_buy][:sell_delay]
  if DEBUG
    puts
    puts "[DEBUG] trader_du_dimanche()> max_earnings: #{max_earnings}"
    puts "[DEBUG] trader_du_dimanche()> max_earning #{max_earnings.max} bying on day #{best_day_to_buy}"
    puts "[DEBUG] trader_du_dimanche()> deal : buy on day #{best_deal[best_day_to_buy][:buy_index]}, waiting #{best_deal[best_day_to_buy][:sell_delay]} day(s) (= selling on day #{best_day_to_sell}), to earn #{best_deal[best_day_to_buy][:earning]}"
    puts "[WARNG] trader_du_dimanche()> remember indexes start at 0 ! so day #{best_day_to_sell} is day #{(best_day_to_sell + 1)} 'for real'"
  end
  return best_day_to_buy, best_day_to_sell
end

# 3. Stock picker (LVL UP)
# Le développeur du dimanche étant également un fainéant, il compte utiliser son code précédent pour rester heureux !
def select_values_by_key(array, key_to_search) # ce qui suit est moche, mais j'ai commencé Ruby aujourd'hui ... donc merci d'être tolérant ! Ya probablement moyen d'étendre la classe array ... TBD
  array.map { |line| (line.select { |key, value| key == key_to_search })[key_to_search]}
end

def trader_du_lundi(prices) # je vais transformer le tableau de hash en hash de tableaux pour pouvoir réutliser le code précédent (trader_du_dimanche qui prend un tableau en paramètre)
  best_deals = Hash.new
  companies = prices[0].keys # on récupère le "nom" de boîtes grace aux clés du premier hash (= la première ligne du tableau de prix)
  puts "[DEBUG] trader_du_lundi()> companies : #{companies}" if DEBUG
  # Je laisse ça pour que vous compreniez comment "extraire" un clé du hash sur toutes les lignes du tableau !
  # company_prices = select_values_by_key(prices, :GOO)
  # puts "[DEBUG] companies : #{company_prices}"
  companies_prices = Hash[companies.map {|column| [column, select_values_by_key(prices, column)]}] # Comme prévu, ee construits un hash qui stock les prix correspondant à une entreprise donnée (qui sera la clé du hash)
  companies.each do |company|
    best_deals[company] = trader_du_dimanche(companies_prices[company])
    puts "[INFOS] Best deal for #{company}: buy at day #{best_deals[company][0] + 1}, sell at day #{best_deals[company][1] + 1}"
  end
  return best_deals
end

def jean_michel_data(string, dictionary)

end

# THP - Exos
# Exo 1
range = 1000
puts "\n[DEBUG] main()> using multiples: Multiples of 3 and 5 within #{range}: #{multiples(range)}"

# Exo 1
string = "What a string!"
offset = 3
puts "\n[DEBUG] main()> using chiffre_de_cesar: Encrypted with Cesar's method (offset = #{offset}): #{chiffre_de_cesar(string, offset)}"
offset = 29 # résultat identique à précédemment (29 - 26 = 3 !) = gestion des entiers provoquant une sortie de l'intervalle  (= les 26 lettres de l'alphabet)
# On aurait pu prévoir de provoquer une erreur en fonction de la valeur passée ... c'est d'ailleurs au programme de demain !
puts "[DEBUG] main()> using chiffre_de_cesar: Encrypted with Cesar's method (offset = #{offset}): #{chiffre_de_cesar(string, offset)}"
offset = -1 # décalage vers la gauche
puts "[DEBUG] main()> using chiffre_de_cesar: Encrypted with Cesar's method (offset = #{offset}): #{chiffre_de_cesar(string, offset)}"
offset = -53 # c'est la même chose que -1 ... puisque 26 + 26 + 1 = 53
puts "[DEBUG] main()> using chiffre_de_cesar: Encrypted with Cesar's method (offset = #{offset}): #{chiffre_de_cesar(string, offset)}"

# Exo 3
prices = [17,3,6,9,15,8,6,1,10]
best_day_buy, best_day_sell = trader_du_dimanche(prices)
puts "\n[DEBUG] main()> using trader_du_dimanche: You should buy on day #{best_day_buy} and sell on day #{best_day_sell}"
puts

prices = [
 { :GOO => 15, :MMM => 14, :ADBE => 12, :EA=> 13, :BA => 8, :KO => 10, :XOM => 20, :GPS => 7, :MCD => 11, :DIS => 15, :CRM => 6, :JNJ => 10 },
 { :GOO => 8, :MMM => 20, :ADBE => 3, :EA=> 10, :BA => 5, :KO => 19, :XOM => 12, :GPS => 6, :MCD => 15, :DIS => 9, :CRM => 10, :JNJ => 17 },
 { :GOO => 3, :MMM => 8, :ADBE => 15, :EA=> 5, :BA => 10, :KO => 5, :XOM => 15, :GPS => 13, :MCD => 10, :DIS => 18, :CRM => 5, :JNJ => 14 },
 { :GOO => 17, :MMM => 3, :ADBE => 6, :EA=> 9, :BA => 15, :KO => 6, :XOM => 8, :GPS => 1, :MCD => 10, :DIS => 15, :CRM => 18, :JNJ => 3 },
 { :GOO => 8, :MMM => 18, :ADBE => 4, :EA=> 6, :BA => 15, :KO => 18, :XOM => 3, :GPS => 12, :MCD => 19, :DIS => 3, :CRM => 7, :JNJ => 9 },
 { :GOO => 10, :MMM => 12, :ADBE => 8, :EA=> 3, :BA => 18, :KO => 20, :XOM => 5, :GPS => 11, :MCD => 3, :DIS => 9, :CRM => 8, :JNJ => 15 },
 { :GOO => 17, :MMM => 14, :ADBE => 2, :EA=> 17, :BA => 7, :KO => 13, :XOM => 1, :GPS => 15, :MCD => 15, :DIS => 10, :CRM => 9, :JNJ => 17 },
]
best_deals = trader_du_lundi(prices)
puts "\n[DEBUG] main()> using trader_du_lundi:\n #{best_deals}"

# Exo 4
dictionary = ["below", "down", "go", "going", "horn", "how", "howdy", "it", "i", "low", "own", "part", "partner", "sit"]
result = jean_michel_data("below", dictionary)
puts "\n[DEBUG] main()> TBD - jean_michel_data: #{result}"
result = jean_michel_data("Howdy partner, sit down! How's it going?", dictionary)
puts "\n[DEBUG] main()> TBD - jean_michel_data: #{result}"
