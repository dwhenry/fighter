class Game
  class Object
    def self.instance(name)
      unless Game::Object.const_defined?(name)
        Game::Object.const_set(name, Class.new)
      end
      Game::Object.const_get(name).new
    end

    class Exit; end
  end
end
