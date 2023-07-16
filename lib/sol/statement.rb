#
# SOL -- Simple  Object  Language
#
# SOL is the abstraction of ruby: ruby minus the fluff
#      fluff is generally what makes ruby nice to use, like 3 ways to achieve the same thing
#      if/unless/ternary , reverse ifs (ie statement if condition), reverse whiles,
#      implicit blocks, splats and multiple assigns etc
#
# Sol has expression and statements, revealing that age old dichotomy of code and
# data. Statements represent code whereas Expressions resolve to data.
# (in ruby there are no pure statements, everthing resolves to data)
#
# Sol resolves to SlotMachine in the next step down. But it also the place where we create
# Parfait representations for the main oo players, ie classes and methods.
# The protocol is thus two stage:
# - first to_parfait with implicit side-effects of creating parfait objects that
#     are added to the Parfait object_space
# - second to_slot , which will return a slot version of the statement. This may be code
#   or a compiler (for methods), or compiler collection (for classes)
#
module Sol

  # Base class for all statements in the tree. Derived classes correspond to known language
  # constructs
  #
  # Basically Statements represent code, generally speaking code "does things".
  # But Sol distinguishes Expressions (see below), that represent data, and as such
  # don't do things themselves, rather passively participate in being pushed around
  class Statement

    # Create any neccessary parfait object and add them to the parfait object_space
    # return the object for testing
    #
    # Default implementation (ie this one) riases to show errors
    # argument is general and depends on caller
    def to_parfait(arg)
      raise "Called when it shouldn't #{self.class}"
    end

    # create slot_machine version of the statement, this is often code, that is added
    # to the compiler, but for methods it is a compiler and for classes a collection of those.
    #
    # The argument given most often is a compiler
    # The default implementation (this) is to raise an error
    def to_slot( _ )
      raise "Not implemented for #{self}"
    end

    def at_depth(depth , lines)
      prefix = " " * 2 * depth
      strings = lines.split("\n")
      strings.collect{|str| prefix + str}.join("\n")
    end

  end

  # An Expression is a Statement that represents data. ie variables constants
  # (see basic_values) , but alos classes, methods and lambdas
  class Expression < Statement

    def each(&block)
      block.call(self)
    end

    def ct_type
      nil
    end

    def normalize
      raise "should not be normalized #{self}"
    end

    # for loading into a slot, return the "slot_definition" that can be passed to
    # SlotLoad.
    def to_slot(compiler)
      raise "not implemented in #{self}:#{self.class}"
    end

  end

end


require_relative "assignment"
require_relative "basic_values"
require_relative "call_statement"
require_relative "class_expression"
require_relative "if_statement"
require_relative "ivar_assignment"
require_relative "lambda_expression"
require_relative "local_assignment"
require_relative "macro_expression"
require_relative "method_expression"
require_relative "class_method_expression"
require_relative "return_statement"
require_relative "statements"
require_relative "send_statement"
require_relative "super_statement"
require_relative "variables"
require_relative "while_statement"
require_relative "yield_statement"
require_relative "rescue_statement"
require_relative "rescue_body_statement"
