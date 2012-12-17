require 'spec_helper'

RSpec::Matchers.define :parse_to_class do |expected|
  match do |actual|
    @parse = QueryParser.parse(actual)
    @parse.class == expected
  end

  failure_message_for_should do
    "expected '#{actual}' to parse to class #{expected} \n Instead received: #{@parse}"
  end
end



describe QueryParser do

  it "doesn't implode from simple SQL queries" do
    foo = []
    foo << "SELECT user.name == 'bob' FROM users".downcase
    foo << "SELECT * FROM users WHERE user.name == 'bob'".downcase
    foo << 'select * from foo order by DESC'.downcase
    foo << "select name,email FROM users".downcase
    foo << "select * FROM joo".downcase
    foo << "select * FROM name == 'foo'".downcase
    foo << "select * from foo where name = boo limit 2".downcase

    foo.each do |string|
      string.should parse_to_class QueryGrammar::ParentQuery
    end
  end
end

