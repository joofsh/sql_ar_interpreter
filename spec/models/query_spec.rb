require 'spec_helper'

describe Query do
  before do
    @good_query = Query.new sql_query: "select * from users, guests where id = 5 order by name limit 2"
    @bad_query = Query.new sql_query: "foo bar pie"
    @where_tests = YAML.load_file 'spec/treetop/where_testcases.yml'
    @bland_query = Query.new sql_query: "select * from users"

    @valid_query = Query.new sql_query: "select * from users where name = \"bob\""
    @valid_query2 = Query.new sql_query: "select * from users where user.email = \"foo@example.com\""
    @valid_query3 = Query.new sql_query: "select * from users where name in ('jones', 'bob')"
    @invalid_query = Query.new sql_query: "select * from users where id = 5"
    @invalid_query2 = Query.new sql_query: "select * from users where name like '%asdf%'"
  end

  it 'responds to parsing related methods' do
    @good_query.should respond_to :sql_tree
    @good_query.should respond_to :parsed_sql
    @good_query.should respond_to :find_by_sql_default
    @good_query.should respond_to :query_class
    @good_query.should respond_to :select_clause
    @good_query.should respond_to :optional_clause
    @good_query.should respond_to :join_clause
    @good_query.should respond_to :order_clause
    @good_query.should respond_to :limit_clause
    @good_query.should respond_to :inner_join_clause
    @good_query.should respond_to :invalid_query
  end

  describe 'sql_tree method' do
    before do

    end
    it 'returns parse tree for good queries' do
      @good_query.sql_tree.should be_an_instance_of QueryGrammar::ParentQuery
      @good_query.sql_tree.elements.first.class.should eq QueryGrammar::VerbWithQuery
    end

    it 'does not get tripped up by extra whitespace or by semicolon' do
    end

    it 'returns nil for bad queries' do
      @bad_query.sql_tree.should_not be_an_instance_of QueryGrammar::ParentQuery
      @bad_query.sql_tree.should be_an_instance_of NullParse
    end

  end

  describe 'parsed_sql method' do
      it 'returns a hash for good queries' do
        @good_query.parsed_sql.should be_an_instance_of Hash
        @good_query.parsed_sql.first.class.should eq Array
        @good_query.parsed_sql.first.first.class.should eq String
      end

      it 'returns the correct key/value pairs for good queries' do
        @good_query.parsed_sql["select"].should eq "*"
        @good_query.parsed_sql["from"].first.should eq "users"
        @good_query.parsed_sql["from"].second.should eq "guests"
        @good_query.parsed_sql["where"].should eq "id = 5"
        @good_query.parsed_sql["limit"].should eq "2"
      end

      it 'returns an array as the value for the FROM pair' do
        @good_query.parsed_sql["from"].class.should eq Array
        @good_query.parsed_sql["from"].count.should eq 2
      end

      it 'returns error for bad queries' do
        @bad_query.parsed_sql.should eq "Not a valid SQL query"
      end
  end

  describe 'query_class method' do
    it 'returns an accurate string to use as AM class' do
      @good_query.query_class.class.should eq String
    end

    it 'returns nil for bad queries' do
      @bad_query.query_class.should be_nil
    end

    it 'returns singular & capitalized version of AM class' do
      @good_query.query_class.should eq "User"
      @good_query.query_class.should_not eq "user"
      @good_query.query_class.should_not eq "users"
    end

  end

  describe 'find_by_sql_default method' do
    it 'returns valid AR query as string using find_by_sql method' do
      @good_query.find_by_sql_default.should eq "User.find_by_sql(\"select * from users, guests where id = 5 order by name limit 2\")"
      @where_tests.each do |pair|
        test = Query.new(sql_query: pair["sql"])
        test.find_by_sql_default.should be_an_instance_of String
      end
    end

    it 'returns error for invalid queries' do
      @bad_query.find_by_sql_default.should eq "Not a valid SQL query"
    end
  end

  describe 'select_clause method' do
    before do
      @good_query2 = Query.new sql_query: "select name, id from users"
    end

    it 'defaults to nil if optional clauses exist' do
      @good_query.select_clause.should be_nil
    end
    it 'defaults to .all if no select clause' do
      @bland_query.select_clause.should eq ".all"
    end

    it 'returns the verb/query pair if exist' do
      @good_query2.select_clause.should eq ".select(\"name, id\")"
    end
  end

  describe 'optional_clause method' do
    it 'defaults to nil if clause does not exist' do
      @bad_query.optional_clause("limit", ).should be_nil
    end

    it 'returns correct verb/qery pair if exists' do
      @good_query.optional_clause("where").should eq ".where(\"id = 5\")"
    end
  end

  describe 'join_clause method for implicit joins' do
    before do
      @one_table = Query.new sql_query: "select * from users"
      @two_tables = @good_query
      @three_tables = Query.new sql_query: "select * from users, guests, admins"
    end

    it 'returns nil if 1 table present (no joins)' do
      @one_table.join_clause.should be nil
      @bland_query.join_clause.should be nil
    end

    it 'returns correct number of join clauses according to number of tables' do
      @two_tables.join_clause.should eq ".joins(:guests)"
      @three_tables.join_clause.should eq ".joins(:guests).joins(:admins)"
    end
  end

  describe 'inner_join_clause for explicit joins' do
    before do
      @inner_join_query = Query.new sql_query: "Select * from users INNER JOIN guests where guests.id = users.id"
    end

    it 'returns nil if no inner join clause' do
      @good_query.inner_join_clause.should be_nil
    end

    it 'returns correct verb/query pair if exists' do
      @inner_join_query.inner_join_clause.should eq ".joins(:guests)"
    end
  end


  describe 'order_clause method' do
    it 'returns correct verb/query pair if exists' do
      @good_query.order_clause.should eq ".order(\"name\")"
    end

    it 'returns nil if no order clause' do
      @bland_query.order_clause.should be_nil
    end
  end

  describe 'limit_clause method' do
    it 'returns nil if no limit clause' do
      @bland_query.limit_clause.should be_nil
    end

    it 'returns correct verb/query pair if exists' do
      @good_query.limit_clause.should eq ".limit(2)"
    end
  end

  describe 'where_clause method' do
    it 'returns nil if no where clause' do
      @bland_query.where_clause.should be_nil
      @bad_query.where_clause.should be_nil
    end

    it 'returns correct verb/query pair if exists' do
      @good_query.where_clause.should eq ".where(\"id = 5\")"
    end
  end

  describe 'verbose_ar method' do
    it 'returns concatenation of all clause methods' do
      @bland_query.verbose_ar.should eq "User.all"
    end

    it 'returns correct verbose ar query' do
      @good_query.verbose_ar.should eq "User.joins(:guests).where(\"id = 5\").order(\"name\").limit(2)"
    end
  end

  describe 'ar_find_method? AND ar_find_query methods' do
    before do
      @valid_queries = []
      @valid_queries.push Query.new sql_query: "select * from users where id = 5"
      @valid_queries.push Query.new sql_query: "select * from users where id=5"
      @valid_queries.push Query.new sql_query: "select * from users where id = 3 limit 1"
      @valid_queries.push Query.new sql_query: "select * from users where id IN (3,4)"
      @find_pairs = YAML.load_file "spec/treetop/find_testcases.yml"
    end

    it 'returns false for queries with additional optional clauses' do
      #@good_query.ar_find_method?.should be_false
    end

    it 'returns true for queries that meet the critera' do
      @valid_queries.each do |q|
        q.ar_find_method?.should be_true
      end
    end

    it 'returns id number from where clause if no in clause' do
      @valid_queries[0..2].each do |q|
       q.ar_find_query.size.should eq 1
      end
    end

    it 'returns the parsed_sql["in"] if exists' do
      @valid_queries[3].ar_find_query.should eq "3,4"
    end

    it 'returns correct ar find clause' do
      @find_pairs[0..1].each do |p|
        Query.new(sql_query: p["sql"]).ar_find_clause.should eq p["ar"]
      end
    end
  end

  describe 'missing_method query builder methods' do

    it 'returns boolean for whether it should use a custom find method' do
      @valid_query.ar_custom_find?.should be_true
      @good_query.ar_custom_find?.should be_false
      @invalid_query.ar_custom_find?.should be_false
      @invalid_query2.ar_custom_find?.should be_false
    end

    it 'returns correct method name for custom find clause' do
      @valid_query.ar_custom_find_method.should eq "name"
      @valid_query2.ar_custom_find_method.should eq "email"
      @valid_query3.ar_custom_find_method.should eq "name"
    end
    
    it 'returns correct value for custom find clause' do
      @valid_query.ar_custom_find_value.should eq "\"bob\""
    end
    it 'returns correct ar custom find clause' do
      @valid_query.ar_custom_find_clause.should eq "User.find_by_name(\"bob\")"
      @valid_query2.ar_custom_find_clause.should eq "User.find_by_email(\"foo@example.com\")"
      @valid_query3.ar_custom_find_clause.should eq "User.find_by_name('jones', 'bob')"
    end
  end

  describe 'query_values && :params attr' do
    before do
      @valid_query4 = Query.new sql_query: "select * from users where name = 'bob' and email = 'foo@ex.com'"
    end
    it 'determines correct value from query' do
      @valid_query.query_values("where").should eq ["'bob'"]
      @valid_query.query_values("limit").should be_nil
      @valid_query.query_values("order by").should be_nil
      @valid_query2.query_values('where').should eq ["'foo@example.com'"]
      @valid_query2.query_values('limit').should be_nil
      @valid_query4.query_values('where').should eq ["'bob'","'foo@ex.com'"]

      @good_query.query_values('where').should eq [5]
      @good_query.query_values('order by').should eq ['name']
      @good_query.query_values('limit').should eq [2]
    end

    it 'concatenates the query_value onto :params' do

    end
  end

  describe 'clean_query_value' do
    {
      'keeps outer single quotes' => [ "'asdf'", "'asdf'"],
      'keeps inner double quotes' => [ %("say "cheese""), %('say "cheese"') ],
      'strips outer parens' => [ '(x)', 'x' ],
      'keeps inner parens' => [ 'foo(bar)', 'foo(bar)' ],
    }.each do |label, (input, expected)|
      it label do
        actual = @good_query.clean_query_value input
        actual.should == expected
      end
    end
  end
end
