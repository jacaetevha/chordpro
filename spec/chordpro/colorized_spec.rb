require 'spec_helper'

describe Chordpro::Colorized do
  def colorized(string)
    Chordpro.colorized(string)
  end

  it "renders line" do
    expect(colorized("[G7]I dreamed I [C]held you in my [G]arms").to_s).to eq(
      '<div class="line">' +
      '<span class="chord-G⁷">I dreamed I</span>' +
      '<span class="chord-C">held you in my</span>' +
      '<span class="chord-G">arms</span>' +
      '</div>'
    )
  end

  it "styles missing chords as silent" do
    expect(colorized("I dreamed I [C]held you in my [G]arms").to_s).to eq(
      '<div class="line">' +
      '<span class="silent">I dreamed I</span>' +
      '<span class="chord-C">held you in my</span>' +
      '<span class="chord-G">arms</span>' +
      '</div>'
    )
  end
end
