require "rmagick"
require "gosu"

class Magick::Image
  def gosu_image
    @gosu_image ||= Gosu::Image.from_blob(columns, rows, export_pixels_to_str(0, 0, columns, rows, "RGBA"))
  end

  def add(shape_type, x, y, *args)
    args << self << x << y
    Shapes.send(shape_type, *args)
  end
end

class Shapes
  DEFAULT_FILL_COLOR = "#ff0000"
  DEFAULT_OUTLINE_COLOR = "#000000"

  SQRT_3_OVER_2 = Math.sqrt(3) * 0.5

  class << self
    def rectangle(width, height, fill_color = DEFAULT_FILL_COLOR, outline_color = DEFAULT_OUTLINE_COLOR, outline_width = 2, image = nil, offset_x = 0, offset_y = 0)
      image ||= new_image(width, height)
      drawer = new_drawer(fill_color, outline_color, outline_width)
      half_outline = outline_width * 0.5
      left_edge = offset_x + half_outline
      top_edge = offset_y + half_outline
      right_edge = offset_x + width - 1 - half_outline
      bottom_edge = offset_y + height - 1 - half_outline
      drawer.polygon(left_edge, top_edge, right_edge, top_edge, right_edge, bottom_edge, left_edge, bottom_edge)
      drawer.draw(image)
      image
    end

    def circle(diameter, fill_color = DEFAULT_FILL_COLOR, outline_color = DEFAULT_OUTLINE_COLOR, outline_width = 2)
      image = new_image(diameter, diameter)
      drawer = new_drawer(fill_color, outline_color, outline_width)
      drawer.circle((diameter - 1) * 0.5, (diameter - 1) * 0.5, outline_width * 0.5, (diameter - 1) * 0.5)
      drawer.draw(image)
      image
    end

    def triangle_equi(width, fill_color = DEFAULT_FILL_COLOR, outline_color = DEFAULT_OUTLINE_COLOR, outline_width = 2)
      image = new_image(width, width)
      drawer = new_drawer(fill_color, outline_color, outline_width)
      height = width * SQRT_3_OVER_2
      base_y = (width - height) * 0.5
      drawer.polygon((width - 1) * 0.5, base_y, outline_width * 0.5, width - base_y, width - 1 - outline_width * 0.5, width - base_y)
      drawer.draw(image)
      image
    end

    def triangle_right(width, height, fill_color = DEFAULT_FILL_COLOR, outline_color = DEFAULT_OUTLINE_COLOR, outline_width = 2)
      image = new_image(width, height)
      drawer = new_drawer(fill_color, outline_color, outline_width)
      half_outline = outline_width * 0.5
      bottom_edge = height - 1 - half_outline
      drawer.polygon(half_outline, half_outline, half_outline, bottom_edge, width - 1 - half_outline, bottom_edge)
      drawer.draw(image)
      image
    end

    private

    def new_image(width, height)
      Magick::Image.new(width, height) { |options| options.background_color = "transparent" }
    end

    def new_drawer(fill_color, outline_color, outline_width)
      Magick::Draw.new.tap do |draw|
        draw.fill(fill_color)
        draw.stroke(outline_color) if outline_color
        draw.stroke_width(outline_width)
        draw.stroke_linejoin("round")
      end
    end
  end
end
