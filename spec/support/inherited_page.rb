# frozen_string_literal: true

class InheritedPage < ExamplePage
  inherit_section :foo
  inherit_section :bar, if: :no_bar
  section :bam

  def bam
    baz.upcase
  end

  def no_bar
    !bar
  end
end
