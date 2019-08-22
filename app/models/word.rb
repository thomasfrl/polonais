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

  def associated_words
    self.words_ids.map { |id| Word.find(id) }
  end

  def total_counter
    total = counter
    associated_words.each do |word|
      total + word.counter
    end
    total
  end

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
