class ConjugateScrapperService
  attr_accessor :post, :fake_word, :uri

  @@adress = 'https://fr.bab.la/conjugaison/polonais/'

  def initialize(fake_word)
    @fake_word = fake_word.downcase
    @uri = URI(@@adress + @fake_word})
    @post = Nokogiri::HTML(Net::HTTP.get(@uri))
  end
  # miss:
  # check if good page
  # check if already exist word

  def process
    main_word_content = post.css('h2').first.content
    main_word_content.slice('polonaisConjugaison de «')
    main_word_content.slice('»')
    main_word_content.strip!
    main_word = Word.new(content: main_word_content, type: 'verbe', mode: 'infinitif')
    main_word.save

    verb_analyze(main_word)
  end

  private

  def verb_analyze

    post.css('.conj-tense-wrapper').each do |mode|
      mode_name = mode.css('.conj-block.container.result-block').first.content
      mode.css('.conj-tense-block').each do |time|
        time_name = time.css('.conj-tense-block-header').first.content
        time.css('.conj-item').each do |conjuguate_item|
          pronom  = conjuguate_item.css('.conj-person').first.content
          genre   = pronom.slice!(/\(.+o\)/)[1...-1]
          pronom.strip!

          content = conjuguate_item.css('.conj-result').first.content
          puts "mode: #{mode_name}"
          puts "time:  #{time_name}"
          puts "genre: #{genre}"
          puts "pronom: #{pronom}"
          puts "content: #{content}"
          # word = Word.new(content: content)
          # word.set_genre(genre)
          # word.set_person_and_number(pronom)
          # word.set_time(time)
          # word.set_mode(mode)
          # word.fake_word = fake_word if fake_word == content
          # word.main_word = main_word
          # word.save
        end
      end
    end
  end
end
