class Word < Data8
  def putstring
    X.putstring
  end
end
class Object
  def raise
    X.raise(:arg1)
  end
end

class Error1 < StandardError; end
class Error2 < StandardError; end
class Error3 < StandardError; end
class Error4 < Error3; end

class Space
  def main(arg)
    f
  rescue
    'StandardError'.putstring
  rescue Error4
    'Error4'.putstring
  end

  def f
    raise Error4
  rescue RuntimeError
    'RuntimeError'.putstring
  rescue Error1, Error2
    'Error1, Error2'.putstring
  end
end
