# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
%w[verbe adjectif mot_commun adverbe pronom autre].each do |type|
  Type.create value: type
end

%w[masculin feminin neutre].each do |genre|
  Genre.create value: personn
end

%w[sigulier pluriel].each do |number|
  Number.create value: number
end

%w[nominatif accusatif gerondif datif instrumental locatif vocatif].each do |gram_case|
  GrammaticalCase.create value: gram_case
end

%w[première seconde troisième].each do |personn|
  Personn.create value: personn
end
