base_path = File.expand_path File.dirname __FILE__

require 'treetop'
Treetop.load File.join base_path, "query_grammar.treetop"
require File.join base_path, 'node_extensions.rb'

class QueryParser
@@parser = QueryGrammarParser.new

  class << self
    def parse query
      return NullParse.new unless query
      @@parser.parse(clean_query query) || NullParse.new
    end

    def clean_query query
      query.downcase.strip.chomp(";").strip
    end
  end

end
