require 'builder'

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
          lyrics << ChordedLyric.new(@current_chord, element.to_s.strip)
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
            if lyric.text.empty?
              td.span("♫", :class => "#{lyric.chord_class} beat")
            elsif text = lyric.text.match(/(?<pre>\s*)(?<phrase>\S.*\S)(?<post>\s*)/)
              td.span(text[:pre],    :class => "break") unless text[:pre].empty?
              td.span(text[:phrase], :class => lyric.chord_class)
              td.span(text[:post],   :class => "break") unless text[:post].empty?
            else
              td.span(lyric.text, :class => lyric.chord_class)
            end
          end
        end
      end
    end
  end
end
