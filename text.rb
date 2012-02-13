# encoding: UTF-8
#
(126..256).each do |code|
  puts "#{code} - #{code.chr} - #{code.to_s(16)}"
end
