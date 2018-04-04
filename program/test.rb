require 'bundler/setup'
require 'natto'

training_data = {}

nm = Natto::MeCab.new

File.open('maincorpus7emo.txt', 'r') do |f|
  f.each_line do |line|
    sentence, emotion = line.chomp.split('　')
    words = nm.enum_parse(sentence).select{ |n|
      n.feature =~ /形容詞|動詞|名詞|感動詞/
    }.map(&:surface)
    words.each do |word|
      training_data[emotion] ||= Hash.new(0)
      training_data[emotion][word] += 1
    end
  end
end

training_data.each do |emotion, score|
  all = score.each_value.inject(&:+)
  score.each do |word, count|
    puts [emotion, word, count.to_f / all].join(',')
  end
end
