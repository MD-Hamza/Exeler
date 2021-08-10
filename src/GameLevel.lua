GameLevel = Class{}

function GameLevel:init(map, entities, objects)
    self.map = map
    self.entities = entities
    self.objects = objects
end

function GameLevel:clear()
	for i = 1, #self.entities do
		if not self.entities[i] then
			table.remove(self.entities, i)
		end
	end	

	for i = 1, #self.objects do
		if not self.objects[i] then
			table.remove(self.objects, i)
		end
	end
end

function GameLevel:update(dt)
	for k, entity in pairs(self.entities) do
		entity:update(dt)
	end	

	for k, object in pairs(self.objects) do
		object:update(dt)
	end
end

function GameLevel:render()
	self.map:render()

	for k, entity in pairs(self.entities) do
		entity:render()
	end

	for k, object in pairs(self.objects) do
		object:render()
	end
end