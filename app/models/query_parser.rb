base_path = File.expand_path File.dirname __FILE__

require 'treetop'
Treetop.load File.expand_path File.dirname(__FILE__), 'query_grammar.treetop'
require File.join base_path, 'node_extensions.rb'

class QueryParser
@@parser = QueryGrammarParser.new

  class << self
    def parse query
      tree = @@parser.parse query

      if tree.nil?
        raise Exception, "No match found"
      end
      tree.to_array
    end

    def clean_tree root_node
      return if root_node.elements.nil?
      root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
      root_node.elements.each {|node| self.clean_tree node }
    end

  end
end
