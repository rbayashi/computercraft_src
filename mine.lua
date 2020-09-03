DEFAULT_SLOT = 1
MAX_USE_SLOT = 14
TORCH_SLOT = 15
CHEST_SLOT = 16
DEBUG = false
-- 15 is torch
-- 16 is chest
function forward(move)
  move = move or 1
  for i = 1, move do
    turtle.digUp()
    turtle.digDown()
    if i % 9 == 0 then
      turtle.select(TORCH_SLOT)
      turtle.placeDown()
      turtle.select(DEFAULT_SLOT)
    end
    while turtle.dig() do end
    r,e = turtle.forward()
    if r == false then
      move_err(e)
    end
    inv_check()
  end
end
function right()
  turtle.turnRight()
end
function left()
  turtle.turnLeft()
end
function turn()
  right()
  right()
end
function branch()
  forward(4)
  right()
end
function put_in_chest()
  turtle.back()
  turtle.select(CHEST_SLOT)
  turtle.placeDown()
  for i = DEFAULT_SLOT,MAX_USE_SLOT do
    turtle.select(i)
    turtle.dropDown(turtle.getItemCount(i))
  end
  turtle.select(DEFAULT_SLOT)
  turtle.forward()
end
function not_chest()
  os.pullEvent("turtle_inventory")
  inv_check()
end
function move_err(error)
  os.pullEvent("turtle_inventory")
  if error == "Movement obstructed" then
    turtle.forward()
    return
  else
    r,e = turtle.refuel()
    if r == false then
      err(e)
    end
  end
  return
end
function inv_check()
  if turtle.getItemCount(12) == 0 then return end
  if turtle.getItemCount(CHEST_SLOT) == 0 then not_chest() end
  put_in_chest()
end
function move(skip)
  for i = 1,skip do
    if DEBUG == true then
      print (i .. "skip!")
    end
    forward(4)
    left()
    forward(4)
    right()
  end
end
function mine(n,skip)
  n = n - 1
  for i = skip, skip + n do
    if DEBUG == true then
      rint (skip .." skip " .. i .. "mine")
    end
    forward(4)
    left()
    forward(4)
    right()
    for j = 1,4 do
      branch()
      forward(4 + 8 * (i))
    end
  end
end
function branch_mining(n, skip)
  turtle.select(DEFAULT_SLOT)
  move(skip)
  mine(n,skip)
  turtle.back()
end

args = {...}
args1 = args[1] or 10
args2 = args[2] or 0
branch_mining(args1,args2)
