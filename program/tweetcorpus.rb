require 'bundler/setup'
require 'natto'
require_relative 'dictionary'

DEFAULT_EMOTION = '平静'
SCORE_THRESHOLD = 0.0001

dic = Dictionary.new('naivebayes.txt', Struct.new(:emotion, :word, :score), :word)
nm = Natto::MeCab.new

File.open('newtweet.txt', 'r').each do |f|
  f.each_line do |line|
    words = nm.enum_parse(line).select{ |n| n.feature =~ /形容詞|動詞|名詞|感動詞/ }.map(&:surface)
    items = words.map(&dic.method(:find)).compact
    available_items = items.select{ |item| item.score.to_f > SCORE_THRESHOLD }

    puts available_items.empty? ? DEFAULT_EMOTION : items.sample.emotion
  end
end
