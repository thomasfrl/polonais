class TraductionScrapper
  attr_accessor :post, :word

  def initialize(word)
    @word  = word
    adress = 'https://context.reverso.net/traduction/polonais-francais/'
    uri    = URI(URI.escape(adress + @word.content.downcase))
    @post  = Nokogiri::HTML(Net::HTTP.get(uri))
  end

  def process
    traductions = post.css('#translations-content')
                      .children
                      .map(&:text)
                      .map(&:strip)
    word.traduction |= traductions
    word.save
  end
end