require 'builder'

module Chordpro
  class ChordedLyric
    attr_reader :chord, :text

    def initialize(chord, text)
      @chord = chord ? "chord-#{chord}" : "silent"
      @text  = text
    end
  end

  class Colorized < HTML
    def line(line, parse)
      lyrics = []

      line.each do |element|
        if element.is_a?(Chord)
          @current_chord = element.to_s
        elsif element.is_a?(Lyric)
          lyrics << ChordedLyric.new(@current_chord, element.to_s.strip)
        end
      end

      @html.div(:class => 'line') do |div|
        lyrics.each do |lyric|
          div.span(lyric.text, :class => lyric.chord)
        end
      end
    end
  end
end
