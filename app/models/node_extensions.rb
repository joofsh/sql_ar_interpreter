module QueryGrammar

  class ParentQuery < Treetop::Runtime::SyntaxNode
    def to_hash
      Hash[ elements.map { |v| v.content unless v.text_value.blank? } ]
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
      verb = elements[0].text_value

      #query string is always second element in Node.elements array
      query_string = elements[1].text_value

      array = [ verb.strip, query_string.split(",").map { |v| v.strip } ]
    end
  end

  class OptionalQuery < Treetop::Runtime::SyntaxNode
    def content
      self.elements.map do |v|
        v.text_value.strip
      end
    end
  end

end
