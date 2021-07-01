defmodule Parsers.JsonTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  alias Parsers.Json

  @module_tag :capture_log

  test_with_params "parses trivial values",
    fn (value) ->
      {:ok, [_|_], "", _, _, _} = Json.parse(~s(#{value}))
    end do
      [
        {""},
        {42},
        {42.22},
        {"{}"},
        {"[]"},
        {"true"},
        {"false"},
        {"null"},
      ]
  end

  test "parses whitespaced nested JSON" do
    {:ok, [_|_], "", _, _, _} = Json.parse(~s/{"key1": "value1", "key2": {"key2.1": "value2.1"}}/)
    {:ok, [_|_], "", _, _, _} = Json.parse(~s/{"key1": "value1", "key2": [{"key2.1": "value2.1"}, 42, null]}/)
  end
end