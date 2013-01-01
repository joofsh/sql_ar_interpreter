class Query

  attr_accessor :sql_query, :params

  def initialize attrs
    attrs.each {|k,v| send "#{k}=", v }
  end

  def ar_query
    verbose_ar
  end

  def clean_query_value value
    return nil unless value
    %w(= in like).each{|e| value.gsub! /.+#{e}\s*(.+)/, '\1' }
    value = value.tr("()","").gsub("\"","'").strip
    if value.to_i.to_s == value.to_s
      value.to_i
    else
      value
    end
  end

  def query_values verb
    return nil unless parsed_sql[verb]
    arr = parsed_sql[verb].split("and")
    arr.map { |v| clean_query_value v }
  end

  def verbose_ar
    return invalid_query unless query_class
    return ar_find_clause if ar_find_method?
    return ar_custom_find_clause if ar_custom_find?
    "#{query_class}#{select_clause}#{join_clause}#{inner_join_clause}#{where_clause}#{order_clause}#{limit_clause}"
  end

  def ar_find_clause
    return invalid_query if not ar_find_method?
    "#{query_class}.find(#{ar_find_query})"
  end

  def ar_find_query
    return parsed_sql["where"].split(" in ").second.tr '()','' if parsed_sql["where"].include?(" in ")
    parsed_sql["where"].split("=").last.strip
  end

  def find_by_sql_default
    return invalid_query unless query_class
    "#{query_class}.find_by_sql(\"#{sql_query}\")"
  end

  def ar_custom_find_method
    method = parsed_sql["where"].split("and").first.split("=").first
    method = method.split(".").last if method.include? "."
    method = method.split(" in ").first if method.include? " in "
    method.strip
  end

  def ar_custom_find_value
    value = parsed_sql["where"].split("and").first
    value = value.split("=").second if value.include?("=")
    value = value.split(" in ").second.strip.tr("()","") if value.include?(" in ")
    value.strip
  end

  def ar_custom_find_clause
    return invalid_query if not ar_custom_find?
    "#{query_class}.find_by_#{ar_custom_find_method}(#{ar_custom_find_value})"
  end

  def invalid_query
    "Not a valid SQL query"
  end

  def ar_find_method?
    return true if no_other_optional_clauses && limit_is_one_or_none &&
      no_other_where_conditions && includes_id_condition &&
      not_a_like_query
    false
  end

  def ar_custom_find?
    return true if no_other_optional_clauses && limit_is_one_or_none &&
      no_other_where_conditions && !includes_id_condition && not_a_like_query
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
    parsed_sql["where"].split("=").first.include?("id")
  end

  def not_a_like_query
    parsed_sql["where"].exclude?(" like ")
  end
