defmodule Parsers.IsoDatetimePropTest do
  use ExUnit.Case, async: true
  use PropCheck   #, default_opts: &PropCheck.TestHelpers.config/0

  alias Parsers.IsoDatetime

  @moduletag :capture_log

  defp pad2(num) do
    num
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

  property "parses a datetime of all valid time" do
    forall [year, month, day, hour, minute, second] <- [
      integer(1000, 9999), integer(1, 12), integer(1, 31), integer(0, 23), integer(0, 59), integer(0, 59)
    ] do
      naive_datetime = "#{year}-#{pad2(month)}-#{pad2(day)}T#{pad2(hour)}:#{pad2(minute)}:#{pad2(second)}"
      :ok == IsoDatetime.isodatetime("#{naive_datetime}+00:00") |> elem(0) &&
        :ok == IsoDatetime.isodatetime("#{naive_datetime}Z") |> elem(0)
    end
  end
end
