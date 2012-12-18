base_path = File.expand_path File.dirname __FILE__

require 'treetop'
Treetop.load File.join base_path, "query_grammar.treetop"
require File.join base_path, 'node_extensions.rb'

class QueryParser
@@parser = QueryGrammarParser.new

  class << self
    def parse query
      return NullParse.new unless query
      @@parser.parse query.downcase or NullParse.new
    end

    def clean_tree root_node
      root_node.elements.delete_if{|node| node.text_value  == "Treetop::Runtime::SyntaxNode" }
    end
  end

end
