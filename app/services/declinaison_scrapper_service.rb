class DeclinaisonScrapperService
  attr_accessor :post, :fake_word, :uri, :words
  @@adresses = { adjectif: 'http://odmiana.net/odmiana-przez-przypadki-przymiotnika-',
                 name:     'http://odmiana.net/odmiana-przez-przypadki-rzeczownika-' }

  # miss:
  # check if good page
  # check if already exist word

  def initialize(fake_word)
    @words          = []
    @fake_word      = fake_word
    @uri            = {}
    %i[adjectif name].each do |type|
      @uri[type] = URI(@@adresses[type] + @fake_word.content.downcase.strip)
    end
  end

  def process
    uri.each do |type, link|
      post = Nokogiri::HTML(Net::HTTP.get(link))
      if post.css('h1').text != '301 Moved'
        send("analyze_#{type}")
      end
    end
  end

  private

  def analyze_adjectif
    trs = post.css('tbody tr').drop(1)
    genres = trs.shift.css('td').drop(1).map(&:text)
    analyze_word(trs) do |word, i|
      word.set_genre_and_number(genres[i])
      word.type = :adjectif
    end
  end

  def analyze_name
    trs = post.css('tbody tr').drop(1)
    analyze_word(trs) do |word,i|
      word.number = (i == 0 ? 'singulier' : 'pluriel')
      word.type = :nom_commun
    end
  end

  def analyze_word(trs)
    trs.each do |tr|
      tds   = tr.css('td')
      decal = 0
      grammatical_case = tds.shift.text
      tds.each_with_index do |td, i|
        size = td['colspan'].to_i
        size = 1 if size == 0
        size.each do
          word = Word.new(content: td.text)
          yield(word, i + decal) if block_given?

          word.set_case(grammatical_case)
          word.set_fake_word(fake_word)
          word.set_main_word
          words << word
        end
        decal += size - 1
      end
    end
    save_words
  end

  def save_words
    main_word = words.find(main: true)
    words.each do |word|
      word.main_word = main_word
      word.save
    end
  end
end
