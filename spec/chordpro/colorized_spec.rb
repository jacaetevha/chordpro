require 'spec_helper'

describe Chordpro::Colorized do
  def colorized(string, opts={})
    Chordpro.colorized(string, opts)
  end

  it "renders line" do
    expect(colorized("[G7]I dreamed I [C]held you in my [G]arms").to_s).to eq(
      '<tr>' +
      '<td class="chord-list">' +
      '<span class="chord-G⁷">G⁷</span>' +
      '<span class="chord-C">C</span>' +
      '<span class="chord-G">G</span>' +
      '</td>' +
      '<td class="lyrics">' +
      '<span class="chord-G⁷">I dreamed I</span>' +
      '<span class="chord-C">held you in my</span>' +
      '<span class="chord-G">arms</span>' +
      '</td>' +
      '</tr>'
    )
  end

  it "styles missing chords as silent" do
    expect(colorized("I dreamed I [C]held you in my [G]arms").to_s).to eq(
      '<tr>' +
      '<td class="chord-list">' +
      '<span class="chord-C">C</span>' +
      '<span class="chord-G">G</span>' +
      '</td>' +
      '<td class="lyrics">' +
      '<span class="silent">I dreamed I</span>' +
      '<span class="chord-C">held you in my</span>' +
      '<span class="chord-G">arms</span>' +
      '</td>' +
      '</tr>'
    )
  end

  it "hides the title when specified" do
    string = "{title: You Are My Sunshine}\n\n[G]You are my sunshine"
    expect(colorized(string, :show_title => false).to_s).to eq(
      '<br/>' +
      '<tr>' +
      '<td class="chord-list"><span class="chord-G">G</span></td>' +
      '<td class="lyrics"><span class="chord-G">You are my sunshine</span></td>' +
      '</tr>'
    )
  end
end
