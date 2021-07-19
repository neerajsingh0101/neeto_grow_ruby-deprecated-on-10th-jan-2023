# frozen_string_literal: true

require "test_helper"

class Neeto::Insights::RubyTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Neeto::Insights::Ruby.const_defined?(:VERSION)
    end
  end

  test "something useful" do
    assert_equal("expected", "actual")
  end
end
