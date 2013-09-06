defmodule MyStrings do
  def printable?(str) do
    Enum.all?(str, fn x -> x in ? ..?~ end)
  end

  def anagram?(word1, word2), do: Enum.empty?((word1 -- word2) ++ (word2 -- word1))

  def calculate(str) do
    { number1, operator, number2 } = split_calc(str, [])
    _calculate(operator, parse_num(number1), parse_num(number2))
  end

  defp _calculate(?+, num1, num2), do: num1 + num2
  defp _calculate(?-, num1, num2), do: num1 - num2
  defp _calculate(?*, num1, num2), do: num1 * num2
  defp _calculate(?/, num1, num2), do: num1 / num2

  # defp split_calc(str), do: Enum.map(String.split(list_to_binary(str)), &(String.to_char_list!(&1)))
  defp split_calc([h | tail], acc) when h in '+-*/', do: { Enum.reverse(acc), h, tail }
  defp split_calc([h | tail], acc), do: split_calc(tail, [h | acc])
  defp split_calc([], acc), do: raise "No operator given in '#{Enum.reverse(acc)}'" 

  def parse_num(str), do: _number_digits(str, 0)
  defp _number_digits([], value), do: value 
  defp _number_digits([ ?  | tail ], value), do: _number_digits(tail, value)
  defp _number_digits([ digit | tail ], value) when digit in '0123456789' do
    _number_digits(tail, value*10 + digit - ?0)
  end
  defp _number_digits([ non_digit | _ ], _) do
    raise "Invalid digit '#{[non_digit]}'" 
  end

  def center(list) do
    max_length = Enum.max(Enum.map(list, &(String.length(&1))))
    Enum.each(list, &(IO.puts _center(&1, max_length)))
  end

  defp _center(str, max_length) do
    diff  = max_length - String.length(str)
    left  = div(diff, 2)
    right = diff - left

    "#{String.duplicate(" ", left)}#{str}#{String.duplicate(" ", right)}"
  end

  def capitalize_sentences(str), do: _capitalize_sentences(str, true)

  defp _capitalize_sentences("", _), do: ""
  defp _capitalize_sentences(<< ?. :: utf8, tail :: binary >>, _) do
    ".#{_capitalize_sentences(tail, true)}"
  end
  defp _capitalize_sentences(<< ?  :: utf8, tail :: binary >>, flag) do
    " #{_capitalize_sentences(tail, flag)}"
  end
  defp _capitalize_sentences(<< ch :: utf8, tail :: binary >>, true) do
    "#{String.upcase(list_to_binary([ch]))}#{_capitalize_sentences(tail, false)}"
  end
  defp _capitalize_sentences(<< ch :: utf8, tail :: binary >>, false) do
    "#{String.downcase(list_to_binary([ch]))}#{_capitalize_sentences(tail, false)}"
  end
end
