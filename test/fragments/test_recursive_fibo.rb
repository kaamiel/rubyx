require_relative 'helper'

class TestRecursinveFibo < MiniTest::Test
  include Fragments

  def test_recursive_fibo
    @string_input = <<HERE
def fibonaccir( n )
      if( n <= 1 )
        return n 
      else
        a = fibonaccir( n - 1 ) 
        b = fibonaccir( n - 2 )
        return a + b
      end
end 

putint(fibonaccir( 10 ))
HERE
    @should = [0x0,0xb0,0xa0,0xe3,0xa,0x10,0xa0,0xe3,0x4,0x0,0x0,0xeb,0x7,0x10,0xa0,0xe1,0x27,0x0,0x0,0xeb,0x1,0x70,0xa0,0xe3,0x0,0x0,0x0,0xef,0x0,0x70,0xa0,0xe1,0x0,0x40,0x2d,0xe9,0x1,0x0,0x51,0xe3,0xe,0x0,0x0,0xda,0x1,0x20,0x41,0xe2,0x6,0x0,0x2d,0xe9,0x2,0x10,0xa0,0xe1,0xf8,0xff,0xff,0xeb,0x6,0x0,0xbd,0xe8,0x7,0x30,0xa0,0xe1,0x2,0x40,0x41,0xe2,0x1e,0x0,0x2d,0xe9,0x4,0x10,0xa0,0xe1,0xf2,0xff,0xff,0xeb,0x1e,0x0,0xbd,0xe8,0x7,0x50,0xa0,0xe1,0x5,0x60,0x83,0xe0,0x6,0x70,0xa0,0xe1,0x0,0x0,0x0,0xea,0x1,0x70,0xa0,0xe1,0x0,0x80,0xbd,0xe8,0x0,0x40,0x2d,0xe9,0xa,0x30,0x42,0xe2,0x22,0x21,0x42,0xe0,0x22,0x22,0x82,0xe0,0x22,0x24,0x82,0xe0,0x22,0x28,0x82,0xe0,0xa2,0x21,0xa0,0xe1,0x2,0x41,0x82,0xe0,0x84,0x30,0x53,0xe0,0x1,0x20,0x82,0x52,0xa,0x30,0x83,0x42,0x30,0x30,0x83,0xe2,0x0,0x30,0xc1,0xe5,0x1,0x10,0x41,0xe2,0x0,0x0,0x52,0xe3,0xef,0xff,0xff,0x1b,0x0,0x80,0xbd,0xe8,0x0,0x40,0x2d,0xe9,0x1,0x20,0xa0,0xe1,0x20,0x10,0x8f,0xe2,0x9,0x10,0x81,0xe2,0xe9,0xff,0xff,0xeb,0x14,0x10,0x8f,0xe2,0xc,0x20,0xa0,0xe3,0x1,0x0,0xa0,0xe3,0x4,0x70,0xa0,0xe3,0x0,0x0,0x0,0xef,0x0,0x70,0xa0,0xe1,0x0,0x80,0xbd,0xe8,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20]
    @output = "        55  "
    parse
    write "recursive_fibo"
  end
end

