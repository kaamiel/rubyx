# Parfait is the ruby runtime
module Parfait
  TYPE_INDEX = 0
end

require_relative "parfait/object"
require_relative "parfait/data_object"
require_relative "parfait/integer"
require_relative "parfait/factory"
require_relative "parfait/behaviour"
require_relative "parfait/class"
require_relative "parfait/singleton_class"
require_relative "parfait/list"
require_relative "parfait/word"
require_relative "parfait/binary_code"
require_relative "parfait/callable"
require_relative "parfait/block"
require_relative "parfait/callable_method"
require_relative "parfait/sol_method"
require_relative "parfait/dictionary"
require_relative "parfait/type"
require_relative "parfait/cache_entry"
require_relative "parfait/message"
require_relative "parfait/space"
require_relative "parfait/ensure_entry"
require_relative "parfait/exception"
