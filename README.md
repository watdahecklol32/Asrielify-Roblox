# Asrielify-Roblox
An (almost) accurate and optimized remake of two Undertale font systems.

# Showcase
![](https://github.com/Ducking-Entertainment/Asrielify-Roblox/blob/main/showcase.gif)

# Example
```lua
local Asrielify = require("./Asrielify");
local Wave = Asrielify.new("Asriel Dreemurr", script.Parent.Wave, "Wave", Enum.Font.Arcade, 14);
local Tremble = Asrielify.new("Asriel Dreemurr", script.Parent.Tremble, "Tremble", Enum.Font.Arcade, 24);

script.Parent.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
	Wave:Destroy();
	Tremble:Destroy();
	Wave = Asrielify.new(script.Parent.TextBox.Text, script.Parent.Wave, "Wave", Enum.Font.Arcade, 14);
	Tremble = Asrielify.new(script.Parent.TextBox.Text, script.Parent.Tremble, "Tremble", Enum.Font.Arcade, 24);
end);

game:GetService("RunService").PreRender:Connect(function()
	Wave:Step();
	Tremble:Step();
end);
```
