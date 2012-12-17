class Query < ActiveRecord::Base
  attr_accessible :ar_query, :sql_query

  def parsed_sql
    QueryParser.parse ar_query
  end

private
  def determine_query_class
  end
end
