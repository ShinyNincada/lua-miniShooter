function CreateCollisionClasses()
    World:addCollisionClass('Ignore', {ignores = {'Ignore'}})
    World:addCollisionClass('Ground', {ignores = {'Ignore'}})
    World:addCollisionClass('Player', {ignores = {'Ignore'}})
    World:addCollisionClass('Wall', {ignores = {'Ignore'}})
    World:addCollisionClass('Enemy', {ignores = {'Ignore'}})
    World:addCollisionClass('Projectile', {ignores = {'Ignore', 'Player', 'Ground'}})
end