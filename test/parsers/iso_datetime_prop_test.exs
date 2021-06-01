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

  defp naive_datetimes do
    let [
      year <- integer(1000, 9999),
      month <- integer(1, 12),
      day <- integer(1, 31),  # Hand-wavy here
      hour <- integer(0, 23),
      minute <- integer(0, 59),
      second <- integer(0, 59)
    ] do
      "#{year}-#{pad2(month)}-#{pad2(day)}T#{pad2(hour)}:#{pad2(minute)}:#{pad2(second)}"
    end
  end

  property "parses a datetime of all valid time with +00:00 ending" do
    forall naive_datetime <- naive_datetimes() do
      :ok == IsoDatetime.isodatetime("#{naive_datetime}+00:00") |> elem(0)
    end
  end

  property "parses a datetime of all valid time with Z ending" do
    forall naive_datetime <- naive_datetimes() do
      :ok == IsoDatetime.isodatetime("#{naive_datetime}Z") |> elem(0)
    end
  end
end



