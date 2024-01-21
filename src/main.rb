require "minigl"
require_relative "gui"

include MiniGL

class Window < GameWindow
  def initialize
    super(800, 600, false)
    Res.prefix = "#{File.expand_path(__FILE__).split("/")[0..-3].join("/")}/data"
    Gui.initialize
  end

  def update
    Gui.update
  end

  def draw
    clear(0xffffffff)
    Gui.draw
  end
end

Window.new.show
