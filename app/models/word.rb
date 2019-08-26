class Word < ApplicationRecord
  # before_save :check_if_unique

  enum type: %i[verbe adjectif mot_commun adverbe pronom autre]

  enum genre: %i[masculin feminin neutre masculin_personnel masculin_animé]

  enum number: %i[sigulier pluriel]

  enum grammatical_case: %i[nominatif accusatif gerondif datif instrumental locatif vocatif]

  enum person: %i[première seconde troisième]

  enum mode: %i[indicatif conditionnel imperatif participe infinitif]

  enum aspect: %i[perfectif imperfectif]

  enum time: %i[présent passé future]

  belongs_to :fake_word, optional: true

  has_many :associated_words, class_name: 'Word', foreign_key: 'main_word_id'
  belongs_to :main_word, class_name: 'Word', optional: true

  def set_time(raw_time)
    case raw_time
    when 'Czas teraźniejszy'
      time = 'présent'
    when 'Czas przeszły'
      time = 'passé'
    when 'Czas przyszły złożony'
      time = 'future'
    else
      time = nil
    end
  end

  def set_mode(raw_mode)
    case raw_mode
    when 'Tryb oznajmujący'
      mode = 'indicatif'
    when 'Tryb przypuszczający'
      mode = 'conditionnel'
    when 'Tryb rozkazujący'
      mode = 'imperatif'
    when 'Imiesłowy'
      mode = participe
    else
      mode = nil
    end
  end

  def set_pronom(pronom)
    raw_genre = person.slice!(/\(.+o\)/)[1...-1]
    pronom.strip!

    set_genre(raw_genre)
    set_person_and_number(pronom)
  end

  def set_genre(raw_genre)
    case raw_genre
    when 'm'
      genre = 'masculin'
    when 'f'
      genre = 'feminin'
    when 'n'
      genre = 'neutre'
    else
      genre = nil
    end
  end

  def set_person_and_number(pronom)
    case pronom
    when /ja/
      number = 'singulier'
      person = 'première'
    when /ty/
      number = 'singulier'
      person = 'première'
    when /on/
      number = 'singulier'
      person = 'troisième'
    when /ona/
      number = 'singulier'
      person = 'troisième'
    when /ono/
      number = 'singulier'
      person = 'troisième'
    when /my/
      number = 'pluriel'
      person = 'première'
    when /wy/
      number = 'pluriel'
      person = 'première'
    when /oni/
      number = 'pluriel'
      person = 'troisième'
    when /one/
      number = 'pluriel'
      person = 'troisième'
    else
      number = nil
      person = nil
    end
  end

  # def total_counter
  #   total = counter
  #   associated_words.each do |word|
  #     total + word.counter
  #   end
  #   total
  # end

  # scope :all_main, -> { where(main: true, valid: true).order( : :desc) }
  # scope :valid, -> { where(valid: true).order(counter: :desc) }
  # scope :not_valid, -> { where(valid: false).order(counter: :desc) }

  private

#   def check_if_unique
#     if where(content: content).empty?
#       valid = false
#       return true
#     end
#   end


end
