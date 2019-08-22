require 'nokogiri'
require 'open-uri'

namespace :word do
  desc "TODO"
  task init: :environment do
    File.open('/home/thomas/Documents/Polonais/polish.txt', 'r') do |file|
      file.each do |line|
        content, counter = line.split
        unless FakeWord.all.pluck(:content).include? content
          FakeWord.create(content: content, counter: counter.to_i)
        end
      end
    end
  end


  task scrap_odmiany: :environment do |t, word|
    page = Nokogiri::HTML(open("http://odmiana.net/odmiana-przez-przypadki-rzeczownika-#{word.downcase}"))
    # puts page.css('.ekran')
  end

  task scrap_conjuguate: :environment do |t, word|
    uri = URI("https://fr.bab.la/conjugaison/polonais/#{word.downcase}")
    post = Nokogiri::HTML(Net::HTTP.get(uri))
    # check if good page
    # look for each 'word' in the page
    # for each word 'analyse' word
    # for each new word save the word

    post.css('.conj-tense-wrapper').each do |mode|
      mode.css('.conj-tense-block').each do |time|
        time.css('.conj-item').each do |conjuguate_item|
          person = conjuguate_item.css('.conj-person').first.content
          content = conjuguate_item.css('.conj-result').first.content
          puts person
          puts content
        end
      end
    end

    post.css('#conjFull > div:nth-child(2)').each do |element|
      element.content
    end
  end
end


def analyze_person(person)
  genre = person.slice!(/\(.+o\)/)[1...-1]
  person.strip!
end

def analyze_time
end

def analyze_mode
end

# .conj-tense-wrapper(conj-block container result-block) = mode
#   .conj-tense-block(conj-tense-block-header) = temps
#     .conj-item
#       conj-person = pronom
#       conj-result = conjugaison
