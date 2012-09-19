# Richard Carey - Stock Gain Analyzer for FutureAdvisor
# Usage (*nix): ruby future.rb stocks.txt | less
# Use up/down keys to scroll through pages


#Set up Years and Months array constants
MONTHS_ARRAY = []
YEARS_ARRAY = []

#Years table
2001.upto(2010) do |i|
 12.times do
   YEARS_ARRAY.push(i)
  end
end

YEARS_ARRAY.map!(&:to_s) #convert years array to strings for easier concatonation later


#Iterate full month names into array table
(1..12).each do |a|
  MONTHS_ARRAY.push Time.utc(2012,a).strftime("%B")
end
MONTHS_ARRAY = MONTHS_ARRAY*10


###
#Analyze the stocks for gain/date/period

  def stock(arr)

    values = arr

    max = Float::MIN
    maxDiff = Float::MIN
    diff = 0
    bottom = values[0]
    i = 1
    markerLow=[]
    for i in 0..119
        diff += (values[i] - values[i - 1])

          if (diff > maxDiff)
            maxDiff = diff
            max = values[i]
            markerHigh=i
          end

        if (values[i] < bottom)
            bottom = values[i]
            diff = 0
            markerLow.push(i)
        end
    end

    puts "\tBuy at #{(max-maxDiff).round(2)}; Sell at #{(max).round(2)}"
    unless YEARS_ARRAY[markerLow[markerLow.length-2]] > YEARS_ARRAY[markerHigh]
      puts "\tStart of Period: #{MONTHS_ARRAY[markerLow[markerLow.length-2]]}, #{YEARS_ARRAY[markerLow[markerLow.length-2]]} | End of Period: #{MONTHS_ARRAY[markerHigh]}, #{YEARS_ARRAY[markerHigh]}."
    else
      puts "\tStart of Period: #{MONTHS_ARRAY[markerHigh]}, #{YEARS_ARRAY[markerHigh]} | End of Period: #{MONTHS_ARRAY[markerLow[markerLow.length-2]]}, #{YEARS_ARRAY[markerLow[markerLow.length-2]]}."
    end
    puts "\tPercentage gain during period: #{(((max.round(2) - (max-maxDiff).round(2))/(max-maxDiff))*100).round(2)}%"
end

#Begin file I/O / Load Array

unless ARGV.length == 1
  puts "Please enter filename to scan for stock analysis"
  puts "Usage: ruby email.rb prices.txt"
  exit
end

file = ARGV[0]
puts "\nFutureAdvisor"
puts "\nTip: Run \"ruby future.rb stocks.txt | less\" to use up/down keys for scrolling through output"
puts "Analyzing File \"#{file}\"...\n"
puts "---------------------------------------------------------------------------------\n\n"

ar = Array.new([''])

begin
  f = File.open(file)
  f.each_line { |s|
    ar[f.lineno] = s.sub(/\s\|\s/,'--').sub(/\s\|\s/,'--').split('--')
    ar[f.lineno][2] = ar[f.lineno][2].chomp.gsub(/\[|\]/,'').split(",").map(&:to_f)
    puts "#{f.lineno-1}: #{ar[f.lineno][1]}: Analyzed\n"
  }
  puts "\n---------------------------------------------------------------------------------\n"
  ar.shift
rescue Exception => e
  puts "An error occurred.  Please try again. " + e.message
end


#Iteration through Months/Years
def go(ar)
  ar.each do |x|
    y = 0
    m = 0
    puts "Analysis for #{x[0]} Stock Max Gain:"
    stock(x[2])
    print "\n---\n\n"
  end
  return true
end

#Analyze and Output.
go(ar)
