defmodule Parsers.IsoDatetime do
  import NimbleParsec

  date =
    integer(4)
    |> ignore(string("-"))
    |> integer(2)
    |> ignore(string("-"))
    |> integer(2)

  time =
    integer(2)
    |> ignore(string(":"))
    |> integer(2)
    |> ignore(string(":"))
    |> integer(2)
    |> choice([
        string("+00:00"),
        string("Z")
      ])

  isodatetime =
    date
    |> ignore(string("T"))
    |> concat(time)

  @doc """
  {:ok, acc, rest, context, line, offset}
  {:error, "some error message", rest, context, line, offset}
  """
  defparsec :isodatetime, isodatetime
end
