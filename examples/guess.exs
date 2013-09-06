defmodule Chop do
  def guess(n, range = a..b) when n in a..b, do: take(n, range)

  defp take(n, range), do: take(middle_value(range), n, range)
  defp take(guess, n, a..b) when guess < n and b - a == 1, do: takemsg(guess, n, b..b)
  defp take(guess, n, _..b) when guess < n, do: takemsg(guess, n, guess..b)
  defp take(guess, n, a.._) when guess > n, do: takemsg(guess, n, a..guess)
  defp take(guess, _, _), do: IO.puts guess
  defp takemsg(guess, n, range) do
    IO.puts "Is it #{guess}"
    take(n, range)
  end

  defp middle_value(a..b), do: div(b - a, 2) + a
end
