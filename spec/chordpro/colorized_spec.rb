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

  it "styles changes inside a word with no break" do
    expect(colorized("[G7]And no one [C]else could come be[G]tween").to_s).to eq(
      '<tr>' +
      '<td class="chord-list">' +
      '<span class="chord-G⁷">G⁷</span>' +
      '<span class="chord-C">C</span>' +
      '<span class="chord-G">G</span>' +
      '</td>' +
      '<td class="lyrics">' +
      '<span class="chord-G⁷">And no one</span>' +
      '<span class="chord-C nobreak">else could come be</span>' +
      '<span class="chord-G">tween</span>' +
      '</td>' +
      '</tr>'
    )
  end

  it "renders lyric-less chord changes" do
    expect(colorized("[G]I hung my [G7][D7]head and I [G]cried.[C]").to_s).to eq(
      '<tr>' +
      '<td class="chord-list">' +
      '<span class="chord-G">G</span>' +
      '<span class="chord-G⁷">G⁷</span>' +
      '<span class="chord-D⁷">D⁷</span>' +
      '<span class="chord-G">G</span>' +
      '<span class="chord-C">C</span>' +
      '</td>' +
      '<td class="lyrics">' +
      '<span class="chord-G">I hung my</span>' +
      '<span class="chord-G⁷ beat">♫</span>' +
      '<span class="chord-D⁷">head and I</span>' +
      '<span class="chord-G">cried.</span>' +
      '<span class="chord-C beat">♫</span>' +
      '</td>' +
      '</tr>'
    )
  end

  it "renders comments" do
    string = "{c: Verse}\n[G]You are my sunshine"
    expect(colorized(string, :show_title => false).to_s).to eq(
      '<tr>' +
      '<td colspan="2"><span class="comment">Verse</span></td>' +
      '</tr>' +
      '<tr>' +
      '<td class="chord-list"><span class="chord-G">G</span></td>' +
      '<td class="lyrics"><span class="chord-G">You are my sunshine</span></td>' +
      '</tr>'
    )
  end

  it "hides line breaks" do
    string = "{title: You Are My Sunshine}\n\n" +
             "[G]You are my sunshine"
    expect(colorized(string).to_s).to eq(
      '<h1 class="title">You Are My Sunshine</h1>' +
      '<tr>' +
      '<td class="chord-list"><span class="chord-G">G</span></td>' +
      '<td class="lyrics"><span class="chord-G">You are my sunshine</span></td>' +
      '</tr>'
    )
  end

  it "hides the title and subtitle when specified" do
    string = "{title: You Are My Sunshine}\n" +
             "{subtitle: As performed on Oh Brother Where Art Thou?}\n\n" +
             "[G]You are my sunshine"
    expect(colorized(string, :show_title => false).to_s).to eq(
      '<tr>' +
      '<td class="chord-list"><span class="chord-G">G</span></td>' +
      '<td class="lyrics"><span class="chord-G">You are my sunshine</span></td>' +
      '</tr>'
    )
  end
end
