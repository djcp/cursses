module Commands
  class Registry
    include Enumerable

    def self.<<(klass)
      @registry ||= []
      @registry << klass
    end

    def self.each
      @registry.each do |klass|
        yield klass
      end
    end
  end

  class Base
    def self.handles?(char)
      self.characters.include?(char)
    end


    def initialize(app)
      @app = app
    end

    private

    attr_reader :app
  end
end
