#$players = STDIN.readlines.map { |line| line.chomp }

class Secret_Santa
  
  GIVE_UP = 100
  
  def initialize
    a = 0
    @LAST_NAME_POS = 2
    @nameLines = Array.new()
    @lastNames = Array.new()
    File.open('santa_list.txt', 'r') do |sl|
      line = sl.gets
      while line != nil
        a = a + 1
        @nameLines << (a.to_s + " " + line).split
        line = sl.gets
        #load up an array of last names
        @lastNames << @nameLines[a - 1][@LAST_NAME_POS]
        #p(@lastNames)
      end 
    end
  end
  
  def valid?
    return !tooManyOfOneName?
  end 
  
  def tooManyOfOneName?
    #@LAST_NAME_POS = 2 
    #@lastNames = Array.new
    #@nameLines.each do |n|
    #  @lastNames << n[@LAST_NAME_POS]
    #end
    @lastNames.uniq.each do |t|  
      # assure that no single name accounts for more than half of the total
      if @lastNames.count(t) > (@lastNames.count / 2)
        return true
      end
    end
    return false
  end
  
  # now we must find a valid name to match this Santa 
  # select a random number representing a giftee.
  # the number cannot
  # 1.) have been used or
  # 2.) represent a last name of a giftee that is the same as Santa's
  def assignPairs
    a, b = 0, 0
    pairs, used = Array.new(), Array.new()
    @lastNames.each do |n|
      #p("last name = " + n)
      begin  
        destPos = rand(@lastNames.count)
        b = b + 1
        if b >= GIVE_UP
          p("breaking : name lock")
          break
        end
        #break if b >= 100
        #p("dest = " + destPos.to_s + "   b = " + b.to_s + "   used = " + used.to_s)
        #p(n.to_s + " - " + @lastNames[destPos].to_s)
      end while used.include?(destPos) or n == @lastNames[destPos]
      pairs << Array.new([a, destPos])
      used << destPos
      b = 0
      a = a + 1
    end
    p(pairs)
  end
end


ss = Secret_Santa.new()
# check for valid conditions
if ss.valid?
  # assign random pairs
  ss.assignPairs
end  




