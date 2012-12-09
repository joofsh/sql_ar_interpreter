
def test
  result = pegex(grammer, {receiver: Query.new}).parse expression
  p "For expression #{expression}"
  p "Expected: #{expectation}. Result: #{result}"
end

