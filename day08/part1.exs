defmodule Memory do
  def get(map, key) do
    Map.get(map, key, 0)
  end

  def execute(line, regs) do
    [modification, condition] = String.split(line, " if ")

    if eval_condition(regs, condition) do
      Memory.modify(regs, String.split(modification))
    else
      regs
    end
  end

  def eval_condition(regs, condition) do
    reg = condition |> String.split |> List.first |> String.to_atom
    binding = [{reg, get(regs, reg)}]
    {return, _} = Code.eval_string(condition, binding)
    return
  end

  def modify(regs, [reg, "inc", value]) do
    reg = String.to_atom(reg)
    Map.put(regs, reg, get(regs, reg) + String.to_integer(value))
  end

  def modify(regs, [reg, "dec", value]) do
    reg = String.to_atom(reg)
    Map.put(regs, reg, get(regs, reg) - String.to_integer(value))
  end
end

File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.reduce(%{}, &Memory.execute/2)
|> Map.values
|> Enum.max
|> IO.inspect
