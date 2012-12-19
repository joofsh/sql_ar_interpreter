class Query < ActiveRecord::Base
  attr_accessible :ar_query, :sql_query

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

end
