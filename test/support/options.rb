module Parfait
  def self.default_test_options
     {
       Message: 30,
       Integer: 30,
       EnsureEntry: 30
     }
  end
  def self.interpreter_test_options
     {
       Message: 50,
       Integer: 50,
       EnsureEntry: 50
     }
  end
  def self.full_test_options
     {
       Message: 300,
       Integer: 300,
       EnsureEntry: 300
     }
  end
end

module RubyX
  def self.default_test_options
     {
       parfait: Parfait.default_test_options
     }
  end
  def self.full_test_options
     {
       parfait: Parfait.full_test_options
     }
  end
  def self.interpreter_test_options
     {
       parfait: Parfait.interpreter_test_options,
       load_parfait: false ,
       platform: :interpreter
     }
  end
end
