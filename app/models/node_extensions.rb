module QueryGrammar

  class ParentQuery < Treetop::Runtime::SyntaxNode
    def to_array
      Hash[self.elements.map { |v| v.content }]
    end
  end

  class VerbWithQuery < Treetop::Runtime::SyntaxNode
    def content
      self.elements.map { |v| v.text_value.strip }
    end
  end
end
