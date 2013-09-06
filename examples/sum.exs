defmodule Sum do
  def upto(0), do: 0
  def upto(n), do: n + upto(n-1)
end