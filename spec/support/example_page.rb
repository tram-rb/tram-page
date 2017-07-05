# frozen_string_literal: true

class ExamplePage < Tram::Page
  param :foo

  section :bar, if: "bar"
  section :foo, method: :foo_alias
  section :baz, value: -> { foo }, unless: "foo.nil?"

  def bar
    foo
  end

  def foo_alias
    foo
  end
end
