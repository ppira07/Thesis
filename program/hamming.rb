require 'bundler/setup'
require_relative 'dictionary'
require_relative 'morph_analyzer'
# require 'twitter'

sentence     = ARGV.first
emotion_dic  = Dictionary.new('naivebayes2.txt', Struct.new(:emotion, :root_form, :score))
emoticon_dic = Dictionary.new('emoticon.txt', Struct.new(:emoticon, :emotion, :score, :v1, :v2, :v3, :v4, :v5, :v6, :v7))
analyzer     = MorphAnalyzer.new

nodes         = analyzer.parse(sentence).select(&:emotionable?)
p root_forms    = nodes.map(&:root_form)
items         = root_forms.map{ |root_form| emotion_dic.select(root_form: root_form) }.flatten
emotion_items = items.group_by(&:emotion)
emotion_score = emotion_items.each_with_object({}) do |(emotion, items), h|
   h[emotion] = items.inject(0){ |s, i| s += i.score.to_f }
end

emotion, _ = emotion_score.max_by{ |emotion, score| score }

emoticon_distance = emoticon_dic.select(emotion: emotion).map do |item|
  vector   = [item.v1, item.v2, item.v3, item.v4, item.v5, item.v6, item.v7].map(&:to_f)
  distance = emotion_score.each_value.zip(vector).map{ |a, b| (a - b).abs }.inject(&:+)
  [item.emoticon, distance]
end
p max      = emoticon_distance.max_by{ |_, distance| distance }.last
p emoticon = emoticon_distance.select{ |emoticon, distance| distance == max }.sample.first

#post on Twitter
#client = Twitter::REST::Client.new do |conf|
#  conf.consumer_key    = ""
#  conf.consumer_secret = ""
#  conf.access_token    = ""
#  conf.access_token_secret = ""
#end

#client.update "#{sentence} #{emoticon}"
p "#{sentence} #{emoticon} #{emotion}"
