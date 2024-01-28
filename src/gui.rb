require_relative "shapes"
require_relative "editable_shape"
require_relative "constants"

include MiniGL

class Gui
  BUTTON_SIZE = 50
  SHAPE_SIZE = 40
  SHAPE_OFFSET = (BUTTON_SIZE - SHAPE_SIZE) / 2
  LEFT_PANEL_COLUMNS = 3
  SPACING = 10

  class << self
    def initialize
      shape_types = %i[rectangle circle triangle_equi triangle_right]
      @shapes = shape_types.map do |type|
        case type
        when :rectangle, :triangle_right
          Shapes.send(type, SHAPE_SIZE, SHAPE_SIZE)
        else
          Shapes.send(type, SHAPE_SIZE)
        end
      end

      button_images = [
        Shapes.rectangle(BUTTON_SIZE, BUTTON_SIZE, "#00000000", nil, 0),
        Shapes.rectangle(BUTTON_SIZE, BUTTON_SIZE, "#00000019", nil, 0),
        Shapes.rectangle(BUTTON_SIZE, BUTTON_SIZE, "#00000032", nil, 0),
      ]
      Res.instance_variable_get(:@global_imgs)[:button] = button_images.map(&:gosu_image)

      @buttons = (0...shape_types.size).map do |i|
        col = i % LEFT_PANEL_COLUMNS
        row = i / LEFT_PANEL_COLUMNS
        Button.new(x: SPACING + col * (BUTTON_SIZE + SPACING), y: SPACING + row * (BUTTON_SIZE + SPACING), img: :button) do
          @active_shape = EditableShape.new(shape_types[i])
        end
      end
    end

    def update
      KB.update
      Mouse.update
      @buttons.each(&:update)
      @active_shape&.update
    end

    def draw
      G.window.draw_rect(0, 0, SPACING + LEFT_PANEL_COLUMNS * (BUTTON_SIZE + SPACING), WINDOW_HEIGHT, 0xffeeeeee, 1)
      @buttons.each_with_index do |b, i|
        b.draw(255, 1)
        @shapes[i].gosu_image.draw(b.x + SHAPE_OFFSET, b.y + SHAPE_OFFSET, 1)
      end
      @active_shape&.draw
    end
  end
end
