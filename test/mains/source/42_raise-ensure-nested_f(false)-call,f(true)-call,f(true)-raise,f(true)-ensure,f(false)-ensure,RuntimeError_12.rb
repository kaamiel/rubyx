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

# f(false)-call
# f(true)-call
# f(true)-raise
# f(true)-ensure
# f(false)-ensure
# RuntimeError
# 12

class Space
  def main(arg)
    begin
      f(false)
    rescue RuntimeError
      'RuntimeError'.putstring
    end
  end

  def f(do_raise)
    do_raise ? 'f(true)-call,'.putstring : 'f(false)-call,'.putstring
    begin
      if do_raise
        'f(true)-raise,'.putstring
        raise RuntimeError
      end
      f(true) unless do_raise
    ensure
      do_raise ? 'f(true)-ensure,'.putstring : 'f(false)-ensure,'.putstring
    end
    do_raise ? 'f(true)-return,'.putstring : 'f(false)-return,'.putstring
    return 42
  end
end
