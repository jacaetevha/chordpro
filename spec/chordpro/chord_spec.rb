require 'spec_helper'

describe Chordpro::Chord do
  describe 'to_s' do
    {
      'Bb' => 'B♭',
      'F#m' => 'F♯m',
      'Gaug7' => 'G+⁷',
      'Ddim7' => 'D°⁷',
      'Csus9' => 'Cˢᵘˢ⁹',
      'Asus2' => 'Aˢᵘˢ²',
      'Esus4' => 'Eˢᵘˢ⁴',
      'E5' => 'E⁵',
      'Cm6' => 'Cm⁶',
      'G7' => 'G⁷',
      'Asus9' => 'Aˢᵘˢ⁹'
    }.each do |input, output|
      it "replaces #{input.inspect} with #{output.inspect}" do
        expect(Chordpro::Chord.new(input).to_s).to eq(output)
      end
    end
  end

  describe 'accept' do
    let(:chord) { Chordpro::Chord.new('C') }
    let(:visitor) { double(:visitor) }

    it 'calls chord with chord' do
      expect(visitor).to receive(:chord).with(chord).and_return('result')
      expect(chord.accept(visitor)).to eq('result')
    end

    it 'does not blow up if object does not respond to chord' do
      expect(chord.accept(visitor)).to be(chord)
    end
  end

  describe '==' do
    it 'is true if name is the same' do
      expect(Chordpro::Chord.new('G')).to eq(Chordpro::Chord.new('G'))
    end

    it 'is false if name is different' do
      expect(Chordpro::Chord.new('G')).not_to eq(Chordpro::Chord.new('A'))
    end
  end

  describe '#transpose' do
    context 'to flat key' do
      basic_notes = %w[C Db D Eb E F Gb G Ab A Bb B]
      all_expected = (0...12).map { |i| basic_notes[i..12] + basic_notes[0..i] }
      all_expected.each do |expected|
        it "transposes #{expected}" do
          actual = (0...expected.length).map do |i|
            Chordpro::Chord.new(expected[0]).transpose(i, key: 'Gb').inspect
          end
          expect(expected).to eq actual
        end
      end
    end

    context 'to C' do
      basic_notes = %w[C C# D D# E F F# G G# A A# B]
      all_expected = (0...12).map { |i| basic_notes[i..12] + basic_notes[0..i] }
      all_expected.each do |expected|
        it "transposes #{expected}" do
          actual = (0...expected.length).map do |i|
            Chordpro::Chord.new(expected[0]).transpose(i, key: 'C').inspect
          end
          expect(expected).to eq actual
        end
      end
    end

    context 'to sharp key' do
      basic_notes = %w[C C# D D# E F F# G G# A A# B]
      all_expected = (0...12).map { |i| basic_notes[i..12] + basic_notes[0..i] }
      all_expected.each do |expected|
        it "transposes #{expected}" do
          actual = (0...expected.length).map do |i|
            Chordpro::Chord.new(expected[0]).transpose(i, key: 'E').inspect
          end
          expect(expected).to eq actual
        end
      end
    end

    context 'compound chords' do
      it 'transposes A/C# to Ab/C' do
        expect(Chordpro::Chord.new('A/C#').transpose(-1)).to eq Chordpro::Chord.new('Ab/C')
      end

      it 'transposes Ab/C to B/D#' do
        expect(Chordpro::Chord.new('Ab/C').transpose(3)).to eq Chordpro::Chord.new('B/D#')
      end

      it 'transposes A7b5 to C#7b5' do
        expect(Chordpro::Chord.new('A7b5').transpose(4, key: 'A')).to eq Chordpro::Chord.new('C#7b5')
      end

      it 'transposes A7b5 to Db7b5' do
        expect(Chordpro::Chord.new('A7b5').transpose(4, key: 'Eb')).to eq Chordpro::Chord.new('Db7b5')
      end

      it 'transposes Bbmin#9 to F#min#9' do
        expect(Chordpro::Chord.new('Bbmin#9').transpose(-4, key: 'E')).to eq Chordpro::Chord.new('F#min#9')
      end
    end
  end
end
