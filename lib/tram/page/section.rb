# frozen_string_literal: true

class Tram::Page
  #
  # @private
  # Contains class-level definition (name and options) for a section
  # with a method [#call] that extracts the section part of hash
  # from an instance of [Tram::Page]
  #
  class Section
    extend Dry::Initializer
    param  :name,   proc(&:to_sym)
    option :method, proc(&:to_s), default: -> { name }, as: :source
    option :if,     proc(&:to_s), optional: true,       as: :positive
    option :unless, proc(&:to_s), optional: true,       as: :negative

    # @param  [Tram::Page] page
    # @return [Hash] a part of the section
    def call(page)
      skip_on?(page) ? {} : { name => value_at(page) }
    end

    private

    def skip_on?(page)
      return true if positive && !page.public_send(positive)
      return true if negative &&  page.public_send(negative)
    end

    def value_at(page)
      page.public_send(source)
    end
  end
end
