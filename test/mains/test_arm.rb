require_relative 'helper'

# set environment TEST_ARM to true to have these tests run
# They need qemu and arm cross linker to be installed
# Also they are too slow to include in normal runs, so only by request and on travis

# set TEST_ARM to DEBUG to get extra output

module Mains
  class TestArm < MiniTest::Test
    @qemu = "qemu-arm"
    @linker = "arm-linux-gnueabi-ld"
    def self.Linker
      @linker
    end
    def self.Qemu
      @qemu
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

    def self.has_qemu
      if `uname -a`.include?("torsten")
        @linker = "arm-linux-gnu-ld"  #on fedora
      end
      return unless ENV["TEST_ARM"] || ENV["TEST_ALL"]
      begin
        `#{@qemu} -version`
        `#{@linker} -v`
      rescue => e
        puts e
        return false
      end
      true
    end

    def run_code(input , name )
      puts "Compiling #{name}.o" if ENV["TEST_ARM"] == "DEBUG"

      linker = ::RubyX::RubyXCompiler.new({}).ruby_to_binary( input , :arm )
      writer = Elf::ObjectWriter.new(linker)

      writer.save "mains.o"

      puts "Linking #{name}" if ENV["TEST_ARM"] == "DEBUG"

      `#{TestArm.Linker} -N mains.o`
      assert_equal 0 , $?.exitstatus , "Linking #{name} failed #{$?}"

      puts "Running #{name}" if ENV["TEST_ARM"] == "DEBUG"
      stdout = `#{TestArm.Qemu} ./a.out`
      exit_code = $?.exitstatus
      puts "Result #{stdout} #{exit_code}" if ENV["TEST_ARM"] == "DEBUG"
      return stdout , exit_code
    end

  end
end
