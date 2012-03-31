class Game
  module Modules
    module ArraySum
      def sum(&block)
        self.inject(0) do |res, value|
          res + block.call(value)
        end
      end
    end
  end
end

Array.send :include, Game::Modules::ArraySum
