module Commands
  class Quit < Base
    def self.characters
      %w/q Q/
    end

    def run
      app.main_window.close
      exit
    end
  end
end

Commands::Registry << Commands::Quit
