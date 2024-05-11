local list = {}

function list:add(newVal) 
    table.insert(self, newVal)
end

function list:remove(index)
    self[index] = nil
end

function list:length()
    return #self
end

function list:showAll()
  print(#self)
  for i = 1, #self do
    print(self[i])
  end
end

list:add(1)
list:add(3)
list:add(4)
list:remove(2)
list:showAll()

