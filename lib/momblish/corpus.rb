require 'json'

class Momblish
  class Corpus
    attr_accessor :weighted_bigrams, :occurrences

    def initialize(weighted_bigrams = {}, occurrences = {})
      @weighted_bigrams = weighted_bigrams
      @occurrences = occurrences
    end

    def self.load(path)
      data = File.read(path)
      parsed = JSON.parse(data)
      new(parsed['weighted_bigrams'], parsed['occurrences'])
    end

    def ==(other)
      @weighted_bigrams == other.weighted_bigrams && @occurrences == other.occurrences
    end

    def save(path)
      saved_corpus = {
        weighted_bigrams: @weighted_bigrams,
        occurrences: @occurrences
      }
      File.write(path, JSON.dump(saved_corpus))
    end
  end
end
