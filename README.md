# Momblish

Momblish is a library for generating fake words in any phoenetic.

[http://mentalfloss.com/article/69880/7-fake-words-ended-dictionary](http://mentalfloss.com/article/69880/7-fake-words-ended-dictionary)

It is named after a "fake" word put into the OED on accident.

Momblish uses trigram analysis to generate (mostly) pronounacble gibberish - so
it can be used for any language that can be n-gram analyzed.

## Description

To use moblish, require it -

```ruby
require 'momblish'
english = Momblish.english()
english.word
```


Currently availabe corpuses are:

- English
- Spanish
- 1000 Most Frequent English Words (Simple)
- Names


Each time you load the English momblish it will perform an analysis on
the corpus file and use that data to generate nonsense words.

To avoid this computation overhead, you can save the pre-analyzed corpus
as a file and read it in on demand.

```ruby
require 'momblish'
m = Momblish.english()
m.corpus.save('/tmp/corpus.json')

c = Corpus.load('/tmp/corpus.json')
n = Momblish(c)
```

To get Momblish to generate words for you call `word` on a Momblish instance.

`sentence` will yield a word to a block. You can feed this to your program to make word lists
of varying length.  If you don't provide a length to `sentence` it will yield forever.

```ruby

require 'momblish'

simple = Momblish.simple

simple.sentence(10).map(&:1)

# or

simple.sentence do |word|
  # do some stuff and remember to break
end
```
