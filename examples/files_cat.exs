defmodule FileParser do 
  def count_occurences(scheduler) do
    scheduler <- { :ready, self }
    receive do
      { :count, file, word, client } ->
        client <- { :answer, file, _count_occurences(file, word), self }
        count_occurences(scheduler)
      { :shutdown } -> exit(0)
    end 
  end
  
  defp _count_occurences(filename, word) do
    (File.read!(filename) |> String.split(word) |> length) - 1
  end
end

defmodule Scheduler do
  def run(num_processes, module, func, word, to_calculate) do 
    (1..num_processes)
    |> Enum.map(fn(_) -> spawn(module, func, [self]) end) 
    |> schedule_processes(word, to_calculate, [])
  end

  defp schedule_processes(processes, word, queue, results) do 
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [ next | tail ] = queue
        pid <- {:count, next, word, self} 
        schedule_processes(processes, word, tail, results)
      {:ready, pid} ->
        pid <- {:shutdown}
        if length(processes) > 1 do
           schedule_processes(List.delete(processes, pid), word, queue, results)
        else
          Enum.sort(results, fn {n1,_}, {n2,_} -> n1 <= n2 end)
        end
      {:answer, file, result, _pid} ->
        schedule_processes(processes, word, queue, [ {file, result} | results ])
    end 
  end
end

dir = "/Users/kp/Projects/nimonik/Nimonik/app/views/checklists/items"
to_process = File.ls!(dir) 
             |> Enum.map(fn f -> Path.join(dir, f) end)
             |> Enum.reject(&File.dir?/1)

result = Scheduler.run length(to_process), FileParser, :count_occurences, "cat", to_process
Enum.each result, fn { file, count } -> IO.puts "#{file}: #{count}" end
