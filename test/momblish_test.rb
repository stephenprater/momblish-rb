require 'test_helper'

class TestMomblish < Minitest::Test
  TEST_CORPUS = [
    'abcd',
    'abdc',
    'acbd',
    'acdb',
    'adbc',
    'adcb',
    'bacd',
    'badc',
    'bcad',
    'bcda',
    'bdac',
    'bdca',
    'cabd',
    'cadb',
    'cbad',
    'cbda',
    'cdab',
    'cdba',
    'dabc',
    'dacb',
    'dbac',
    'dbca',
    'dcab',
    'dcba'
  ]

  def setup
    @corpus = Momblish::CorpusAnalyzer.new(TEST_CORPUS).corpus
    @momblish = Momblish.new(@corpus)
    srand(10)  # Seed the random number generator for predictable results
  end

  def test_words
    assert_equal 'dabdcbdabc', @momblish.word(10).downcase
  end

  def test_sentence
    expected = ["dabd", "abdc", "cabd", "dcbd"]
    actual = @momblish.sentence(4, 4).map(&:itself)
    assert_equal expected, actual
  end

  def test_infinit_sentence
    w = @momblish.enum_for(:sentence)
    assert_equal 'abdcbdab', w.next
    assert_equal 'cdbca', w.next
  end

  def test_loads_english_dictionary
    m = Momblish.english
    refute_nil m.corpus.occurrences
  end
end
