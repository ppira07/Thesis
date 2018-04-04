require 'natto'

text = '私は家で勉強します'

nm = Natto::MeCab.new
nm.parse(text) do |n|
  puts "#{n.surface} #{n.feature}"
end
