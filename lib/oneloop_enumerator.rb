# -*- coding: utf-8 -*-

module Enumerable
  def to_oneloop_enumerator
    OneloopEnumerator.new(self)
  end
end

class OneloopEnumerator
  include Enumerable

  OEProc = Struct.new(:enum_proc, :filter_proc, :exit_test_proc)

  def initialize(enum)
    @enum = enum
    @procs = []
  end

  def collect(&blk)
    @procs << OEProc.new(blk)
    self
  end

  alias_method :map, :collect

  def select(&blk)
    @procs << OEProc.new(nil, blk)
    self
  end

  alias_method :find_all, :select

  def reject(&blk)
    @procs << OEProc.new(nil, lambda {|e| ! blk.call(e) })
    self
  end

  def grep(pattern, &blk)
    @procs << OEProc.new(nil, lambda {|e| pattern === e })
    @procs << OEProc.new(blk) if blk
    self
  end

  def take(n)
    i = 0
    @procs << OEProc.new(nil, nil, lambda {|_| (i += 1) > n })
    self
  end

  def take_while
    @procs << OEProc.new(nil, nil, lambda {|e| ! yield(e) })
    self
  end

  def drop(n)
    i = 0
    @procs << OEProc.new(nil, lambda {|_| (i += 1) > n })
    self
  end

  def drop_while
    flag = false
    @procs << OEProc.new(nil, lambda {|e| flag or flag = ! yield(e) })
    self
  end

  def each
    return self unless block_given?
    @enum.each do |e|
      catch do |tag|
        @procs.each do |p|
          e = p.enum_proc.call(e) if p.enum_proc
          throw tag if p.filter_proc && ! p.filter_proc.call(e)
          return if p.exit_test_proc && p.exit_test_proc.call(e)
        end
        yield e
      end
    end
    @enum
  end

  def dorun
    each {|_|}
  end
end
