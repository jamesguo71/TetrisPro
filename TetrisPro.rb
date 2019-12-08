# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  def self.rotations (point_array) 
    # Here, only rotations defined below are affected. All_Pieces NOT affected.
    rotate1 = point_array.map {|x,y| [-y,x]}  
    rotate2 = point_array.map {|x,y| [-x,-y]} 
    rotate3 = point_array.map {|x,y| [y,-x]} 
    rotate4 = point_array.map {|x,y| [-y,-x]}   
    [point_array, rotate1, rotate2, rotate3, rotate4]  
  end

  All_My_Pieces = All_Pieces + [rotations([[0,0],[-1,0],[-1,-1],[0,-1],[1,0]]),
              rotations([[0,0],[0,-1],[1,0]]), 
              [[[0,0],[1,0],[-1,0],[2,0],[-2,0]], [[0,0],[0,1],[0,-1],[0,2],[0,-2]]]]
  # your enhancements here

  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  def self.cheat_piece (board)
    MyPiece.new([[[0,0]]],board)
  end
end

class MyBoard < Board
  # your enhancements here
  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
  end

  def rotate_180degrees
    if !game_over? and @game.is_running?
      @current_block.move(0,0,2)
    end
    draw
  end

  def rotate_counter_clockwise
    if !game_over? 
      @current_block.move(0, 0, -1)
    end
    draw
  end

  def drop_fast(num=5)
    if !game_over? and @game.is_running?
      num.downto(1).any? {|i| @current_block.move(0, i, 0)}
      # Attention here! num is binded to 5! Use i to iterate over possibles
    end
    draw
  end

  def cheat
    if @score >= 100 and @cheating != true
      @cheating = true
      @score -= 100
    end
  end


  def next_piece
    if @cheating
      @current_block = MyPiece.cheat_piece(self)
      @cheating = false
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..locations.size-1).each{|index| 
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end

class MyTetris < Tetris

  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
  # your enhancements here
  def key_bindings
    @root.bind('u', proc {@board.rotate_180degrees})
    @root.bind('c', proc {@board.cheat})
    super
    @root.bind('s', proc {@board.drop_fast})
    @root.bind('Down', proc {@board.drop_fast})
  end
end

srand


