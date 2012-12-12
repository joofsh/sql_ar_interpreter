require 'treetop'
Treetop.load 'query_grammar'

parser = QueryGrammarParser.new
foo = []
foo.push parser.parse "SELECT user.name == 'bob' FROM users".downcase
foo.push parser.parse "SELECT * FROM users WHERE user.name == 'bob'".downcase
foo.push parser.parse 'select * from foo order by DESC'.downcase
foo.push parser.parse "select name,email FROM users".downcase
foo.push parser.parse "select * FROM joo".downcase
foo.push parser.parse "select * FROM name == 'foo'".downcase

def clean_tree(root_node)
  return if(root_node.elements.nil?)
  root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
  root_node.elements.each {|node| self.clean_tree(node) }
end

foo.each do |parse|
  p parse
end
