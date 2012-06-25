#$players = STDIN.readlines.map { |line| line.chomp }

class Secret_Santa
  
  def initialize
    a = 0
    @nameLines = Array.new
    File.open('santa_list.txt', 'r') do |sl|
      line = sl.gets
      while line != nil
        a = a + 1
        @nameLines << (a.to_s + " " + line).split
        line = sl.gets
      end 
    end
  end
  
  def valid?
    return !tooManyOfOneName?
  end 
  
  def tooManyOfOneName?
    @LAST_NAME_POS = 2 
    @lastNames = Array.new
    @nameLines.each do |n|
      @lastNames << n[@LAST_NAME_POS]
    end
    p(@lastNames.uniq)
    @lastNames.uniq.each do |t|  
      p (@lastNames.count(t))
      # assure 
      if @lastNames.count(t) > (@lastNames.count / 2)
        return true
      end
    end
    return false
  end
end


ss = Secret_Santa.new()
# check for valid conditions
puts ss.valid?
# assign random pairs