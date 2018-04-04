require 'bundler/setup'
require 'parallel'
require_relative 'dictionary'
require_relative 'morph_analyzer'

dictionary = Dictionary.new('naivebayes2.txt', Struct.new(:emotion, :root_form, :score))
analyzer   = MorphAnalyzer.new

PROCESSES       = 4
EMOTICON_REGEXP = /(\([^\p{Han}\p{Hiragana}\p{Katakana}\p{Digit}(]+?\))/
EMOTIONS        = %w(喜 悲 怒 驚 期待 不安 平静)
DEFAULT_SCORE   = 1.0 / dictionary.size

File.open('newtweet.txt', 'r') do |f|
  Parallel.each(f.each_line, in_processes: PROCESSES) do |tweet|
    tweet.scan(EMOTICON_REGEXP) do |emoticon|
      nodes = analyzer.parse(tweet).select(&:emotionable?)
      next if nodes.empty?

      emotion_score = EMOTIONS.map{ |emotion|
        scores = nodes.map{ |node|
          item = dictionary.find(emotion: emotion, root_form: node.root_form)
          item ? item.score.to_f : DEFAULT_SCORE
        }
        [emotion, scores.inject(&:*)]
      }

      e, s = emotion_score.max_by{ |_, score| score }
      puts [emoticon, e, s, *emotion_score.map{ |_, score| score }].join(',')
    end
  end
end
