require 'spec_helper'

describe Query do
  before do
    @good_query = Query.new sql_query: "select * from users, guests where id = 5 limit 2"
    @bad_query = Query.new sql_query: "foo bar pie"
    @where_tests = YAML.load_file 'spec/treetop/where_testcases.yml'
  end

  it 'responds to parsing related methods' do
    @good_query.should respond_to :sql_tree
    @good_query.should respond_to :parsed_sql
    @good_query.should respond_to :query_class
    @good_query.should respond_to :default_ar
  end

  describe 'sql_tree method' do
    it 'provides parse tree for good queries' do
      @good_query.sql_tree.should be_an_instance_of QueryGrammar::ParentQuery
      @good_query.sql_tree.elements.first.class.should eq QueryGrammar::VerbWithQuery
    end

    it 'provides nil for bad queries' do
      @bad_query.sql_tree.should_not be_an_instance_of QueryGrammar::ParentQuery
      @bad_query.sql_tree.should be_an_instance_of NullParse
    end

  end

  describe 'parsed_sql method' do
      it 'provides a hash for good queries' do
        @good_query.parsed_sql.should be_an_instance_of Hash
        @good_query.parsed_sql.first.class.should eq Array
        @good_query.parsed_sql.first.first.class.should eq String
      end

      it 'provides the correct key/value pairs for good queries' do
        @good_query.parsed_sql["select"].should eq "*"
        @good_query.parsed_sql["from"].first.should eq "users"
        @good_query.parsed_sql["from"].second.should eq "guests"
        @good_query.parsed_sql["where"].should eq "id = 5"
        @good_query.parsed_sql["limit"].should eq "2"
      end

      it 'provides an array as the value for the FROM pair' do
        @good_query.parsed_sql["from"].class.should eq Array
        @good_query.parsed_sql["from"].count.should eq 2
      end

      it 'provides error for bad queries' do
        @bad_query.parsed_sql.should eq "Not a valid SQL query"
      end
  end

  describe 'query_class method' do
    it 'provides an accurate string to use as AM class' do
      @good_query.query_class.class.should eq String
    end

    it 'provides nil for bad queries' do
      @bad_query.query_class.should eq nil
    end

    it 'provides singular & capitalized version of AM class' do
      @good_query.query_class.should eq "User"
      @good_query.query_class.should_not eq "user"
      @good_query.query_class.should_not eq "users"
    end

  end

  describe 'find_by_sql_default method' do
    it 'provides valid AR query as string using find_by_sql method' do
      @good_query.find_by_sql_default.should eq "User.find_by_sql(\"select * from users, guests where id = 5 limit 2\")"
      @where_tests.each do |pair|
        test = Query.new(sql_query: pair["sql"])
        test.find_by_sql_default.should be_an_instance_of String
      end
    end

    it 'provides error for invalid queries' do
      @bad_query.find_by_sql_default.should eq "Not a valid SQL query"
    end

  end
end
