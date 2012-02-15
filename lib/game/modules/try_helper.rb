class Game
  module Modules
    module TryHelper
      def try(method, *args, &block)
        self && send(method, *args, &block)
      end
    end
  end
end

Object.send :include, Game::Modules::TryHelper
