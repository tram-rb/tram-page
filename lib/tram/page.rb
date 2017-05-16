# frozen_string_literal: true

class Tram::Page
  extend ::Dry::Initializer::Mixin

  class << self
    attr_accessor :i18n_scope

    def section(name, options = {}, &block)
      @__sections ||= []
      @__sections << [name, options, block]
    end

    def url_helper(name)
      raise "Rails url_helpers module is not defined" unless defined?(Rails)
      delegate name, to: :"Rails.application.routes.url_helpers"
    end
  end

  def to_h(options = {})
    data = page_methods(options).map do |(name, opts, block)|
      value = instance_eval(&block) if block
      value ||= public_send(opts[:method] || name)

      [name, value]
    end
    Hash[data]
  end

  private

  def t(key)
    raise "I18n is not defined" unless defined?(I18n)
    I18n.t key, scope: [self.class.i18n_scope, self.class.name.underscore]
  end

  def page_methods(options)
    methods = self.class.instance_variable_get(:"@__sections") || []
    except = Array(options[:except])
    only = Array(options[:only])
    methods.reject do |(name, _, _)|
      (except.any? && except.include?(name)) ||
        (only.any? && !only.include?(name))
    end
  end
end

Tram::Page.i18n_scope = "pages"
