require 'spec_helper'

RSpec::Matchers.define :parse_to_class do |expected|
  match do |actual|
    @parse = QueryParser.parse(actual)
    @parse.class == expected
  end

  failure_message_for_should do
    "expected '#{actual}' to parse to class #{expected} \n Instead received: #{@parse.class}"
  end
end



describe QueryParser do
 before do
    @sql_examples = []
    @sql_examples << "SELECT user.name == 'bob' FROM users"
    @sql_examples << "SELECT * FROM users WHERE user.name == 'bob'"
    @sql_examples << "select * from foo order by DESC"
    @sql_examples << "select name,email FROM users"
    @sql_examples << "select * FROM joo, boo"
    @sql_examples << "select * FROM name == 'sql_examples'"
    @sql_examples << "select * from foo where name = boo limit 2"

    @hashified = []
    @hashified << "{\"select\"=>\"user.name == 'bob'\", \"from\"=>[\"users\"]}"
    @hashified << "{\"select\"=>\"*\", \"from\"=>[\"users\"], \"where\"=>\"user.name == 'bob'\"}"
    @hashified << "{\"select\"=>\"*\", \"from\"=>[\"foo\"], \"order by\"=>\"desc\"}"
    @hashified << "{\"select\"=>\"name,email\", \"from\"=>[\"users\"]}"
    @hashified << "{\"select\"=>\"*\", \"from\"=>[\"joo\", \"boo\"]}"
    @hashified << "{\"select\"=>\"*\", \"from\"=>[\"name == 'sql_examples'\"]}"
    @hashified << "{\"select\"=>\"*\", \"from\"=>[\"foo\"], \"where\"=>\"name = boo\", \"limit\"=>\"2\"}"

    @sql_hash_pair = {}
    (0..6).each do |i|
      @sql_hash_pair[@sql_examples[i]] = @hashified[i]
    end
  end

  it "doesn't implode from simple SQL queries" do
    @sql_examples.each do |string|
      string.should parse_to_class QueryGrammar::ParentQuery
    end
  end

  it 'can use custom to_hash class method' do
    @sql_examples.each do |string|
      QueryParser.parse(string).to_hash.should be_an_instance_of Hash
    end
  end

  it 'ignores excess whitespace and ending semicolon' do
    example = "  Select name, id from Users; "
    example.should parse_to_class QueryGrammar::ParentQuery
  end

  it 'matches correct hashified version of query' do
    @sql_hash_pair.each do |sql, hash_version|
      QueryParser.parse(sql).to_hash.to_s.should eq hash_version
    end
  end

  it 'matches incorrect queries to_hash method' do
    QueryParser.parse("invalid_query_example").should be_an_instance_of NullParse
    QueryParser.parse("invalid_query_example").to_hash.should eq "Not a valid SQL query"
  end

  it 'is case insensitive to queries' do
    @sql_examples.first.upcase.should parse_to_class QueryGrammar::ParentQuery
    @sql_examples.first.downcase.should parse_to_class QueryGrammar::ParentQuery
    @sql_examples.first.split("").each_with_index.map { |v,i| i.odd? ? v.upcase : v.downcase }.join.should \
      parse_to_class QueryGrammar::ParentQuery
  end
end

