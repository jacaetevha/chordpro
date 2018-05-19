module Chordpro
  class Chord < Struct.new(:name)
    ChordName = /([A-G][#b]?)/

    Notes = %w[C Cb C# D Db D# E Eb E# F Fb F# G Gb G# A Ab A# B Bb B#].freeze

    Transpositions = %w[Cb C C# Bb Cb C C C# D Db D D# C Db D D D# E Eb E F D Eb
                        E E E# F# E F F# Eb Fb F F F# G Gb G G# F Gb G G G# A Ab A A# G Ab A A A#
                        B Bb B C A Bb B B B# C#].freeze

    TranspositionsFavorFlats = %w[Cb C Db Bb Cb C C Db D Db D Eb C Db D D Eb E Eb E F D Eb
                                  E E F Gb E F Gb Eb E F F Gb G Gb G Ab F Gb G G Ab A Ab A Bb G Ab A A Bb
                                  B Bb B C A Bb B B C Db].freeze

    Keys = {
      'Cb' => %w[Cb Db Eb Fb Gb Ab Bb],
      'C' => %w[C D E F G A B],
      'C#' => %w[C# D# E# F# G# A# B#],
      'Db' => %w[Db Eb F Gb Ab Bb C],
      'D' => %w[D E F# G A B C#],
      'Eb' => %w[Eb F G Ab Bb C D],
      'E' => %w[E F# G# A B C# D#],
      'F' => %w[F G A Bb C D E],
      'F#' => %w[F# G# A# B C# D# E#],
      'Gb' => %w[Gb Ab Bb Cb Db Eb F],
      'G' => %w[G A B C D E F#],
      'Ab' => %w[Ab Bb C Db Eb F G],
      'A' => %w[A B C# D E F# G#],
      'Bb' => %w[Bb C D Eb F G A],
      'B' => %w[B C# D# E F# G# A#]
    }.freeze

    NameSubstitutions = {
      'Db' => 'C#',
      'Eb' => 'D#',
      'F' => 'F',
      'Gb' => 'F#',
      'Ab' => 'G#',
      'Bb' => 'A#',
      'Cb' => 'B'
    }.freeze

    Substitutions = {
      'b' => '♭',
      '#' => '♯',
      'aug' => '+',
      'dim' => '°',
      '2' => '²',
      '4' => '⁴',
      '5' => '⁵',
      '6' => '⁶',
      '7' => '⁷',
      '9' => '⁹',
      'sus' => 'ˢᵘˢ'
    }.freeze

    Regex = /(#{Substitutions.keys.join('|')})/

    def inspect
      name
    end

    def to_s
      name.gsub(Regex) { |match| Substitutions[match] }
    end

    def accept(visitor)
      visitor.respond_to?(:chord) ? visitor.chord(self) : self
    end

    # Transpose to a new chord by the given interval.
    #
    # interval - number of steps to transpose as a positive or negative Integer.
    #
    # Returns a new Chord
    def transpose(interval, key: nil)
      target_key = (key || 'C').scan(ChordName).flatten.first
      favor_flats = target_key && target_key.index('b')
      new_name = name.gsub(ChordName) do |match|
        interval.abs.times do
          index = Notes.index(match)
          transpositions = favor_flats ? TranspositionsFavorFlats : Transpositions
          match = transpositions[3 * index - 2 + 3 + (interval <=> 0)]
        end
        match
      end

      Chord.new(normalize_chord_name(new_name, target_key))
    end

    private

    def normalize_chord_name(name, target_key)
      chord_root = name.scan(ChordName).flatten.first
      natural_key_notes = Keys[target_key]
      consistent = chord_is_self_consistent(name, chord_root)
      return name if natural_key_notes.include?(chord_root) && consistent

      natural_key_notes.include?(NameSubstitutions[chord_root]) ?
        name.sub(chord_root, NameSubstitutions[chord_root]) :
        name
    end

    def chord_is_self_consistent(name, chord_root)
      return true unless name.index('/')
      Keys[chord_root].include? name.split('/').last
    end
  end
end
