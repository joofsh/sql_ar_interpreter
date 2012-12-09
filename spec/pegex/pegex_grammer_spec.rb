require_relative './../../lib/pegex-upstream/ruby/lib/pegex'

class TestGrammer < Pegex::Grammar
  def initialize
    @text = <<'...'
  foo: /xyz/ <bar>
  bar:
        /abc/ |
        <baz>
  baz: /def/
...
  end
end

  test_run do |t|
    binding.pry
    g1 = TestGrammar.new
    g1.make_tree
    t.assert_equal g1.tree['+toprule'], 'foo',
      'MyGrammar1 compiled a tree from its text'
  end
