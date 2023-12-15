require 'test_helper'

class TestCorpus < Minitest::Test
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
  end

  def test_load
    @corpus.save('/tmp/corpus.json')
    assert File.exist?('/tmp/corpus.json')
  end

  def test_grouped_trigrams
    @corpus.save('/tmp/corpus2.json')
    new_corpus = Momblish::Corpus.load('/tmp/corpus2.json')

    assert_equal @corpus, new_corpus
  end
end
