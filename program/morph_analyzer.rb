require 'natto'

class MorphAnalyzer
  SEPARATOR = ','

  def initialize
    @natto = Natto::MeCab.new(node_format: "%f[0]#{SEPARATOR}%m#{SEPARATOR}%f[6]")
  end

  def parse(sentence)
    nodes = @natto.enum_parse(sentence).select(&:is_nor?)
    nodes.map{ |node| Node.new(*node.feature.split(SEPARATOR)) }
  end

  class Node
    attr_reader :feature, :surface, :root_form

    def initialize(feature, surface, root_form)
      @feature   = feature
      @surface   = surface
      @root_form = root_form
    end

    def emotionable?
      @feature =~ /\A(形容詞|動詞|名詞|感動詞|助動詞)\z/
    end
  end
end
