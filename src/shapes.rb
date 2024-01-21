require "rmagick"
require "gosu"

include Magick

class Shapes
  DEFAULT_FILL_COLOR = "#ff0000"
  DEFAULT_OUTLINE_COLOR = "#000000"

  SQRT_3_OVER_2 = Math.sqrt(3) * 0.5

  class << self
    def rectangle(width, height, fill_color = DEFAULT_FILL_COLOR, outline_color = DEFAULT_OUTLINE_COLOR, outline_width = 2)
      image = new_image(width, height)
      drawer = new_drawer(fill_color, outline_color, outline_width)
      half_outline = outline_width * 0.5
      right_edge = width - 1 - half_outline
      bottom_edge = height - 1 - half_outline
      drawer.polygon(half_outline, half_outline, right_edge, half_outline, right_edge, bottom_edge, half_outline, bottom_edge)
      drawer.draw(image)

      gosu_image(image, width, height)
    end

    def circle(diameter, fill_color = DEFAULT_FILL_COLOR, outline_color = DEFAULT_OUTLINE_COLOR, outline_width = 2)
      image = new_image(diameter, diameter)
      draw = new_drawer(fill_color, outline_color, outline_width)
      draw.circle((diameter - 1) * 0.5, (diameter - 1) * 0.5, outline_width * 0.5, (diameter - 1) * 0.5)
      draw.draw(image)

      gosu_image(image, diameter, diameter)
    end

    def triangle_equi(width, fill_color = DEFAULT_FILL_COLOR, outline_color = DEFAULT_OUTLINE_COLOR, outline_width = 2)
      image = new_image(width, width)
      draw = new_drawer(fill_color, outline_color, outline_width)
      height = width * SQRT_3_OVER_2
      base_y = (width - height) * 0.5
      draw.polygon((width - 1) * 0.5, base_y, outline_width * 0.5, width - base_y, width - 1 - outline_width * 0.5, width - base_y)
      draw.draw(image)

      gosu_image(image, width, width)
    end

    private

    def new_image(width, height)
      Image.new(width, height) { |options| options.background_color = "transparent" }
    end

    def new_drawer(fill_color, outline_color, outline_width)
      Draw.new.tap do |draw|
        draw.fill(fill_color)
        draw.stroke(outline_color)
        draw.stroke_width(outline_width)
        draw.stroke_linejoin("round")
      end
    end

    def gosu_image(image, width, height)
      Gosu::Image.from_blob(width, height, image.export_pixels_to_str(0, 0, width, height, "RGBA"))
    end
  end
end
