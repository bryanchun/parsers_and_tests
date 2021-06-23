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
      string("null")
    ])


  defp ascii_to_integer(ascii), do: ascii - 48
  number =
    optional(string("-"))
    |> choice([
      ascii_char([?0]) |> map({:ascii_to_integer, []}),
      ascii_char([?1..?9]) |> map({:ascii_to_integer, []})
        |> repeat(integer(1))
    ])
    |> optional(
      string(".") |> times(integer(1), min: 1)
    )


  quoted_string =
    ascii_char([?"])
    |> repeat(
       lookahead_not(ascii_char([?"]))
       |> utf8_char([])
    )
    |> ascii_char([?"])
    |> reduce({List, :to_string, []})

  defcombinatorp :kv_pair,
    quoted_string |> tag(:string) |> string(":") |> parsec(:value)

  defcombinatorp :object,
#    string("{")
#    |> choice([
#      string("}"),
#      parsec(:kv_pair)
#        |> repeat(
#          string(",")
#          |> parsec(:kv_pair)
#        )
#        |> string("}")
#    ])
     string("{")
     |> optional(
       parsec(:kv_pair)
       |> repeat(
          string(",")
          |> parsec(:kv_pair)
       )
     )
     |> string("}")

  defcombinatorp :array,
    string("[")
    |> optional(
      parsec(:value)
      |> repeat(
        string(",")
        |> parsec(:value)
      )
    )
    |> string("]")

  defcombinatorp :value,
    choice([
      primitive,
      number |> tag(:number),
      quoted_string |> tag(:string),
      parsec(:object) |> tag(:object),
      parsec(:array) |> tag(:array),
    ])

  defparsec :parse, parsec(:value)
end