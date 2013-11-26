require 'curses'
require './lib/commands'
Dir["./lib/commands/*.rb"].each { |f| require f }

class Cursses
  C = Curses

  attr_reader :lines, :cols

  def self.init
    self.new.init
  end

  def initialize
    initialize_curses_environment
    @lines = C.lines
    @cols = C.cols
  end

  def init
    title("foobar")
    write_welcome("Welcome to cursses")
    Commands::Refresh.new(self).run
    wait_for_input
  end

  def main_window
    @main_window ||=
      begin
        C::Window.new(0,0,0,0).tap do |win|
          win.box("|", "-")
        end
      end
  end

  def title(title = '')
    title = "#{title} - #{Time.now}"
    main_window.setpos(1, (@cols - title.length) / 2)
    main_window.attron(red){
      main_window << title
    }
    write_line_at(2,1)
    main_window.refresh
  end

  def write_line_at(line, col)
    main_window.setpos(line, col)
    main_window << ("-" * (@cols - 2))
  end

  def write_welcome(welcome_message)
    main_window.setpos(4,2)
    main_window << welcome_message
  end

  def wait_for_input
    loop do
      key = main_window.getch
      Commands::Registry.each do |command_class|
        if command_class.handles?(key)
          command_class.new(self).run
        end
      end
    end
  end

  private

  def red
    C.color_pair(C::COLOR_RED) | C::A_NORMAL
  end

  def initialize_curses_environment
    C.init_screen
    C.noecho
    C.start_color
    C.use_default_colors
    C.stdscr.keypad(true)
    C.stdscr.nodelay = 1
    C.clear
    C.init_pair(C::COLOR_BLUE,C::COLOR_BLUE,C::COLOR_BLACK)
    C.init_pair(C::COLOR_RED,C::COLOR_RED,C::COLOR_BLACK)
  end
end
