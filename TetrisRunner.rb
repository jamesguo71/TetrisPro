# University of Washington, Programming Languages, Homework 6, TetrisRunner.rb.rb

require_relative './hw6provided'
require_relative './TetrisPro'

def runTetris
  Tetris.new 
  mainLoop
end

def runMyTetris
  MyTetris.new
  mainLoop
end

if ARGV.count == 0
  runMyTetris
elsif ARGV.count != 1
  puts "usage: TetrisRunner.rb [enhanced | original]"
elsif ARGV[0] == "enhanced"
  runMyTetris
elsif ARGV[0] == "original"
  runTetris
else
  puts "usage: TetrisRunner.rb [enhanced | original]"
end

