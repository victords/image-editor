require "rmagick"
require "minigl"

class Window < MiniGL::GameWindow
  def initialize
    super(800, 600, false)

    image = Magick::Image.new(50, 50) do |options|
      options.background_color = "transparent"
      options.format = "PNG"
    end
    draw = Magick::Draw.new
    draw.fill = "#ff0000"
    draw.stroke = "black"
    draw.stroke_width = 2
    draw.circle(24.5, 24.5, 1, 24)
    draw.draw(image)
    @image = Gosu::Image.from_blob(50, 50, image.export_pixels_to_str(0, 0, 50, 50, "RGBA"))
  end

  def draw
    clear(0xffffffff)
    @image.draw(10, 10, 0)
  end
end

Window.new.show
