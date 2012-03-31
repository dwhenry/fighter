class Game
  class Object
    module Status
      def status
        @status ||= Game::Object::IDLE
      end

      def expire
        tile.remove(self)
        Game::Object.remove(Game::Engine.instance.map.name, status, self)
        Game::Object.objects.delete(self)
      end

      def activate
        return if @status == Game::Object::ACTIVE
        Game::Object.remove(Game::Engine.instance.map.name, status, self)
        @status = Game::Object::ACTIVE
        Game::Object.add(Game::Engine.instance.map.name, status, self)
      end

      def deactivate
        return if @status == Game::Object::IDLE
        Game::Object.remove(Game::Engine.instance.map.name, status, self)
        @status = Game::Object::IDLE
        Game::Object.add(Game::Engine.instance.map.name, status, self)
      end
    end
  end
end
