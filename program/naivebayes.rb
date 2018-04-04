require 'bundler/setup'
require_relative 'morph_analyzer'

training_data = {}

analyzer = MorphAnalyzer.new

File.open('maincorpus7emo.txt', 'r') do |f|
  f.each_line do |line|
    sentence, emotion = line.chomp.split('　')
    words = analyzer.parse(sentence).select(&:emotionable?).map(&:root_form)
    words.each do |word|
      training_data[emotion] ||= Hash.new(0)
      training_data[emotion][word] += 1
    end
  end
end

variety = training_data.inject(0){ |count, (_, words)| count + words.size }
training_data.each do |emotion, words|
  all = words.each_value.inject(&:+)
  words.each do |word, count|
    puts [emotion, word, (count + 1).to_f / (all + variety)].join(',')
  end
end
