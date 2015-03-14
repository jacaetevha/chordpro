require "chordpro/chord"
require "chordpro/directive"
require "chordpro/html"
require "chordpro/colorized"
require "chordpro/line"
require "chordpro/linebreak"
require "chordpro/lyric"
require "chordpro/parser"
require "chordpro/song"
require "chordpro/transform"
require "chordpro/version"

module Chordpro
  def self.html(string)
    HTML.new(Transform.new.apply(Parser.new.parse(string))).to_s
  end

  def self.colorized(string, opts={})
    Colorized.new(Transform.new.apply(Parser.new.parse(string)), opts).to_s
  end
end
