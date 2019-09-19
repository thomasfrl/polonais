class Word < ApplicationRecord
  # before_save :check_if_unique

  enum type: %i[verbe adjectif mot_commun adverbe pronom autre]

  enum genre: %i[masculin feminin neutre masculin_personnel masculin_animé commun]

  enum number: %i[sigulier pluriel]

  enum grammatical_case: %i[nominatif accusatif gerondif datif instrumental locatif vocatif]

  enum person: %i[première seconde troisième]

  enum mode: %i[indicatif conditionnel imperatif participe infinitif]

  enum aspect: %i[perfectif imperfectif]

  enum time: %i[présent passé future]

  belongs_to :fake_word, optional: true

  has_many :associated_words, class_name: 'Word', foreign_key: 'main_word_id'
  belongs_to :main_word, class_name: 'Word', optional: true

  %i[genre_and_number time mode genre].each do |name|
    define_method "set_#{name}" do |string|
      attributes = send("#{name}_collection")[string.to_sym]

      set_attributes(attributes)
    end
  end

  %i[case pronom].each do |name|
    define_method "set_#{name}" do |string|
      associate_attributes = nil
      send("#{name}_collection").each do |regex, attributes|
        associate_attributes = attributes if string =~ /#{regex}/
      end

      set_attributes(associate_attributes)
    end
  end

  def set_attributes(attributes)
    return nil unless attributes

    assign_attributes(attributes)
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

  def time_collection
    {
      :'Czas teraźniejszy'     => { time: :présent },
      :'Czas przeszły'         => { time: :passé },
      :'Czas przyszły złożony' => { time: :future }
    }
  end

  def mode_collection
    {
      :'Tryb oznajmujący'     => { mode: :indicatif },
      :'Tryb przypuszczający' => { mode: :conditionnel },
      :'Tryb rozkazujący'     => { mode: :imperatif },
      :Imiesłowy              => { mode: :participe }
    }
  end

  def genre_collection
    {
      :'m' => { genre: :masculin },
      :'f' => { genre: :feminin },
      :'n' => { genre: :neutre }
    }
  end

  def pronom_collection
    { :ja  => { number: :singulier, person: :première,  genre: :commun },
      :ty  => { number: :singulier, person: :seconde,   genre: :commun },
      :on  => { number: :singulier, person: :troisième, genre: :masculin },
      :ona => { number: :singulier, person: :troisième, genre: :feminin },
      :ono => { number: :singulier, person: :troisième, genre: :neutre },
      :my  => { number: :pluriel,   person: :première,  genre: :commun },
      :wy  => { number: :pluriel,   person: :seconde,   genre: :commun },
      :oni => { number: :pluriel,   person: :troisième, genre: :masculin },
      :one => { number: :pluriel,   person: :troisième, genre: :commun } }
  end

  def case_collection
    {
      :Mianownik   => { case: :nominatif },
      :Dopełniacz  => { case: :génétif },
      :Celownik    => { case: :datif },
      :Biernik     => { case: :accusatif },
      :Narzędnik   => { case: :instrumental },
      :Miejscownik => { case: :locatif },
      :Wołacz      => { case: :vocatif }
    }
  end

  def genre_and_number_collection
    { :'r.mo./r.mzw' => { genre: :masculin_animé,     number: :singulier },
      :'r.mrz.'      => { genre: :masculin,           number: :singulier },
      :'r.ż'         => { genre: :feminin,            number: :singulier },
      :'r.n'         => { genre: :neutre,             number: :singulier },
      :'r.mo.'       => { genre: :masculin_personnel, number: :pluriel },
      :'r.nmo.'      => { genre: :commun,             number: :pluriel } }
  end

#   def check_if_unique
#     if where(content: content).empty?
#       valid = false
#       return true
#     end
#   end


end
