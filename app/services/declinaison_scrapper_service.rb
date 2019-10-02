class DeclinaisonScrapperService
  attr_accessor :post, :fake_word, :uri, :words
  @@adresses = { adjectif: 'https://odmiana.net/odmiana-przez-przypadki-przymiotnika-',
                 name:     'https://odmiana.net/odmiana-przez-przypadki-rzeczownika-' }

  def initialize(fake_word)
    @words          = []
    @fake_word      = fake_word
    @uri            = {}
    %i[adjectif name].each do |type|
      @uri[type] = URI URI.escape(@@adresses[type] + @fake_word.content.downcase.strip)
    end
  end

  def process
    uri.each do |type, link|
      @post = Nokogiri::HTML(Net::HTTP.get(link))
      post.css('tbody').each do |tbody|
        trs = tbody.css('tr').drop(1)
        next if trs.blank?

        send("analyze_#{type}", trs)
      end
      save_words
    end
  end

  private

  def analyze_adjectif(trs)
    genres = trs.shift.css('td').drop(1).map(&:text)
    analyze_word(trs) do |word, i|
      word.set_genre_and_number(genres[i])
      word.category = :adjectif
    end
  end

  def analyze_name(trs)
    analyze_word(trs) do |word,i|
      word.number = (i == 0 ? :singulier : :pluriel)
      word.category = :mot_commun
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
        size.times do |j|
          word = Word.new(content: td.text)
          yield(word, i + decal + j) if block_given?

          word.set_case(grammatical_case)
          word.set_fake_word
          word.set_main
          words << word
        end
        decal += size - 1
      end
    end
  end

  def save_words
    main_word = words.find { |word| word.main == true }
    words.each do |word|
      word.main_word = main_word
      word.save
    end
  end
end
