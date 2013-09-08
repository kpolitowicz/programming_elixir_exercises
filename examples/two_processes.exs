defmodule Processes do
  def send_back do 
    receive do
      { sender, msg } -> sender <- msg
    end 
  end
end

pid1 = spawn(Processes, :send_back, [])
pid2 = spawn(Processes, :send_back, [])
pid1 <- {self, "fred"} 
pid2 <- {self, "betty"}

receive do
  message ->
    IO.puts message
end
receive do
  message ->
    IO.puts message
end