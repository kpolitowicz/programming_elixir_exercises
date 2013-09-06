defmodule MyList do
  def sum([]), do: 0
  def sum([ h | t ]), do: h + sum(t)

  def mapsum([], _), do: 0
  def mapsum([ h | t ], func), do: func.(h) + mapsum(t, func)

  def max([]), do: nil
  def max([ h | t ]), do: _max(t, h)

  defp _max([], current_max), do: current_max
  defp _max([ h | t ], current_max) when h > current_max, do: _max(t, h)
  defp _max([ h | t ], current_max) when h <= current_max, do: _max(t, current_max)

  def caesar([], _), do: []
  def caesar([ h | t ], shift), do: [_shifted(h + shift) | caesar(t, shift)]

  defp _shifted(ch) when ch > ?z, do: ch - (?z-?a+1)
  defp _shifted(ch) when ch < ?a, do: ch + (?z-?a+1)
  defp _shifted(ch), do: ch

  # def span(from, to) when from <= to, do: Enum.to_list(from..to)
  def span(from, to) when from < to, do: [from | span(from + 1, to)]
  def span(n, n), do: [n]

  def all?([h|t], fun // fn x -> x end), do: fun.(h) and all?(t, fun)
  def all?([], _), do: true

  def filter([], _), do: []
  def filter([h|t], fun) do 
    if fun.(h) do
      [h | filter(t, fun)]
    else
      filter(t, fun)
    end
  end

  def each([], _), do: :ok
  def each([h|t], fun) do
    fun.(h)
    each(t, fun)
  end

  def flatten([]), do: []
  def flatten([h | t]) when is_list(h), do: flatten(h) ++ flatten(t)
  def flatten([h | t]), do: [h | flatten(t)]

  def primes(n), do: Enum.reverse(_primes(n))
  defp _primes(2), do: [2]
  defp _primes(n) when n > 2 do
    prev_primes = _primes(n-1)
    if prime?(n, prev_primes) do
      [n | prev_primes]
    else
      prev_primes
    end
  end
  defp prime?(n, prev_primes) do
    limit = :math.sqrt(n)
    Enum.empty?(Enum.filter(prev_primes, fn x -> x <= limit and rem(n, x) == 0 end))
  end
end