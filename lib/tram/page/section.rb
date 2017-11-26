# frozen_string_literal: true

class Tram::Page
  #
  # Contains class-level definition (name and options) for a section
  # with a method [#call] that extracts the section part of hash
  # from an instance of [Tram::Page]
  #
  class Section
    extend Dry::Initializer
    param  :name,   proc(&:to_sym)
    option :method, proc(&:to_s),    default: -> { name }
    option :value,  proc(&:to_proc), optional: true
    option :if,     proc(&:to_s),    optional: true
    option :unless, proc(&:to_s),    optional: true

    # @param  [Tram::Page] page
    # @return [Hash] a part of the section
    def call(page)
      skip_on?(page) ? {} : { name => value_at(page) }
    end

    private

    def skip_on?(page)
      return true if attributes[:if]     && !page.__send__(attributes[:if])
      return true if attributes[:unless] &&  page.__send__(attributes[:unless])
    end

    def value_at(page)
      if attributes[:value]
        page.instance_exec(&attributes[:value])
      else
        page.public_send(attributes[:method])
      end
    end

    def attributes
      @attributes ||= self.class.dry_initializer.attributes(self)
    end
  end
end
