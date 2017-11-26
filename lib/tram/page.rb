# frozen_string_literal: true

class Tram::Page
  extend ::Dry::Initializer

  require_relative "page/section"

  class << self
    attr_accessor :i18n_scope

    def section(name, options = {})
      name = name.to_sym
      raise "Section #{name} already exists" if sections.key? name

      section = Section.new(name, options)
      sections[name] = section
      define_method(name, &section.block) if section.block
    end

    def url_helper(name)
      raise "Rails url_helpers module is not defined" unless defined?(Rails)
      delegate name, to: :"Rails.application.routes.url_helpers"
    end

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

  def t(key)
    raise "I18n is not defined" unless defined?(I18n)
    I18n.t key, scope: [Tram::Page.i18n_scope, self.class.name.underscore]
  end

  self.i18n_scope = "pages"
end
