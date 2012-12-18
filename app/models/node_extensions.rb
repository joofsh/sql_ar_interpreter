module QueryGrammar

  class ParentQuery < Treetop::Runtime::SyntaxNode
    def to_hash
      Hash[ elements.map do |v|
        require'pry';
        binding.pry if v.content.class == Treetop::Runtime::SyntaxNode
        #v.content unless v.text_value.blank?
      end ]
    end
  end

  class VerbWithQuery < Treetop::Runtime::SyntaxNode
    def content
      elements.map { |v| v.text_value.strip }
    end
  end

  class FromWithQuery < Treetop::Runtime::SyntaxNode
    def content
      #verb is always first element in Node.elements array
      verb = elements.first.text_value

      #query string is always second element in Node.elements array
      query_string = elements.second.text_value

      array = [ verb.strip, query_string.split(",").map { |v| v.strip } ]
    end
  end

  class OptionalQuery < Treetop::Runtime::SyntaxNode
    def content
      #verb_with_query subnode is always first element in Node.elements array
      #verb_with_query = elements.first
      array = elements.map do |verb_with_query|
        verb_with_query.elements.map do |v|

          v.text_value.strip
        end
      end
      array.flatten if 1 == array.count
    end
  end

end
