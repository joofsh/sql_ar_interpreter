class Query

  attr_accessor :sql_query

  def initialize attrs
    attrs.each {|k,v| send "#{k}=", v }
  end

  def ar_query
    find_by_sql_default
  end

  def find_by_sql_default
    return "Not a valid SQL query" unless query_class
    "#{query_class}.find_by_sql(\"#{sql_query}\")"
  end

  def sql_tree
    QueryParser.parse sql_query
  end

  def parsed_sql
    sql_tree.to_hash
  end

  def default_ar
  end

  def query_class
    return nil unless parsed_sql["from"]
    parsed_sql["from"].first.singularize.capitalize
  end

  def select_clause
    return nil if "*" == parsed_sql["select"]
    ".select(\"#{parsed_sql["select"]}\")"
  end

  def optional_clause sql_verb , ar_method = sql_verb
    return nil unless parsed_sql[sql_verb]
    ".#{ar_method}(\"#{parsed_sql[sql_verb]}\")"
  end

  def join_clause
    return nil unless parsed_sql["from"].count > 1
    clause = ""
    parsed_sql["from"][1..-1].each do |q|
      clause << ".joins(:#{q})"
    end
    clause
  end

  def order_clause
    optional_clause "order by", "order"
  end

end
