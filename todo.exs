defmodule TodoList do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add_task(title) do
    Agent.update(__MODULE__, fn tasks ->
      task = %{id: :erlang.unique_integer([:positive]), title: title, done: false}
      tasks ++ [task]
    end)
  end

  def list_tasks do
    Agent.get(__MODULE__, fn tasks ->
      Enum.each(tasks, fn task ->
        status = if task.done, do: "[x]", else: "[ ]"
        IO.puts("#{task.id}. #{status} #{task.title}")
      end)
    end)
  end

  def complete_task(id) do
    Agent.update(__MODULE__, fn tasks ->
      Enum.map(tasks, fn
        %{id: ^id} = task -> %{task | done: true}
        task -> task
      end)
    end)
  end

  def remove_task(id) do
    Agent.update(__MODULE__, fn tasks ->
      Enum.reject(tasks, fn task -> task.id == id end)
    end)
  end
end
