class Dictionary
  def initialize(path, struct)
    @struct = struct
    @items  = []

    l = @struct.members.length
    File.open(path, 'r') do |f|
      f.each_line do |line|
        @items.push struct.new(*line.chomp.split(',', l))
      end
    end
  end

  def find(conditions)
    @items.find do |i|
      conditions.all?{ |k, v| i.send(k.intern) == v }
    end
  end

  def select(conditions)
    @items.select do |i|
      conditions.all?{ |k, v| i.send(k.intern) == v }
    end
  end
  
  def size
    @items.size
  end
end
