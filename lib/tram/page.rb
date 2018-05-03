# frozen_string_literal: true

class Tram::Page
  extend ::Dry::Initializer

  require_relative "page/section"

  class << self
    attr_accessor :i18n_scope

    # Defines a section of the page as a reference to its public method,
    # and creates/overloads the method if necessary.
    #
    # @param  [#to_sym] name The name of the **section**
    #
    # @option [Boolean] :overload
    #   If this definition can overload a previous one
    # @option [Proc] :value (nil)
    #   A new content of the referred method
    # @option options [#to_sym] :method (name)
    #   The name of public method to take value from
    # @option options [#to_sym] :if (nil)
    #   The name of public method to check if the section should be displayed
    # @option options [#to_sym] :unless (nil)
    #   The name of public method to check if the section should be hidden
    #
    # @return [self] itself
    #
    def section(name, overload: false, value: nil, **options)
      name = name.to_sym
      raise "Section #{name} already exists" if !overload && sections.key?(name)

      section = Section.new(name, options)
      define_method(section.source, &value) if value

      sections[name] = section
      self
    end

    # Makes Rails url helper method accessible from within a page instance
    #
    # @param [#to_s] name The name of the helper method
    #
    # @return [self] itself
    #
    def url_helper(name)
      raise "Rails url_helpers module is not defined" unless defined?(Rails)
      delegate name, to: :"Rails.application.routes.url_helpers"
      self
    end

    # The hash of definitions for the page's sections
    #
    # @return [Hash]
    #
    def sections
      @sections ||= {}
    end
  end

  def to_h(except: nil, only: nil, **)
    sections = self.class.sections.dup
    sections.select! { |k, _| Array(only).include? k }   if only
    sections.reject! { |k, _| Array(except).include? k } if except
    sections.map { |_, section| section.call(self) }.reduce({}, :merge!)
  end

  private

  def t(key, **options)
    raise "I18n is not defined" unless defined?(I18n)
    default_scope = [Tram::Page.i18n_scope, self.class.name.underscore]
    I18n.t key, scope: default_scope, **options
  end

  self.i18n_scope = "pages"
end
