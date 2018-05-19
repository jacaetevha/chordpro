module Chordpro
  # Transpose a song by the given interval.
  #
  #   song = Chordpro.parse(file.read)
  #   transposed_song = Chordpro::Transposer.new(song, 3).visit
  #
  class Transposer
    def initialize(song, interval, key: nil)
      @song = song
      @interval = interval
      @key = key
    end

    def visit
      Song.new @song.accept(self)
    end

    def chord(chord)
      chord.transpose(@interval, key: @key)
    end
  end
end
