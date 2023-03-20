class RubyXC < Thor
  desc "compile FILE" , "Compile given FILE to binary"
  long_desc <<-LONGDESC
      Compile the give file name to binary object file (see below.)

      Output will be elf object file of the same name, with .o, in root directory.

      Note: Because of Bug #13, you need to run "ld -N file.o" on the file, before
      executing it. This can be done on a mac by installing a cross linker
      (brew install arm-linux-gnueabihf-binutils), or on the target arm machine.
    LONGDESC

  def compile(file)
    linker = do_compile(file)
    elf = { debug: options[:elf] || false  }
    writer = Elf::ObjectWriter.new(linker , elf)

    outfile = file.split("/").last.gsub(".rb" , ".o")
    writer.save outfile
    system "arm-linux-gnueabi-ld -N #{outfile}"
    File.delete outfile
    return outfile
  end

  private
  # Open file, create compiler, compile and return linker
  def do_compile(file)
    begin
      ruby = File.read(file)
    rescue
      fail MalformattedArgumentError , "No such file #{file}"
    end
    puts "compiling #{file}"
    code = get_preload + ruby
    puts "Code= #{code}"
    RubyX::RubyXCompiler.new(extract_options).ruby_to_binary( code , :arm )
  end

end
