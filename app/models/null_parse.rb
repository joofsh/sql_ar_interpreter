class NullParse
  def to_hash
    "Not a valid SQL query"
  end

  def text_value
    nil
  end

  def elements
    nil
  end
end
