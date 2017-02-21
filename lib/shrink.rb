# frozen_string_literal: true
# Shrink implements a micro-dsl for building Psych ASTs
module Shrink
  def m(children)
    mapping = Psych::Nodes::Mapping.new
    mapping.children.concat(children.flatten)
    mapping
  end

  def sc(val)
    Psych::Nodes::Scalar.new(val)
  end

  def qsc(val)
    Psych::Nodes::Scalar.new(
      val,
      nil,
      nil,
      nil,
      true,
      Psych::Nodes::Scalar::DOUBLE_QUOTED
    )
  end

  def seq(array)
    sequence = Psych::Nodes::Sequence.new
    sequence.children.concat(array)
    sequence
  end
end
