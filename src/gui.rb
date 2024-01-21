require_relative "shapes"

include MiniGL

class Gui
  BUTTON_SIZE = 50
  SHAPE_SIZE = 40
  SHAPE_OFFSET = (BUTTON_SIZE - SHAPE_SIZE) / 2
  SPACING = 10

  class << self
    def initialize
      @shapes = [
        Shapes.rectangle(SHAPE_SIZE, SHAPE_SIZE),
        Shapes.circle(SHAPE_SIZE),
        Shapes.triangle_equi(SHAPE_SIZE),
        Shapes.circle(SHAPE_SIZE),
      ]

      @buttons = (0...@shapes.size).map do |i|
        col = i % 3
        row = i / 3
        Button.new(x: SPACING + col * (BUTTON_SIZE + SPACING), y: SPACING + row * (BUTTON_SIZE + SPACING), img: :button)
      end
    end

    def update
      Mouse.update
      @buttons.each(&:update)
    end

    def draw
      @buttons.each_with_index do |b, i|
        b.draw
        @shapes[i].draw(b.x + SHAPE_OFFSET, b.y + SHAPE_OFFSET)
      end
    end
  end
end
