require 'builder'
require 'set'

module Chordpro
  class ChordedLyric
    attr_reader :chord, :text

    def initialize(chord, text)
      @text  = text
      @chord = chord
    end

    def chord_class
      chord ? "chord-#{chord}" : "silent"
    end
  end

  class Colorized < HTML
    def initialize(song, opts={})
      @opts = opts
      super(song)
    end

    def title(title)
      super if @opts.fetch(:show_title, true)
    end

    def line(line, parse)
      lyrics = []

      line.each do |element|
        if element.is_a?(Chord)
          @current_chord = element.to_s
        elsif element.is_a?(Lyric)
          lyrics << ChordedLyric.new(@current_chord, element.to_s.strip)
        end
      end

      @html.tr do |tr|
        chord_list = lyrics.inject(Set.new) do |list, lyric|
          list << [lyric.chord, lyric.chord_class] if lyric.chord
          list
        end
        tr.td(:class => 'chord-list') do |td|
          chord_list.each do |chord, chord_class|
            td.span(chord, :class => chord_class)
          end
        end

        tr.td(:class => 'lyrics') do |td|
          lyrics.each do |lyric|
            text = lyric.text.match(/(?<pre>\s*)(?<phrase>\S.*\S)(?<post>\s*)/)
            td.span(text[:pre],    :class => "break") unless text[:pre].empty?
            td.span(text[:phrase], :class => lyric.chord_class)
            td.span(text[:post],   :class => "break") unless text[:post].empty?
          end
        end
      end
    end
  end
end
