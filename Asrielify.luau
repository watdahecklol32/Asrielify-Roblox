--!native
local Asrielify = {};
Asrielify.__index = Asrielify;

local TextService = game:GetService("TextService");

local function GetPastelRainbowColor(Time: number): Color3
	local R = (math.sin(0.024 * Time + 0) * 0.5 + 0.5) * 0.6 + 0.2;
	local G = (math.sin(0.024 * Time + 2) * 0.5 + 0.5) * 0.6 + 0.2;
	local B = (math.sin(0.024 * Time + 4) * 0.5 + 0.5) * 0.6 + 0.2;
	return Color3.fromRGB(R * 255, G * 255, B * 255)
end

local function GetRandomXY(MaxX: number, MaxY: number): (number, number)
	local X = math.random(-2 - MaxX, 2 + MaxX);
	local Y = math.random(-2 - MaxY, 2 + MaxY);
	
	return X, Y;
end;

local function GenerateLetters(NewText, Text: string, Len: number, _Font: Enum.Font, FontSize: number, IndexStart: number)
	local LastSize = Vector2.zero;
	local LastPosition = Vector2.zero;
	local TotalSize = TextService:GetTextSize(Text, FontSize, _Font, Vector2.zero);
	
	NewText.Container.Size = UDim2.new(0, TotalSize.X, 0, TotalSize.Y);
	
	for i = 1, NewText.Len do
		local Char = string.sub(Text, i, i);
		local Label = Instance.new("TextLabel");
		local VecLabelSize = TextService:GetTextSize(Char, FontSize, _Font, Vector2.zero);
		Label.Text = Char;
		Label.Name = i;
		Label.Parent = NewText.Container;
		Label.TextSize = FontSize;
		Label.BackgroundTransparency = 1;
		Label.Size = UDim2.new(0, VecLabelSize.X, 1, 0);
		Label.Position = UDim2.new(0, LastPosition.X + LastSize.X, 0, 0);
		Label.Font = _Font;
		Label.TextColor3 = Color3.fromRGB(255, 255, 255);
		NewText.NormalPositionX[i] = LastPosition.X + LastSize.X;
		
		if (NewText.Type == 1) then
			local UIGradient = Instance.new("UIGradient");
			UIGradient.Parent = Label;
		else
			if (IndexStart >= Len) then
				Label.TextTransparency = 0.65;
			end;
		end;
		
		LastSize = VecLabelSize;
		LastPosition = Vector2.new(Label.Position.X.Offset, 0);
		
		NewText.Letters[IndexStart + i] = Label;
	end;
end;

local function GenerateTrembleText(Text: string, _Font: Enum.Font, FontSize: number)
	local Len = string.len(Text);
	local NewText = {
		Len = Len,
		Container = Instance.new("Frame"),
		Letters = table.create(Len * 5, nil),
		NormalPositionX = table.create(Len, 0),
		Time = os.clock(),
		Type = 2,
		Speed = 5
	};
	
	for i = 1, 5 do
		GenerateLetters(NewText, Text, Len, _Font, FontSize, Len * (i - 1));
	end;
	
	return NewText;
end;

local function GenerateWaveText(Text: string, _Font: Enum.Font, FontSize: number)
	local Len = string.len(Text);
	local NewText = {
		Len = Len,
		Container = Instance.new("Frame"),
		Letters = table.create(Len, nil),
		NormalPositionX = table.create(Len, 0),
		Time = os.clock(),
		Type = 1,
		Speed = 5
	};
	
	GenerateLetters(NewText, Text, Len, _Font, FontSize, 0);
	
	return NewText;
end;

local function TrembleText(self, StartIndex: number)
	local X, Y = GetRandomXY(self.Letters[1].AbsoluteSize.X / 4, self.Letters[1].AbsoluteSize.Y / 8);
	
	if (StartIndex == 0) then
		for i = 1, self.Len do
			local Label = self.Letters[StartIndex + i];
			local PosX = self.NormalPositionX[i];

			Label.Position = UDim2.new(0, PosX + X / 8, 0, 0 + Y / 8);
		end;
	else
		for i = 1, self.Len do
			local Label = self.Letters[StartIndex + i];
			local PosX = self.NormalPositionX[i];

			Label.Position = UDim2.new(0, PosX + X, 0, 0 + Y);
		end;
	end;
end

--[[
Asrielify.new creates a new Asrielify object.
Every .PreRender, :Step method must be called to update the effect.
:Destroy should be called to destroy the Container object.
Type can either be "Tremble" or "Wave". "Tremble" is the first type of font when Asriel's name is revealed.
"Wave" is the style the text is shown when you're going to the ACT menu. Other parameters are self explanatory.

@param preferably a string or something which can be converted to one.
@param where should the container be parented to. `nil` is illegal.
@param string which is either "Tremble" or "Wave".
@param the font to be used.
@param the font size.
@return object.
--]]
function Asrielify.new(Text: string, Parent: Instance, Type: string, _Font: Enum.Font, FontSize: number)
	if (Type ~= "Tremble" and Type ~= "Wave") then
		print(`{Type} is an invalid type. Accepted types are: "Tremble" and "Wave".`);
		return nil;
	end;
	
	if (typeof(Parent) ~= "Instance") then
		print(`{Parent} is not a valid Instance. Parent must be an Instance.`);
		return nil;
	end
	
	if (not tostring(Text)) then
		print(`Text parameter cannot be converted to a valid string.`);
		return nil;
	end;
	
	Text = tostring(Text);
	
	local NewText = Type == "Tremble" and GenerateTrembleText(Text, _Font, FontSize) or GenerateWaveText(Text, _Font, FontSize);
	
	NewText.Container.AnchorPoint = Vector2.new(0.5, 0.5);
	NewText.Container.Position = UDim2.new(0.5, 0, 0.5, 0);
	NewText.Container.Parent = Parent;
	NewText.Container.Name = `{Text}_Container`;
	NewText.Container.BackgroundTransparency = 1;
	NewText.Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	
	setmetatable(NewText, Asrielify);
	return NewText;
end;

function Asrielify:Destroy()
	self.Container:Destroy();
end;

function Asrielify:Step()
	local Ratio = 1 / self.Len;
	
	if (self.Type == 1) then
		for i = 1, self.Len do
			local Label = self.Letters[i];
			local Pos = self.NormalPositionX[i];
			local Color = GetPastelRainbowColor(10 * i + self.Time * 200);
			Label.Position = UDim2.new(
				0, 10 + Pos + 5 * math.sin(0.1 * i + self.Time * self.Speed),
				0, 5 * math.cos(0.1 * i + self.Time * self.Speed)
			);
			Label.UIGradient.Color = ColorSequence.new(Color, Color);
		end;

		self.Time = os.clock();
	else
		if (self.Len == 0) then
			return;
		end;
		
		TrembleText(self, 0);
		TrembleText(self, self.Len);
		TrembleText(self, self.Len * 2);
		TrembleText(self, self.Len * 3);
		TrembleText(self, self.Len * 4);
	end;
end;

return Asrielify;
