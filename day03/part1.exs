# Math borrowed from https://www.reddit.com/r/adventofcode/comments/7h7ufl/2017_day_3_solutions/dqoxrb7/
input             = 347991
root              = input |> :math.sqrt |> Float.ceil |> round
currentSideLength = if ((rem(root, 2)) != 0), do: root, else: root + 1
distanceToCenter  = (currentSideLength - 1) / 2
cycle             = input - (:math.pow((currentSideLength - 2), 2))
innerOffset       = rem(round(cycle), (currentSideLength - 1))
manhattanDistance = round(distanceToCenter + abs(innerOffset - distanceToCenter))

IO.inspect manhattanDistance

# Part II can be found at:
# https://oeis.org/A141481/b141481.txt
