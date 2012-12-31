class Query

  attr_accessor :sql_query

  def initialize attrs
    attrs.each {|k,v| send "#{k}=", v }
  end

  def ar_query
    verbose_ar
  end

  def verbose_ar
    return invalid_query unless query_class
    return ar_find_clause if ar_find_method?
    return ar_custom_find_clause if ar_custom_find?
    "#{query_class}#{select_clause}#{join_clause}#{inner_join_clause}#{where_clause}#{order_clause}#{limit_clause}"
  end

  def ar_find_clause
    "#{query_class}.find(#{ar_find_query})"
  end

  def ar_find_query
    return parsed_sql["in"].tr '()','' if parsed_sql["in"]
    parsed_sql["where"].split("=").last.strip
  end

  def find_by_sql_default
    return invalid_query unless query_class
    "#{query_class}.find_by_sql(\"#{sql_query}\")"
  end

  def ar_custom_find_method
    method = parsed_sql["where"].split("and").first.split("=").first.strip
    method = method.split(".").last if method.include?(".")
    return method
  end

  def ar_custom_find_value
    parsed_sql["where"].split("and").first.split("=").second.strip
  end

  def ar_custom_find_clause
    "#{query_class}.find_by_#{ar_custom_find_method}(#{ar_custom_find_value})"
  end

  def invalid_query
    "Not a valid SQL query"
  end

  def ar_find_method?
    return true if no_other_optional_clauses && limit_is_one_or_none && no_other_where_conditions && includes_id_condition
    false
  end
  def ar_custom_find?
    return true if no_other_optional_clauses && limit_is_one_or_none &&
      no_other_where_conditions && !includes_id_condition
    false
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
    return nil if parsed_sql.count > 2
    return ".all" if "*" == parsed_sql["select"]
    ".select(\"#{parsed_sql["select"]}\")"
  end

  def optional_clause sql_verb, ar_method = sql_verb
    return nil unless parsed_sql[sql_verb]
    ".#{ar_method}(\"#{parsed_sql[sql_verb].tr("\"","'")}\")"
  end

  def join_clause
    return nil unless (parsed_sql["from"] && parsed_sql["from"].count > 1)
    clause = ""
    parsed_sql["from"][1..-1].each do |q|
      clause << ".joins(:#{q})"
    end
    clause
  end

  def order_clause
    optional_clause "order by", "order"
  end

  def limit_clause
    return nil unless parsed_sql["limit"]
    optional_clause("limit").gsub "\"", ""
  end

  def inner_join_clause
    return nil unless parsed_sql["inner join"]
    ".joins(:#{parsed_sql["inner join"]})"
  end

  def where_clause
    optional_clause "where"
  end
end

private

  def no_other_optional_clauses
    parsed_sql["inner join"].nil? && parsed_sql["order by"].nil?
  end

  def limit_is_one_or_none
    '1' == parsed_sql["limit"] || parsed_sql["limit"].nil?
  end

  def no_other_where_conditions
    return false unless parsed_sql["where"]
    1 == parsed_sql["where"].split("and").count
  end

  def includes_id_condition
    if parsed_sql["in"].nil?
      parsed_sql["where"].include?("id =") || parsed_sql["where"].include?("id=")
    else
      parsed_sql["where"].include?("id")
    end
  end

