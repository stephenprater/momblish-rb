require 'test_helper'

class TestCorpusAnalyzer < Minitest::Test
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
    @corpus_analyzer = Momblish::CorpusAnalyzer.new(TEST_CORPUS)
  end

  def test_weighted_bigrams
    expected = {
      'AB' => 0.08333333333333333,
      'AC' => 0.08333333333333333,
      'AD' => 0.08333333333333333,
      'BA' => 0.08333333333333333,
      'BC' => 0.08333333333333333,
      'BD' => 0.08333333333333333,
      'CA' => 0.08333333333333333,
      'CB' => 0.08333333333333333,
      'CD' => 0.08333333333333333,
      'DA' => 0.08333333333333333,
      'DB' => 0.08333333333333333,
      'DC' => 0.08333333333333333
    }

    assert_equal expected, @corpus_analyzer.corpus.weighted_bigrams
  end

  def test_grouped_trigrams
    expected = {
      'AB' => {'C' => 0.5, 'D' => 0.5},
      'AC' => {'B' => 0.5, 'D' => 0.5},
      'AD' => {'B' => 0.5, 'C' => 0.5},
      'BA' => {'C' => 0.5, 'D' => 0.5},
      'BC' => {'A' => 0.5, 'D' => 0.5},
      'BD' => {'A' => 0.5, 'C' => 0.5},
      'CA' => {'B' => 0.5, 'D' => 0.5},
      'CB' => {'A' => 0.5, 'D' => 0.5},
      'CD' => {'A' => 0.5, 'B' => 0.5},
      'DA' => {'B' => 0.5, 'C' => 0.5},
      'DB' => {'A' => 0.5, 'C' => 0.5},
      'DC' => {'A' => 0.5, 'B' => 0.5},
    }

    assert_equal expected, @corpus_analyzer.corpus.occurrences
  end

  def test_trigrams_exclude_punctuation
    bad_corpus = [
      'ecdf',
      'ec\n',
      'ec!f',
    ]

    expected = {
      'EC' => {'D' => 1.0},
      'CD' => {'F' => 1.0}
    }

    c = Momblish::CorpusAnalyzer.new(bad_corpus)

    assert_equal expected, c.corpus.occurrences
  end
end
