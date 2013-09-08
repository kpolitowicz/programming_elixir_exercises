import :timer, only: [ sleep: 1 ]

defmodule Spawn1 do
  def send_back(sender) do 
    raise "Bugger off!"
    # sender <- "Bugger off!"
    # exit(99)
  end

  def receive_loop do
    receive do
      message ->
        IO.puts inspect(message)
        receive_loop
    end
  end
end

Process.spawn_link(Spawn1, :send_back, [self])
sleep 500
IO.puts "receiving..."
Spawn1.receive_loop
