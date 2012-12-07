class Query < ActiveRecord::Base
  attr_accessible :ar_query, :sql_query

    def convert_query
      query_method_regex = /^(\w*)\.(\w*)/
      query_verb = ar_query.match(query_method_regex)[2]

      case query_verb
      when "find"
        return find_verb
      else
        "Cannot match query to SQL"
      end
    end

private
  def find_verb str
    find_regex = /^(\w*)\.(\w*)(\(|\s)(...)\)$/
    query = ar_query.match find_regex
    "SELECT * FROM #{query[1]}s WHERE id IN #{query[4]}"
  end


end
