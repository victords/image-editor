require_relative "shapes"

include MiniGL

class EditableShape
  def initialize(type, fill_color = "#ff0000", outline_color = "#000000", outline_width = 2)
    @type = type
    @size = 100
    @shape =
      case type
      when :rectangle, :triangle_right
        Shapes.send(type, @size, @size, fill_color, outline_color, outline_width)
      else
        Shapes.send(type, @size, fill_color, outline_color, outline_width)
      end
    follow_mouse
  end

  def update
    follow_mouse
  end

  def draw
    @shape.draw(@x - @size * 0.5, @y - @size * 0.5, 0)
  end

  private

  def follow_mouse
    @x = Mouse.x
    @y = Mouse.y
  end
end
