# Bouncing Ball

class BouncingBall < Processing::App

  def setup
    size 800, 1200

    smooth # draws geometry with 'smooth' (anti-aliased) edges
    no_stroke

    @radius = 40
    @x_pos = @radius/2
    @y_pos = @radius/2
    @speed = 3
    @increase_position = Proc.new { |pos| pos += 3 }
    @decrease_position = Proc.new { |pos| pos -= 3 }

    @x_position_function = @increase_position
    @y_position_function = @increase_position
    fill 0
  end

  def draw
    background 255

    ellipse @x_pos, @y_pos, @radius, @radius
    @x_pos = @x_position_function.call(@x_pos)
    @y_pos = @y_position_function.call(@y_pos)

    if @x_pos > width - @radius/2
      @x_position_function = @decrease_position
    end

    if @x_pos < @radius/2
      @x_position_function = @increase_position
    end

    if @y_pos > height - @radius/2
      @y_position_function = @decrease_position
    end

    if @y_pos < @radius/2
      @y_position_function = @increase_position
    end

  end

  def mouse_pressed
    fill random(255), random(255), random(255)
  end
  
end

BouncingBall.new :title => "Bouncing Ball"
