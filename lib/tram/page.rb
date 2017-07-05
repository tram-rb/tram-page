# frozen_string_literal: true

class Tram::Page
  extend ::Dry::Initializer::Mixin

  class << self
    attr_accessor :i18n_scope

    def section(name, options = {})
      @__sections ||= []

      n = name.to_sym
      if @__sections.map(&:first).include?(n)
        raise "Section #{n} already exists"
      end

      n = define_section_method(n, options)
      @__sections << [n, options]
    end

    def url_helper(name)
      raise "Rails url_helpers module is not defined" unless defined?(Rails)
      delegate name, to: :"Rails.application.routes.url_helpers"
    end

    private

    def define_section_method(n, options)
      return n unless options[:value]
      define_method(n) { instance_exec(&options[:value]) }
      n
    end
  end

  def to_h(options = {})
    data = page_methods(options).map do |(name, opts)|
      value = public_send(opts[:method] || name)
      [name, value]
    end
    Hash[data]
  end

  private

  def t(key)
    raise "I18n is not defined" unless defined?(I18n)
    I18n.t key, scope: [Tram::Page.i18n_scope, self.class.name.underscore]
  end

  def page_methods(options)
    methods = self.class.instance_variable_get(:"@__sections") || []
    except = Array(options[:except])
    only = Array(options[:only])
    methods.reject do |(name, opts)|
      (except.any? && except.include?(name)) ||
        (only.any? && !only.include?(name)) ||
        __hide?(opts)
    end
  end

  def __hide?(opts)
    black, white = opts.values_at(:unless, :if)
    (black && instance_eval(black.to_s)) ||
      (white && !instance_eval(white.to_s))
  end
end

Tram::Page.i18n_scope = "pages"
