require "sdl2"
require "./lib_sdl2_ttf"
require "./graphics"
require "./game"
require "./fps"

include SDL2

def get_input
  while LibSDL2.poll_event(out e) == 1
    case e.type
    when EventType::QUIT
      return :quit
    when EventType::KEYDOWN
      case e.key.key_sym.scan_code
      when Scancode::ESCAPE; return :quit
      when Scancode::DOWN, Scancode::S; return :down
      when Scancode::RIGHT, Scancode::D; return :right
      when Scancode::LEFT, Scancode::A; return :left
      when Scancode::UP, Scancode::W; return :rotate
      when Scancode::R; return :restart
      when Scancode::SPACE; return :drop
      end
    when EventType::KEYUP
      return :none
    when EventType::USEREVENT
      return :auto_drop
    end
  end
  return :none
end

SDL2.run SDL2::INIT::EVERYTHING do
  raise "TTF_Init Error: #{SDL2.error}" unless LibSDL2_TTF.init() != -1
  graphics = Tetris::Graphics.new
  tetris = Tetris::Game.new(graphics)
  tetris.setup

  fps = Fps.new
  quit = false
  until quit
    fps.start

    graphics.prerender

    action = get_input
    quit = true if action == :quit

    tetris.update action
    graphics.update_render

    fps.stop
  end

  LibSDL2_TTF.quit
end
