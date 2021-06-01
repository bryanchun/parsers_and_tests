defmodule Parsers.IsoDatetimeTest do
  use ExUnit.Case

  alias Parsers.IsoDatetime

  @moduletag :capture_log

  test "cannot parse a datetime without the T" do
    {:error, _, _, _, _, _} = IsoDatetime.isodatetime("2018-05-25 12:16:14+00:00")
  end

  test "parses a datetime with +00:00 ending" do
    {:ok, [_|_], "", _, _, _} = IsoDatetime.isodatetime("2018-05-25T12:16:14+00:00")
  end

  test "parses a datetime with Z ending" do
    {:ok, [_|_], "", _, _, _} = IsoDatetime.isodatetime("2018-05-25T12:16:14Z")
  end

  test "cannot parse a datetime with wrong ending" do
    {:error, _, _, _, _, _} = IsoDatetime.isodatetime("2018-05-25T12:16:14")
    {:error, _, _, _, _, _} = IsoDatetime.isodatetime("2018-05-25T12:16:14P")
  end
end
