module QueryGrammar

  class ParentQuery < Treetop::Runtime::SyntaxNode
    def to_hash
      h = {}
      elements.each do |clause|
        next if clause.text_value.blank?
        h = h.merge clause.to_hash
      end
      h
    end
  end

  class VerbWithQuery < Treetop::Runtime::SyntaxNode
    def content
      arr = elements.map { |v| v.text_value.strip }
    end

    def to_hash
      Hash[[content]]
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

    def to_hash
      Hash[[content]]
    end
  end

  class OptionalQuery < Treetop::Runtime::SyntaxNode
    def content
      array = elements.map do |verb_with_query|
        verb_with_query.content
      end
    end

    def to_hash
      h = {}
      content.each do |c|
        h = h.merge Hash[[c]]
      end
      h
    end
  end

end
