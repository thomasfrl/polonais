class Word < ApplicationRecord
  enum category: %i[verbe adjectif mot_commun adverbe pronom autre]

  enum genre: %i[masculin feminin neutre masculin_personnel masculin_animé commun]

  enum number: %i[singulier pluriel]

  enum grammatical_case: %i[nominatif accusatif génétif datif instrumental locatif vocatif]

  enum person: %i[première seconde troisième]

  enum mode: %i[indicatif conditionnel imperatif participe infinitif]

  enum aspect: %i[perfectif imperfectif]

  enum time: %i[présent passé future]
  
  has_many :associated_words, class_name: 'Word', foreign_key: 'main_word_id'
  belongs_to :main_word, class_name: 'Word', optional: true
  belongs_to :fake_word, optional: true

  validates_uniqueness_of :content, scope: %i[category genre number grammatical_case person mode aspect time]

  def decorated_content
    content.downcase.strip
  end

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

  def set_main
    if number == 'singulier' && grammatical_case == 'nominatif'
      if category == 'mot_commun'
        self.main  = true
      elsif category == 'adjectif' && genre == 'masculin'
        self.main  = true
      end
    end
  end

  def set_fake_word
    self.fake_word = FakeWord.find_by content: decorated_content
  end

  def total_counter
    main_word = main == true ? self : self.main_word
    init      = main_word.fake_word.try(:counter).to_i

    main_word.associated_words.map(&:fake_word)
                              .compact
                              .map(&:counter)
                              .inject(init, :+)
  end

  # def self.ordered_by_counter
  #   sort_by { |word| word.total_counter }.reverse
  # end

  # scope :all_main, -> { where(main: true, valid: true).order( : :desc) }
  # scope :valid, -> { where(valid: true).order(counter: :desc) }
  # scope :not_valid, -> { where(valid: false).order(counter: :desc) }
  # scope :ordered -> { joins(:fake_word).order('fake_word.counter DESC') }

  # def self.ordered_by_counter
  #   to_a.sort_by { |word| word.total_counter }.reverse
  # end

  private

  def time_collection
    {
      :'Czas przyszły prosty'  => { time: :présent },
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
      :Mianownik   => { grammatical_case: :nominatif },
      :Dopełniacz  => { grammatical_case: :génétif },
      :Celownik    => { grammatical_case: :datif },
      :Biernik     => { grammatical_case: :accusatif },
      :Narzędnik   => { grammatical_case: :instrumental },
      :Miejscownik => { grammatical_case: :locatif },
      :Wołacz      => { grammatical_case: :vocatif }
    }
  end

  def genre_and_number_collection
    { :'r.mo./r.mzw'   => { genre: :masculin_animé,     number: :singulier },
      :'r.mrz.'        => { genre: :masculin,           number: :singulier },
      :'rodzaj żeński' => { genre: :feminin,            number: :singulier },
      :'rodzaj nijaki' => { genre: :neutre,             number: :singulier },
      :'r.mo.'         => { genre: :masculin_personnel, number: :pluriel },
      :'r.nmo.'        => { genre: :commun,             number: :pluriel } }
  end
end
