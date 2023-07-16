require "thor"
require "rubyx"
require "risc/interpreter"

class RubyXC < Thor
  class_option :integers , type: :numeric
  class_option :messages , type: :numeric
  class_option :ensure_list , type: :numeric
  class_option :elf , type: :boolean
  class_option :preload , type: :boolean , default: true

  #
  # Actual commands are required at the end, one per file, same name as command
  #
  private
  def extract_options
    opt = {
      Integer: options[:integers] || 1024,
      Message: options[:messages] || 1024,
      EnsureEntry: options[:ensure_list] || 1024
    }
    return { parfait: opt }
  end
  def get_preload
    options[:preload] ? Sol::Builtin.builtin_code : ""
  end
end

require_relative "stats"
require_relative "compile"
require_relative "interpret"
require_relative "execute"
