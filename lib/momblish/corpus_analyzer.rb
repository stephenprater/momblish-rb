require 'json'
require 'debug'

class Momblish
  class CorpusAnalyzer
    PUNCTUATION = "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~\n".split('')

    attr_accessor :words, :corpus

    def initialize(corpus = [])
      @words = corpus.map(&:rstrip)
      @corpus = Corpus.new({}, {})
      init_weighted_bigrams
      init_occurrences
    end

    def init_weighted_bigrams
      starting_bigrams = Hash.new(0)

      filtered_words = @words.lazy.select do |word|
        word.length > 2 && (word[0..1].chars & PUNCTUATION).empty?
      end

      filtered_words.each do |word|
        bigram = word[0..1].upcase
        starting_bigrams[bigram] += 1
      end

      total = starting_bigrams.values.sum

      starting_bigrams.each do |bigram, count|
        @corpus.weighted_bigrams[bigram] = count.to_f / total
      end
    end

    def init_occurrences
      all_trigrams = @words.each.with_object([]) { |word, memo|
        word_chars = word.chomp.upcase.chars
        next if (word_chars & PUNCTUATION).any?

        memo.concat(word_chars.each_cons(3).to_a)
      }

      occurrences = Hash.new { |h, k| h[k] = Hash.new(0) }

      all_trigrams
        .group_by { |trigram| trigram[0..1].join }
        .each_pair do |bigram, trigrams|
          trigrams.each do |trigram|
            last_char = trigram.last
            occurrences[bigram][last_char] += 1
          end
        end

      @corpus.occurrences = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }

      occurrences.each do |bigram, last_letters|
        total = last_letters.values.sum.to_f
        last_letters.each do |last_letter, count|
          @corpus.occurrences[bigram][last_letter] = count / total
        end
      end
    end
  end
end
