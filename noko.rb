require "open-uri"
require "nokogiri"
require 'json'

# Recuparation de l'url des itineraries

url = "https://www.lonelyplanet.com/peru"
file = open(url).read
doc = Nokogiri::HTML(file)
# Quand itineraries n'est pas en 3eme position (ex: Peru) il faut iterer pour trouver sa position
count = 3
url_itineraries = ""
3.times do
  title = doc.search("#in-detail > div > section > div > article:nth-child(#{count}) > ul > li:nth-child(1)")
  if title.children[1].text.strip != "Itineraries"
    count -= 1
  else
    url_itineraries = title.children[1].attribute('href').value
  end
end

file = open(url_itineraries).read
doc = Nokogiri::HTML(file)

#Recupere les noms des differents itineraires
itineraries = []

i = 1
(doc.search(".NarrativeSideMenu").children.count - 2).times do
  itineraries << doc.search(".NarrativeSideMenu").children[i].children[0].text
  i += 1
end

# Scrapping des cities
cities = {}
doc.search(".page").each do |noko|
  cities << noko.text
end

# Scrapping des temps de voyage
# times = []
# sections = doc.search(".NarrativeBodyText ul")
# sections.each do |noko|
#   p times << noko.text
# end


# En recupérant les id des différentes sections. Reste à recuperer toutes ces id.
# cities = []
# doc.search("#the-central-corridor .page").each do |noko|
#   cities << noko
# end
# cities.map! { |city| city.text }


# p itineraries

# p cities
# p times


# TODO : Reussir a separer les villes en fonction des temps.
