require "util/eventable"
require "risc/interpreter"
require_relative "compiling"
require_relative "output"

module Risc
  module Ticker
    include ScopeHelper
    include Output
    include Preloader

    def setup
      compiler = RubyX::RubyXCompiler.new(RubyX.interpreter_test_options)
      @linker = compiler.ruby_to_binary(preload + @string_input, :interpreter)
      @interpreter = Interpreter.new(@linker)
      @interpreter.start_program
    end
    alias :do_setup :setup

    def yielder
      "def yielder; return yield ; end"
    end
    def tenner
      "def tenner; return yield(10) ;end"
    end
    def block_main( main , extra = yielder)
      in_Space("#{extra} ; def main(arg) ; #{main} ; end")
    end

    # check the given array of instructions is what the interpreter actually does
    # possible second argument ignores the given amount, usually up until main
    def check_chain( should , start_at = 0 )
      ticks( start_at ) if start_at > 0
      should.each_with_index do |name , index|
        got = ticks(1)
        assert_equal name, got.class, "Wrong class for #{index + 1}, expect #{name}, got #{got}"
      end
    end
    # check the main only, ignoring the __init instructions
    def check_main_chain( should )
      check_chain( should , main_at)
    end

    # how many instruction up until the main starts, ie
    # ticks(main_at) will be the label for main
    def main_at
      Risc.init_length
    end

    # the return of syscall should be an integer
    def get_return
      saved_in = @interpreter.std_reg(:saved_message)
      assert_equal Parfait::Message , @interpreter.get_register(saved_in).class
      @interpreter.get_register(@interpreter.std_reg(:syscall_1))
    end

    # do as many as given ticks in the main, ie main_at more
    def main_ticks(num)
      ticks( main_at + num)
    end

    # do a certain number of steps in the interpreter and return the last executed instruction
    def ticks( num )
      last = nil
      num.times do
        last = @interpreter.instruction
        @interpreter.tick
      end
      return last
    end
    def risc(num)
      return @instruction if @instruction
      @instruction = main_ticks(num)
    end

    # collect the classes of all executed istructions
    def all_classes(max = 300)
      classes = []
      tick = 1
      begin
        while(classes.length < max)
          cl = ticks(1).class
          tick += 1
          classes << cl
          break if cl == NilClass
        end
      rescue => e
        puts "Error at tick #{tick}"
        puts e
        puts e.backtrace
      end
      classes
    end

    # do the setup, compile and run the input (a main) to the end
    def run_main_return(input)
      run_main("return #{input}")
    end

    # get the return from the message (not exit code)
    # exit code must be int
    def get_message_return
      @interpreter.get_register(@interpreter.std_reg(:saved_message)).return_value
    end

    # wrap the input so it is a main, compile and run it
    def run_main(input)
      run_input as_main(input)
    end

    # use the input as it, compile and run it
    # input muts contain a Space.main, but may contain more classes and methods
    def run_input(input)
      @string_input = input
      do_setup
      run_all
    end

    def run_all
      while(@interpreter.instruction)
        @interpreter.tick
        #puts @interpreter.instruction
      end
      @interpreter.clock
    end

    # for chaning the tests quickly output all instructions that are executed
    def show_ticks
      classes = all_classes
      output_classes(classes)
    end
    # show all instructions of the main only
    def show_main_ticks
      classes = all_classes
      classes = classes.slice(main_at , 1000)
      output_classes(classes)
    end

    def output_classes(classes)
      puts class_list(classes)
      exit(1)
    end
  end
end
