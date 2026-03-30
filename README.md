# Asrielify-Roblox
An (almost) accurate and optimized remake of two Undertale font systems.
Up to 700x faster.

# Showcase
![](https://github.com/Ducking-Entertainment/Asrielify-Roblox/blob/main/showcase.gif)

# Example
```lua
--!strict
--!native
const module = require(game:GetService("ReplicatedStorage").better);
const wave: {[string]: any} = module.new("hello world", script.Parent, "Wave", Enum.Font.Arcade, 14, 10);
game:GetService("RunService").PreRender:Connect(@native function(_: number): () 
	return wave:Step();
end);
```
