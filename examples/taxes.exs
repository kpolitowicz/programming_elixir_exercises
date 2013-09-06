# tax_rates = [ NC: 0.075, TX: 0.08 ]

# orders = [
#   [ id: 123, ship_to: :NC, net_amount: 100.00 ],
#   [ id: 124, ship_to: :OK, net_amount:  35.50 ],
#   [ id: 125, ship_to: :TX, net_amount:  24.00 ],
#   [ id: 126, ship_to: :TX, net_amount:  44.80 ],
#   [ id: 127, ship_to: :NC, net_amount:  25.00 ],
#   [ id: 128, ship_to: :MA, net_amount:  10.00 ],
#   [ id: 129, ship_to: :CA, net_amount: 102.00 ],
#   [ id: 120, ship_to: :NC, net_amount:  50.00 ] 
# ]

# Order.parse_from_file("/Users/kp/Projects/github/kpolitowicz/programming_elixir_exercises/examples/orders.txt") |> Order.calculate_tax(tax_rates) |> Order.print_orders

defrecord Order, id: nil, ship_to: :TX, net_amount: 0.00, sales_tax: 0.00, total_amount: 0.00 do
  import MyStrings, only: [center: 2, right: 2]

  def print_orders(orders) do
    print_header
    Enum.each(orders, &(&1.print))
  end

  def print_header do
    IO.puts "  id  | ship to | net value | total value"
    IO.puts "----- | ------- | --------- | -----------"
  end

  def id_to_s(record),           do: integer_to_binary(record.id)
  def ship_to_to_s(record),      do: atom_to_binary(record.ship_to)
  def net_amount_to_s(record),   do: float_to_binary(record.net_amount, [decimals: 2])
  def total_amount_to_s(record), do: float_to_binary(record.total_amount, [decimals: 2])

  def print(record) do
    IO.puts "#{right(record.id_to_s, 5)} | " <>
            "#{center(record.ship_to_to_s, 7)} | " <>
            "#{right(record.net_amount_to_s, 9)} | " <>
            "#{right(record.total_amount_to_s, 11)}"
  end

  def parse_from_file(filename) do
    file  = File.open!(filename)
    IO.read(file, :line) # ignore the first line

    parsed = IO.stream(file)
    |> Enum.map(&process_line/1)

    File.close(file)
    parsed
  end
  
  defp process_line(line) do
    data = String.strip(line) |> String.split(",")
    Order[id:         convert(:id, Enum.at(data, 0)), 
          ship_to:    convert(:ship_to, Enum.at(data, 1)),
          net_amount: convert(:net_amount, Enum.at(data, 2))]
  end

  defp convert(:id, str),         do: binary_to_integer(str)
  defp convert(:net_amount, str), do: binary_to_float(str)
  defp convert(:ship_to, str),    do: String.lstrip(str, ?:) |> binary_to_atom

  def calculate_tax(orders, rates) do
    Enum.map(orders, &(order_with_total_taxed(rates, &1)))
  end
  defp order_with_total_taxed(rates, order) do
    {_, tax_rate} = List.keyfind(rates, order.ship_to, 0, {order.ship_to, 0.0})

    order = order.sales_tax tax_rate
    order.total_amount order.net_amount * (1 + tax_rate)
  end
end
