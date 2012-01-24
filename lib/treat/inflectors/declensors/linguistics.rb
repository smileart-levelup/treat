module Treat
  module Inflectors
    module Declensors
      silently { require 'linguistics' }
      # Obtain word declensions in English using the
      # ruby 'linguistics' gem.
      class Linguistics
        def self.declense(entity, options = {})
          begin
            l = entity.language.to_s.upcase
            delegate = nil
            silently { delegate = ::Linguistics.const_get(l) }
          rescue RuntimeError
            raise "Ruby Linguistics does not have a module " + 
            " installed for the #{entity.language} language."
          end
          string = entity.to_s
          if options[:count] == :plural
            if entity.has?(:category) &&
              [:noun, :adjective, :verb].include?(entity.category)
              silently { delegate.send(:"plural_#{entity.category}", string) }
            else
              silently { delegate.plural(string) }
            end
          end
        end
      end
    end
  end
end
