defmodule Main do
  alias Parsers.IsoDatetime

  @moduledoc """
  A collection of parsec parers for fun :)
  """

  def main do
    IsoDatetime.isodatetime(IO.gets("isodatetime?: "))
  end
end
