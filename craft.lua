function checking_material(i)
  -- 素材の数とどのスロットにあるか確認する。
  -- ここ入れ子になってるのめちゃくちゃ気持ち悪い(けどこれが実力や…ここ1時間くらい悩んだ)
  for i = 1,9 do
    -- typeが0の時はチェックする(未確認か空欄)
    if TYPE_MATER[i] == 0  then
      if NUM_MATER[i] == 0 then
      else
        -- print(i .. "num")
        turtle.select(CRAFT_SLOT[i])
        TYPE_MATER_NUM = TYPE_MATER_NUM + 1
        TYPE_MATER[i] = TYPE_MATER_NUM
        -- 素材が同じならTYPEを同じ数字にする
        for j=i,9 do
          if turtle.compareTo(CRAFT_SLOT[j]) then
            TYPE_MATER[j] = TYPE_MATER[i]
          end
        end
      end
    end
  end
end

function move_material()
  print("material type:" .. TYPE_MATER_NUM)
  before = 1
  now = 1
  material = 1
  for i = 1,9 do
    sum_slot = 0   -- 素材ごとに利用する合計スロット
    sum_mate = 0   -- 素材ごとに利用する合計の素材
    many_slot = 0  -- 素材ごとの一番多いスロット
    if TYPE_MATER[i] ~= now then
      -- print("if   " .. i .. ":" .. TYPE_MATER[i] .. ":" .. now)
    else
      -- print("else " .. i .. ":" .. TYPE_MATER[i] .. ":" .. now)
      -- 合計を計算する
      -- print("sum calc")
      for j = 1,9 do
        if TYPE_MATER[j] == now then
          -- print("if  : " .. j .. ":" .. TYPE_MATER[j] .. ":" .. now)
          sum_slot = sum_slot + 1
          sum_mate = sum_mate + NUM_MATER[j]
        else
          -- print("else: " .. j .. ":" .. TYPE_MATER[j] .. ":" .. now)
        end
        -- sleep(1)
      end
      -- １つしかない素材は移動する必要はない
      if sum_slot == 1 then
        break
      end
      -- 一番素材が多いスロットを選択する。
      -- print("select slot")
      for j=1,8 do
        if TYPE_MATER[j] == now and TYPE_MATER[j] == TYPE_MATER[j+1] then
          if NUM_MATER[j] > NUM_MATER[j+1] or  many_slot == 0 then
            -- print("if  : " .. j .. ":" .. TYPE_MATER[j] .. ":" .. now .. "  " ..  NUM_MATER[j] .. ":" .. NUM_MATER[j+1] .. ":" .. many_slot)
            many_slot = CRAFT_SLOT[j]
          else
            -- print("else: " .. j .. ":" .. TYPE_MATER[j] .. ":" .. now .. "  " .. NUM_MATER[j] .. ":" .. NUM_MATER[j+1] .. ":" .. many_slot)
          end
        end
      end
      -- print("slot:" .. many_slot)
      print("slot:" .. sum_slot .. " num:" .. sum_mate )
      turtle.select(many_slot)
      -- print("select(" .. CRAFT_SLOT[i] .. ")")
      -- print("move item")
      for j = 1, 9 do
        if CRAFT_SLOT[j] ~= many_slot and TYPE_MATER[j] == now and (sum_mate / sum_slot) - NUM_MATER[j] > 0 then
          -- print("if  : ".. CRAFT_SLOT[j] .. ":" ..  many_slot )
          -- print("turtle.transferTo("..CRAFT_SLOT[j]..",".. (sum_mate / sum_slot) - NUM_MATER[j] .. ")")
          turtle.transferTo(CRAFT_SLOT[j], (sum_mate / sum_slot) - NUM_MATER[j] )
        else
          -- print("else: ".. CRAFT_SLOT[j] .. ":" ..  many_slot )
        end
      end
    end
    before = now
    if TYPE_MATER[i] == now then
      now = now + 1
    end
  end
end

function craft()
  num_craft = 0
  min = 1
  for i=1,9 do
    if NUM_MATER[min] > NUM_MATER[i] and NUM_MATER[i] > 0 then
      min = i
      print(min .. ":" .. NUM_MATER[min])
    end
  end
  num_craft = NUM_MATER[min] - 1
  print("number of craft:" .. num_craft)
  turtle.craft(num_craft)
end

PRODUCT_SLOT = 1                        -- 完成品スロット
CRAFT_SLOT = {6,7,8,10,11,12,14,15,16}  -- 1~9までのクラフトグリッドに対応するインベントリ番号
NUM_MATER = {0,0,0,0,0,0,0,0,0}         -- 素材がどのスロットと対応しているか
TYPE_MATER = {0,0,0,0,0,0,0,0,0} -- 同じ素材がないか確認する
TYPE_MATER_NUM = 0                      -- 素材の数

-- 材料の数を取得する
for i = 1, 9 do
  turtle.select(CRAFT_SLOT[i])
  NUM_MATER[i] = turtle.getItemCount(CRAFT_SLOT[i])
end

checking_material()

move_material()

-- 材料の数を取得する
for i = 1, 9 do
  turtle.select(CRAFT_SLOT[i])
  NUM_MATER[i] = turtle.getItemCount(CRAFT_SLOT[i])
end

turtle.select(1)
craft()
