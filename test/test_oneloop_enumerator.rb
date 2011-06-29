# -*- coding: utf-8 -*-
require 'test/unit'
require_relative '../lib/oneloop_enumerator'

class TC_OneloopEnumerator < Test::Unit::TestCase

  def test_map
    assert_equal [11, 12, 13], [1, 2, 3].to_oneloop_enumerator.map {|e| e + 10 }.to_a
    assert_equal [22, 24, 26], [1, 2, 3].to_oneloop_enumerator.map {|e| e + 10 }.map {|e| e * 2 }.to_a
  end

  def test_select
    assert_equal [1, 3], [1, 2, 3].to_oneloop_enumerator.select {|e| e.odd? }.to_a
    assert_equal [11, 13], [1, 2, 3].to_oneloop_enumerator.map {|e| e + 10 }.select {|e| e.odd? }.to_a
  end

  def test_reject
    assert_equal [1, 3], [1, 2, 3].to_oneloop_enumerator.reject {|e| e.even? }.to_a
  end

  def test_grep
    assert_equal %w(bb cc), %w(aa bb cc dd).to_oneloop_enumerator.grep(/[bc]/).to_a
    assert_equal %w(bbX ccX), %w(aa bb cc dd).to_oneloop_enumerator.grep(/[bc]/) {|e| e + 'X' }.to_a
  end

  def test_take
    assert_equal (1..3).to_a, (1..100).to_oneloop_enumerator.take(3).to_a
    assert_equal [2, 4, 6, 8], (1..100).to_oneloop_enumerator.take(8).select {|e| e.even? }.to_a
  end

  def test_take_while
    assert_equal [1, 2], [1, 2, 3, 4, 5, 0].to_oneloop_enumerator.take_while {|i| i < 3 }.to_a
  end

  def test_drop
    assert_equal (4..10).to_a, (1..10).to_oneloop_enumerator.drop(3).to_a
  end

  def test_drop_while
    assert_equal [3, 4, 5, 0], [1, 2, 3, 4, 5, 0].to_oneloop_enumerator.drop_while {|i| i < 3 }.to_a
  end

  def test_each
    r = []
    [1, 2, 3].to_oneloop_enumerator.each {|e| r << e }
    assert_equal [1, 2, 3], r, 'copy [1, 2, 3] by each'
  end
end
