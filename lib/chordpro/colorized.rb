require 'builder'

module Chordpro
  class ChordedLyric
    attr_reader :chord
    attr_accessor :breaks

    def initialize(chord, text)
      @breaks = text.empty? || text.end_with?(" ")
      @text   = text.strip
      @chord  = chord
    end

    def text
      @text.empty?? "♫" : @text
    end

    def text_class
      classes = [chord_class]
      classes << "break" if breaks
      classes << "beat" if @text.empty?
      classes.join(" ")
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

    def subtitle(subtitle)
      super if @opts.fetch(:show_title, true)
    end

    def linebreak(_)
      # Don't show line breaks
    end

    def comment(text)
      @html.tr do |tr|
        tr.td(:colspan => 2) do |td|
          td.span(text, :class => "comment")
        end
      end
    end
    alias_method :c, :comment

    def line(line, parse)
      lyrics = []

      # TODO: get line#select working here
      elements = line.inject([]) do |els, e|
        els << e if e.is_a?(Chord) || (e.is_a?(Lyric) && !e.to_s.strip.empty?)
        els
      end
      return if elements.empty?

      paired = elements.each_cons(2).to_a << [elements.last,nil]
      paired.each do |element, following|
        if element.is_a?(Chord)
          @current_chord = element.to_s
          lyrics << ChordedLyric.new(@current_chord, "") unless following.is_a?(Lyric)
        elsif element.is_a?(Lyric)
          if element.to_s.start_with?(" ") && lyrics.any?
            lyrics.last.breaks = true
          end
          lyrics << ChordedLyric.new(@current_chord, element.to_s)
        end
      end

      @html.tr do |tr|
        tr.td(:class => 'chord-list') do |td|
          lyrics.select{|l| l.chord}.each do |lyric|
            td.span(lyric.chord, :class => lyric.chord_class)
          end
        end

        tr.td(:class => 'lyrics') do |td|
          lyrics.each do |lyric|
            td.span(lyric.text, :class => lyric.text_class)
          end
        end
      end
    end
  end
end
