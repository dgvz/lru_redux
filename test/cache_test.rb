require 'lru_redux'
require 'minitest/autorun'
require 'minitest/pride'

class CacheTest < MiniTest::Unit::TestCase
  def setup
    @c = LruRedux::Cache.new(3)
  end

  def test_drops_old
    @c[:a] = 1
    @c[:b] = 2
    @c[:c] = 3
    @c[:d] = 4

    assert_equal [[:d,4],[:c,3],[:b,2]], @c.to_a
    assert_nil @c[:a]
  end

  def test_pushes_lru_to_back
    @c[:a] = 1
    @c[:b] = 2
    @c[:c] = 3

    @c[:a]
    @c[:d] = 4

    assert_equal [[:d,4],[:a,1],[:c,3]], @c.to_a
    assert_nil @c[:b]
  end


  def test_delete
    @c[:a] = 1
    @c[:b] = 2
    @c[:c] = 3

    @c.delete(:b)
    assert_equal [[:c,3],[:a,1]], @c.to_a
    assert_nil @c[:b]
  end

  def test_update
    @c[:a] = 1
    @c[:b] = 2
    @c[:c] = 3
    @c[:a] = 99
    assert_equal [[:a,99],[:c,3],[:b,2]], @c.to_a
  end
end