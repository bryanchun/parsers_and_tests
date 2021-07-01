defmodule Parsers.Json do
  @doc """
  JSON specification parser (subset)
  https://www.json.org/json-en.html
  """

  import NimbleParsec

  primitive =
    choice([
      string("true"),
      string("false"),
      string("null"),
    ])

  defcombinatorp :whitespace,
    ignore(
      repeat(
        ascii_char([
          ?\s, ?\n, ?\r, ?\t,
        ])
      )
    )

  defp ascii_to_integer(ascii), do: ascii - ?0
  number =
    optional(string("-"))
    |> choice([
      ascii_char([?0])
        |> map({:ascii_to_integer, []}),
      ascii_char([?1..?9])
        |> map({:ascii_to_integer, []})
        |> repeat(integer(1)),
    ])
    |> optional(
      string(".") |> times(integer(1), min: 1)
    )

  defcombinatorp :quoted_string,
    ascii_char([?"])
    |> repeat(
       lookahead_not(ascii_char([?"]))
       |> utf8_char([])
    )
    |> ascii_char([?"])
    |> reduce({List, :to_string, []})

  defcombinatorp :kv_pair,
    parsec(:whitespace)
    |> parsec(:quoted_string) |> tag(:string)
    |> parsec(:whitespace)
    |> string(":")
    |> parsec(:value)

  defcombinatorp :object,
     string("{")
     |> choice([
       parsec(:kv_pair)
       |> repeat(
          string(",")
          |> parsec(:kv_pair)
       ),
       parsec(:whitespace),
     ])
     |> string("}")

  defcombinatorp :array,
    string("[")
    |> choice([
      parsec(:value)
      |> repeat(
        string(",")
        |> parsec(:value)
      ),
      parsec(:whitespace),
    ])
    |> string("]")

  defcombinatorp :value,
    parsec(:whitespace)
    |> choice([
      primitive,
      number |> tag(:number),
      parsec(:quoted_string) |> tag(:string),
      parsec(:object) |> tag(:object),
      parsec(:array) |> tag(:array),
    ])
    |> parsec(:whitespace)

  # TODO: convert to elixir map and list to complete deserialization?
  # TODO: try benchmarking? https://github.com/michalmuskala/jason
  defparsec :parse, parsec(:value)
end
