require "momblish/version"
require "momblish/corpus_analyzer"
require "momblish/corpus"

class Momblish
  class Error < StandardError; end

  module WeightedSample
    refine Hash do
      def weighted_sample
        self.max_by { |_, weight| rand ** (1.0 / weight) }.first
      end
    end
  end

  using WeightedSample

  DICT = {
    'english' => ['/usr/share/dict/words', '/usr/dict/words', '/usr/share/dict/web2']
  }

  class EmptyCorpusError < StandardError
    attr_reader :message

    def initialize(message)
      @message = message
    end
  end

  class << self
    def lookup_dict(lang)
      DICT[lang].find { |location| File.exist?(location) }
    end

    def english
      dict_file = lookup_dict('english')
      corpus = Momblish::CorpusAnalyzer.new(File.readlines(dict_file)).corpus
      new(corpus)
    end
  end

  attr_accessor :corpus

  def initialize(corpus = nil)
    @corpus = corpus || Corpus.new({}, {})

    if @corpus.weighted_bigrams.empty? || @corpus.occurrences.empty?
      raise EmptyCorpusError.new('Your corpus has no words')
    end
  end

  def word(length = nil)
    length ||= rand(4..12)

    word = @corpus.weighted_bigrams.keys.sample

    (length - 2).times do
      last_bigram = word[-2..-1]

      next_letter = @corpus.occurrences[last_bigram].weighted_sample
      word += next_letter
    end

    word.downcase
  end

  def sentence(count = nil, word_length = nil)
    raise ArgumentError, 'You must provide a block or a count' if count.nil? && !block_given?

    if block_given?
      if count.nil?
        loop { yield word(word_length) }
      else
        count.times { yield word(word_length) }
      end
    else
      Array.new(count) { word(word_length) }
    end
  end
end
