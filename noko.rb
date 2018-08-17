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

itinerarie_name = ""

itineraries = []
hash_cities = {}
cities = []
result = []

# Scrapping des sections (itineraries_names)
i = 1
(doc.search(".NarrativeSideMenu").children.count - 2).times do
  itinerarie_name = doc.search(".NarrativeSideMenu").children[i].children[0].text
  string = "##{itinerarie_name.downcase.gsub(/\s/, '-').gsub(/&/, '')}"

  # Scrapping des cities de cet itinerarie_name
  doc.search("#{string} .page").each do |noko|
    cities << noko.text
  end

  # Scrapping du temps de l'itinerarie_name
  time = doc.search("#{string} ul").text

  #Ajout au hash resultat
  hash_cities[:itinerarie] = itinerarie_name
  hash_cities[:time] = time
  hash_cities[:cities] = cities
  result << hash_cities
  cities = []
  hash_cities = {}
  i += 1
end

p result


# PROBLEME : Section 2 du Canada n'a pas le meme nom que prévu... l'itinéraire associe est donc vide.
