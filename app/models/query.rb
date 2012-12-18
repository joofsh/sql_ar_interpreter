class Query < ActiveRecord::Base
  attr_accessible :ar_query, :sql_query

  def parsed_sql
    QueryParser.parse sql_query
  end

  def default_ar
  end

  def query_class
    parsed_sql["from"].first
  end
end
