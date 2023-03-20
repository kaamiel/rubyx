require_relative '../helper'

module Mains
  module MainsHelper
    include Preloader
    include ScopeHelper

    def setup
      @qemu = ENV["QEMU_ARM"] || "qemu-arm"
      # @linker = ENV["ARM_LINKER"] || "arm-linux-gnu-ld"  #on fedora
      @arm = ENV["TEST_ARM"] || ENV["TEST_ALL"]
      @linker = "arm-linux-gnueabi-ld"  # on ubuntu
      # ENV["TEST_ARM"] = "DEBUG"
    end

    def assert_result( exit_code , stdout , name = nil)
      name = caller_locations.first.label unless name
      input = preload + @input
      code , out = run_interpreter( input , name)
      assert_equal exit_code , code , "interpreter code for #{name}"
      assert_equal stdout , out , "interpreter stdout for #{name}"
      return unless @arm
      code , out = run_arm( input , name)
      assert_equal exit_code , code , "arm code for #{name}"
      assert_equal stdout , out , "arm stdout for #{name}"
    end

    # runnable_methods is called by minitest to determine which tests to run
    def self.runnable_methods
      all = Dir["test/mains/source/*_*.rb"]
      tests =[]
      return tests unless has_qemu
      all.each do |file_name|
        fullname = file_name.split("/").last.split(".").first
        order , name , stdout , exit_code = fullname.split("_")
        method_name = "test_#{order}_#{name}"
        input = File.read(file_name)
        tests << method_name
        self.send(:define_method, method_name ) do
          out , code = run_code(input , "#{order}_#{name}")
          assert_equal stdout , out , "Wrong stdout #{name}"
          assert_equal exit_code , code.to_s , "Wrong exit code #{name}"
        end
      end
      tests
    end

    def run_arm(input , name )
      puts "Compiling #{name}" if ENV["TEST_ARM"] == "DEBUG"
      linker = ::RubyX::RubyXCompiler.new({}).ruby_to_binary( input , :arm )
      writer = Elf::ObjectWriter.new(linker)
      writer.save "mains.o"
      puts "Linking #{name}" if ENV["TEST_ARM"] == "DEBUG"
      `#{@linker} -N mains.o`
      assert_equal 0 , $?.exitstatus , "Linking #{name} failed #{$?}"
      puts "Running #{name}" if ENV["TEST_ARM"] == "DEBUG"
      stdout = `#{@qemu} ./a.out`
      exit_code = $?.exitstatus
      puts "Arm #{stdout} #{exit_code}" if ENV["TEST_ARM"] == "DEBUG"
      return exit_code , stdout
    end

    def run_interpreter(input , name )
      puts "Interpreting #{name}" if ENV["TEST_ARM"] == "DEBUG"
      compiler = RubyX::RubyXCompiler.new(RubyX.default_test_options)
      linker = compiler.ruby_to_binary(input , :interpreter)
      interpreter = Risc::Interpreter.new(linker)
      interpreter.start_program
      interpreter.tick while(interpreter.instruction)
      saved_in = interpreter.std_reg(:saved_message)
      assert_equal Parfait::Message , interpreter.get_register(saved_in).class
      ret = interpreter.get_sys_return
      puts "Interpret #{interpreter.stdout} #{ret}" if ENV["TEST_ARM"] == "DEBUG"
      return ret , interpreter.stdout
    end

    def run_main_return( code )
      @input = as_main "return #{code}"
    end
  end

end
