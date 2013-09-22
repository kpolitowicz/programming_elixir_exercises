defmodule Sequence.Server do 
  use GenServer.Behaviour

  def init(current_number) when is_number(current_number) do
    { :ok, current_number }
  end

  def handle_call(:next_number, _from, current_number) do 
    { :reply, current_number, current_number+1 }
  end 

  def handle_cast({:increment_number, delta}, current_number) do 
    { :noreply, current_number + delta}
  end
end