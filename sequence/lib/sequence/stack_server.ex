defmodule Stack.Server do 
  use GenServer.Behaviour

  def init(stack) when is_list(stack) do
    { :ok, stack }
  end

  def handle_call(:pop, _from, current_stack) do 
    [ head | tail ] = current_stack
    { :reply, head, tail }
  end 


  def handle_cast({:push, elem}, current_stack) do 
    { :noreply, [ elem | current_stack ]}
  end
end