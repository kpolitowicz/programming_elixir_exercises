tax_rates = [ NC: 0.075, TX: 0.08 ]

orders = [
  [ id: 123, ship_to: :NC, net_amount: 100.00 ],
  [ id: 124, ship_to: :OK, net_amount:  35.50 ],
  [ id: 125, ship_to: :TX, net_amount:  24.00 ],
  [ id: 126, ship_to: :TX, net_amount:  44.80 ],
  [ id: 127, ship_to: :NC, net_amount:  25.00 ],
  [ id: 128, ship_to: :MA, net_amount:  10.00 ],
  [ id: 129, ship_to: :CA, net_amount: 102.00 ],
  [ id: 120, ship_to: :NC, net_amount:  50.00 ] 
]

defmodule Taxes do
  def for(rates, orders) do
    Enum.map(orders, &(order_with_total_taxed(rates, &1)))
  end
  defp order_with_total_taxed(rates, order) do
    {_, net_amount} = List.keyfind(order, :net_amount, 0) 
    {_, ship_to}    = List.keyfind(order, :ship_to, 0)
    {_, tax_rate}   = List.keyfind(rates, ship_to, 0, {ship_to, 0.0})

    order ++ [total_amount: net_amount * (1 + tax_rate)]
  end

  def parse_from_file(filename) do
    file = File.open!(filename)
    keys = parse_header(IO.read(file, :line))

    parsed = IO.stream(file)
    |> Enum.map(&process_line(&1, keys))

    File.close(file)
    parsed
  end
  
  defp parse_header(str) do    
    String.strip(str)
    |> String.split(",")
    |> Enum.map &binary_to_atom/1 
  end
  defp process_line(line, keys) do
    data = String.strip(line) |> String.split(",")
    List.zip([keys, data]) |> convert_values
  end
  defp convert_values(data) do
    Enum.map data, fn {key, val} -> { key, convert(key, val) } end
  end

  defp convert(:id, str),         do: binary_to_integer(str)
  defp convert(:net_amount, str), do: binary_to_float(str)
  defp convert(:ship_to, str),    do: binary_to_atom(String.lstrip(str, ?:))
  defp convert(_, str),           do: str
end
