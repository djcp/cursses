module Commands
  class Refresh < Base
    def self.characters
      %w/r R/
    end

    def run
      reader = FeedReader.new
      line_location = 6
      reader.items.each_with_index do |item, index|
        app.main_window.setpos(line_location + index, 2)
        app.main_window << "#{item} #{index}"
      end
    end
  end
end

Commands::Registry << Commands::Refresh
