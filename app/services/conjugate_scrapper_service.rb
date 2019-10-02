class ConjugateScrapperService
  attr_accessor :post, :fake_word, :uri, :words

  @@adress = 'https://fr.bab.la/conjugaison/polonais/'

  def initialize(fake_word)
    @fake_word = fake_word
    @uri       = URI(URI.escape(@@adress + @fake_word.content.downcase))
    @post      = Nokogiri::HTML(Net::HTTP.get(@uri))
    @words     = []
  end

  def process
    post.css('.conj-tense-wrapper').each do |mode|
      mode_name = mode.css('.conj-block.container.result-block').first.content
      mode.css('.conj-tense-block').each do |time|
        time_name = time.css('.conj-tense-block-header').first.content
        time.css('.conj-item').each do |conjuguate_item|
          pronom  = conjuguate_item.css('.conj-person').first.content
          genre   = pronom.slice!(/\(.+\)/).to_s.gsub(/(\(|\))/, '').strip
          content = conjuguate_item.css('.conj-result').first.content

          word = Word.new content: content, category: :verbe, main_word: main_word
          word.set_pronom(pronom)
          word.set_genre(genre)
          word.set_time(time_name)
          word.set_mode(mode_name)
          word.set_fake_word
          word.save
          words << word
        end
      end
    end
    if words.map(&:fake_word_id).compact.blank?
      words.each do |word|
        word.destroy
      end
    end
  end

  private

  def main_word
    @main_word ||= begin
      content = post.css('h2').first
                              .content
                              .gsub(/(polonaisConjugaison de «|»)/, '')
                              .strip

      main_word = Word.new content:  content,
                           category: :verbe,
                           mode:     :infinitif,
                           main:     :true

      main_word.set_fake_word
      main_word.save
      words << main_word
      main_word
    end
  end
end
