--!strict
--!native
--!optimize 2
const constructor_func = @native @checked function(Text: string, Parent: Instance, Type: string, _Font: Enum.Font, font_size_uint: number, speed_uint: number?): {[string]: any} -- .new
	if (Type ~= "Tremble" and Type ~= "Wave") then
		return error(`{Type} is an invalid type. Accepted types are: "Tremble" and "Wave".`, 2) :: never;
	elseif (typeof(Parent) ~= "Instance") then
		return error(`{Parent} is not a valid Instance. Parent must be an Instance.`, 2) :: never;
	--[[[elseif (not tostring(Text)) then -- ??????? i have so many questions but i will keep my mouth shut
		return error(`Text parameter cannot be converted to a valid string.`, 2) :: never;
	end;]]
	elseif (speed_uint and type(speed_uint) ~= "number") then
		return error(`Speed parameter is not a number!`, 2) :: never;
	end;
	const type_uint: number = (Type == "Wave" and 1 or 2);
	const text_service: TextService = game:GetService("TextService");
	local index_star_uint: number = 0;
	const str_len_uint: number = string.len(Text);
	const container: Frame = Instance.new("Frame");
	const NormalPositionX = table.create(str_len_uint, 0) :: {[number]: number};
	const Letters = table.create((str_len_uint * 5), nil) :: {[number]: TextLabel};
	local self: {[string]: any} = {
		Len = str_len_uint;
		Container = container;
		Time = os.clock(),
		Letters = Letters;
		NormalPositionX = NormalPositionX;
		type = type_uint,
		Speed = (speed_uint or 5);
	};
	const vec_zero: Vector2 = Vector2.zero;
	local last_size: Vector2 = vec_zero;
	local last_pos: Vector2 = vec_zero;
	const itteration_ctn: number = (type_uint == 2 and 5 or 1);
	for x: number = 1, (itteration_ctn) do
		const size_vector: Vector2 = text_service:GetTextSize(Text, font_size_uint, _Font, vec_zero);
		container.Size = UDim2.new(0, size_vector.X, 0, size_vector.Y);
		last_size = Vector2.zero;
		last_pos = Vector2.zero; 
		for i: number = 1, (str_len_uint) do
			index_star_uint += 1;
			const uwu: number = (last_pos.X + last_size.X);
			const char_str: string = string.sub(Text, i, i);
			const char_size: Vector2 = text_service:GetTextSize(char_str, font_size_uint, _Font, vec_zero);
			const label: TextLabel = Instance.new("TextLabel");
			label.Text = char_str;
			label.Name = tostring(i);
			label.Parent = container;
			label.TextSize = font_size_uint;
			label.BackgroundTransparency = 1;
			label.Size = UDim2.new(0, char_size.X, 1, 0);
			label.Position = UDim2.new(0, uwu, 0, 0);
			label.Font = _Font;
			label.TextColor3 = Color3.fromRGB(255, 255, 255);
			if (x == 1) then
				NormalPositionX[i] = uwu;
			end; 
			--NormalPositionX[i] = (x == 1 and uwu or nil);
			if (type_uint == 1) then
				const UIGradient: UIGradient = Instance.new("UIGradient");
				UIGradient.Parent = label;
			else
				--warn("work please");
				label.TextTransparency = ((index_star_uint >= str_len_uint) and 0.65 or label.TextTransparency);
			end;
			last_size = char_size;
			last_pos = Vector2.new(label.Position.X.Offset, 0);
			Letters[((x - 1) * str_len_uint + i)] = label;
		end;
	end;
	self.Step = @native @checked function(self: {[string]: any}): ()
		const len: number = self.Len;
		const speed: number = self.Speed;
		local index_uint: number = 1;
		const letters: {[number]: TextLabel} = self.Letters;
		if (self.type == 1) then
			for i: number = 1, (len) do
				const _time: number = self.Time;
				const label: Frame & {["UIGradient"]: UIGradient} = self.Letters[i];
				const pos: number = self.NormalPositionX[i];
				const time_float: number = ((10 * i + _time * 200));
				const color: Color3 = Color3.fromRGB(((math.sin(0.024 * time_float + 0) * 0.5 + 0.5) * 0.6 + 0.2) * 255, ((math.sin(0.024 * time_float + 2) * 0.5 + 0.5) * 0.6 + 0.2) * 255, ((math.sin(0.024 * time_float + 4) * 0.5 + 0.5) * 0.6 + 0.2) * 255);
				label.Position = UDim2.new(0, 10 + pos + 5 * math.sin(0.1 * i + _time * speed), 0, 5 * math.cos(0.1 * i + _time * speed));
				label.UIGradient.Color = ColorSequence.new(color, color);
			end;
			self.Time = os.clock();
		elseif (len ~= 0) then
			const first_letter: TextLabel = letters[1];
			const max_x: number = (first_letter.AbsoluteSize.X / 4);
			const NormalPositionX: {[number]: number} = self.NormalPositionX;
			const max_y: number = (first_letter.AbsoluteSize.Y / 8);
			const X: number = math.random(-2 - max_x, 2 + max_x);
			const Y: number = math.random(-2 - max_y, 2 + max_y);
			for index_uint: number = 1, (len*5) do
				const i: number = ((index_uint - 1) % len + 1);
				const mew: number = math.floor((index_uint - 1) / len);
				const label: TextLabel = letters[index_uint];
				const pos_x: number = NormalPositionX[i];
				label.Position = (mew == 1 and UDim2.new(0, pos_x + X / 8, 0, Y / 8) or UDim2.new(0, pos_x + X, 0, Y));
			end;
		end;
		return;
	end;
	const container = self.Container;
	container.AnchorPoint = Vector2.new(0.5, 0.5);
	container.Position = UDim2.new(0.5, 0, 0.5, 0);
	container.Parent = Parent;
	container.Name = `{Text}_Container`;
	container.BackgroundTransparency = 1;
	container.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	return self;
end;
return {
	new = constructor_func;
}
--[[
old bytecode
Function 0 (GetPastelRainbowColor):
8: MULK R7 R0 K4 [0.024]
8: ADDK R6 R7 K3 [0]
8: FASTCALL1 24 R6 L0
8: GETIMPORT R5 7 [math.sin]
8: CALL R5 1 1
8: L0: MULK R4 R5 K2 [0.5]
8: ADDK R3 R4 K2 [0.5]
8: MULK R2 R3 K1 [0.59999999999999998]
8: ADDK R1 R2 K0 [0.20000000000000001]
9: MULK R8 R0 K4 [0.024]
9: ADDK R7 R8 K8 [2]
9: FASTCALL1 24 R7 L1
9: GETIMPORT R6 7 [math.sin]
9: CALL R6 1 1
9: L1: MULK R5 R6 K2 [0.5]
9: ADDK R4 R5 K2 [0.5]
9: MULK R3 R4 K1 [0.59999999999999998]
9: ADDK R2 R3 K0 [0.20000000000000001]
10: MULK R9 R0 K4 [0.024]
10: ADDK R8 R9 K9 [4]
10: FASTCALL1 24 R8 L2
10: GETIMPORT R7 7 [math.sin]
10: CALL R7 1 1
10: L2: MULK R6 R7 K2 [0.5]
10: ADDK R5 R6 K2 [0.5]
10: MULK R4 R5 K1 [0.59999999999999998]
10: ADDK R3 R4 K0 [0.20000000000000001]
11: GETIMPORT R4 12 [Color3.fromRGB]
11: MULK R5 R1 K13 [255]
11: MULK R6 R2 K13 [255]
11: MULK R7 R3 K13 [255]
11: CALL R4 3 -1
11: RETURN R4 -1
Function 1 (GetRandomXY):
15: GETIMPORT R2 2 [math.random]
15: SUBRK R3 K3 [-2] R0
15: ADDK R4 R0 K4 [2]
15: CALL R2 2 1
16: GETIMPORT R3 2 [math.random]
16: SUBRK R4 K3 [-2] R1
16: ADDK R5 R1 K4 [2]
16: CALL R3 2 1
18: RETURN R2 2
Function 2 (GenerateLetters):
22: GETIMPORT R6 2 [Vector2.zero]
23: GETIMPORT R7 2 [Vector2.zero]
24: GETUPVAL R8 0
24: MOVE R10 R1
24: MOVE R11 R4
24: MOVE R12 R3
24: GETIMPORT R13 2 [Vector2.zero]
24: NAMECALL R8 R8 K3 ['GetTextSize']
24: CALL R8 5 1
26: GETTABLEKS R9 R0 K4 ['Container']
26: GETIMPORT R10 7 [UDim2.new]
26: LOADN R11 0
26: GETTABLEKS R12 R8 K8 ['X']
26: LOADN R13 0
26: GETTABLEKS R14 R8 K9 ['Y']
26: CALL R10 4 1
26: SETTABLEKS R10 R9 K10 ['Size']
28: LOADN R11 1
28: GETTABLEKS R9 R0 K11 ['Len']
28: LOADN R10 1
28: FORNPREP R9 L4
29: L0: FASTCALL3 45 R1 R11 R11 L1
29: MOVE R13 R1
29: MOVE R14 R11
29: MOVE R15 R11
29: GETIMPORT R12 14 [string.sub]
29: CALL R12 3 1
30: L1: GETIMPORT R13 16 [Instance.new]
30: LOADK R14 K17 ['TextLabel']
30: CALL R13 1 1
31: GETUPVAL R14 0
31: MOVE R16 R12
31: MOVE R17 R4
31: MOVE R18 R3
31: GETIMPORT R19 2 [Vector2.zero]
31: NAMECALL R14 R14 K3 ['GetTextSize']
31: CALL R14 5 1
32: SETTABLEKS R12 R13 K18 ['Text']
33: SETTABLEKS R11 R13 K19 ['Name']
34: GETTABLEKS R15 R0 K4 ['Container']
34: SETTABLEKS R15 R13 K20 ['Parent']
35: SETTABLEKS R4 R13 K21 ['TextSize']
36: LOADN R15 1
36: SETTABLEKS R15 R13 K22 ['BackgroundTransparency']
37: GETIMPORT R15 7 [UDim2.new]
37: LOADN R16 0
37: GETTABLEKS R17 R14 K8 ['X']
37: LOADN R18 1
37: LOADN R19 0
37: CALL R15 4 1
37: SETTABLEKS R15 R13 K10 ['Size']
38: GETIMPORT R15 7 [UDim2.new]
38: LOADN R16 0
38: GETTABLEKS R18 R7 K8 ['X']
38: GETTABLEKS R19 R6 K8 ['X']
38: ADD R17 R18 R19
38: LOADN R18 0
38: LOADN R19 0
38: CALL R15 4 1
38: SETTABLEKS R15 R13 K23 ['Position']
39: SETTABLEKS R3 R13 K24 ['Font']
40: GETIMPORT R15 27 [Color3.fromRGB]
40: LOADN R16 255
40: LOADN R17 255
40: LOADN R18 255
40: CALL R15 3 1
40: SETTABLEKS R15 R13 K28 ['TextColor3']
41: GETTABLEKS R15 R0 K29 ['NormalPositionX']
41: GETTABLEKS R17 R7 K8 ['X']
41: GETTABLEKS R18 R6 K8 ['X']
41: ADD R16 R17 R18
41: SETTABLE R16 R15 R11
43: GETTABLEKS R15 R0 K30 ['Type']
43: JUMPXEQKN R15 K31 L2 NOT [1]
44: GETIMPORT R15 16 [Instance.new]
44: LOADK R16 K32 ['UIGradient']
44: CALL R15 1 1
45: SETTABLEKS R13 R15 K20 ['Parent']
45: JUMP L3
47: L2: JUMPIFNOTLE R2 R5 L3
48: LOADK R15 K33 [0.65000000000000002]
48: SETTABLEKS R15 R13 K34 ['TextTransparency']
52: L3: MOVE R6 R14
53: GETIMPORT R15 35 [Vector2.new]
53: GETTABLEKS R16 R13 K23 ['Position']
53: GETTABLEKS R16 R16 K8 ['X']
53: GETTABLEKS R16 R16 K36 ['Offset']
53: LOADN R17 0
53: CALL R15 2 1
53: MOVE R7 R15
55: GETTABLEKS R15 R0 K37 ['Letters']
55: ADD R16 R5 R11
55: SETTABLE R13 R15 R16
28: FORNLOOP R9 L0
57: L4: RETURN R0 0
Function 3 (GenerateTrembleText):
60: FASTCALL1 43 R0 L0
60: MOVE R4 R0
60: GETIMPORT R3 2 [string.len]
60: CALL R3 1 1
61: L0: DUPTABLE R4 10
62: SETTABLEKS R3 R4 K3 ['Len']
63: GETIMPORT R5 13 [Instance.new]
63: LOADK R6 K14 ['Frame']
63: CALL R5 1 1
63: SETTABLEKS R5 R4 K4 ['Container']
64: GETIMPORT R5 17 [table.create]
64: MULK R6 R3 K18 [5]
64: LOADNIL R7
64: CALL R5 2 1
64: SETTABLEKS R5 R4 K5 ['Letters']
65: GETIMPORT R5 17 [table.create]
65: MOVE R6 R3
65: LOADN R7 0
65: CALL R5 2 1
65: SETTABLEKS R5 R4 K6 ['NormalPositionX']
66: GETIMPORT R5 21 [os.clock]
66: CALL R5 0 1
66: SETTABLEKS R5 R4 K7 ['Time']
67: LOADN R5 2
67: SETTABLEKS R5 R4 K8 ['Type']
68: LOADN R5 5
68: SETTABLEKS R5 R4 K9 ['Speed']
71: LOADN R7 1
71: LOADN R5 5
71: LOADN R6 1
71: FORNPREP R5 L2
72: L1: GETUPVAL R8 0
72: MOVE R9 R4
72: MOVE R10 R0
72: MOVE R11 R3
72: MOVE R12 R1
72: MOVE R13 R2
72: SUBK R15 R7 K22 [1]
72: MUL R14 R3 R15
72: CALL R8 6 0
71: FORNLOOP R5 L1
75: L2: RETURN R4 1
Function 4 (GenerateWaveText):
79: FASTCALL1 43 R0 L0
79: MOVE R4 R0
79: GETIMPORT R3 2 [string.len]
79: CALL R3 1 1
80: L0: DUPTABLE R4 10
81: SETTABLEKS R3 R4 K3 ['Len']
82: GETIMPORT R5 13 [Instance.new]
82: LOADK R6 K14 ['Frame']
82: CALL R5 1 1
82: SETTABLEKS R5 R4 K4 ['Container']
83: GETIMPORT R5 17 [table.create]
83: MOVE R6 R3
83: LOADNIL R7
83: CALL R5 2 1
83: SETTABLEKS R5 R4 K5 ['Letters']
84: GETIMPORT R5 17 [table.create]
84: MOVE R6 R3
84: LOADN R7 0
84: CALL R5 2 1
84: SETTABLEKS R5 R4 K6 ['NormalPositionX']
85: GETIMPORT R5 20 [os.clock]
85: CALL R5 0 1
85: SETTABLEKS R5 R4 K7 ['Time']
86: LOADN R5 1
86: SETTABLEKS R5 R4 K8 ['Type']
87: LOADN R5 5
87: SETTABLEKS R5 R4 K9 ['Speed']
90: GETUPVAL R5 0
90: MOVE R6 R4
90: MOVE R7 R0
90: MOVE R8 R3
90: MOVE R9 R1
90: MOVE R10 R2
90: LOADN R11 0
90: CALL R5 6 0
92: RETURN R4 1
Function 5 (TrembleText):
96: GETTABLEKS R6 R0 K1 ['Letters']
96: GETTABLEN R5 R6 1
96: GETTABLEKS R5 R5 K2 ['AbsoluteSize']
96: GETTABLEKS R5 R5 K3 ['X']
96: DIVK R4 R5 K0 [4]
96: GETTABLEKS R7 R0 K1 ['Letters']
96: GETTABLEN R6 R7 1
96: GETTABLEKS R6 R6 K2 ['AbsoluteSize']
96: GETTABLEKS R6 R6 K5 ['Y']
96: DIVK R5 R6 K4 [8]
15: GETIMPORT R6 8 [math.random]
15: SUBRK R7 K9 [-2] R4
15: ADDK R8 R4 K10 [2]
15: CALL R6 2 1
16: GETIMPORT R7 8 [math.random]
16: SUBRK R8 K9 [-2] R5
16: ADDK R9 R5 K10 [2]
16: CALL R7 2 1
18: MOVE R2 R6
18: MOVE R3 R7
98: JUMPXEQKN R1 K11 L1 NOT [0]
99: LOADN R6 1
99: GETTABLEKS R4 R0 K12 ['Len']
99: LOADN R5 1
99: FORNPREP R4 L3
100: L0: GETTABLEKS R8 R0 K1 ['Letters']
100: ADD R9 R1 R6
100: GETTABLE R7 R8 R9
101: GETTABLEKS R9 R0 K13 ['NormalPositionX']
101: GETTABLE R8 R9 R6
103: GETIMPORT R9 16 [UDim2.new]
103: LOADN R10 0
103: DIVK R12 R2 K4 [8]
103: ADD R11 R8 R12
103: LOADN R12 0
103: LOADN R14 0
103: DIVK R15 R3 K4 [8]
103: ADD R13 R14 R15
103: CALL R9 4 1
103: SETTABLEKS R9 R7 K17 ['Position']
99: FORNLOOP R4 L0
99: RETURN R0 0
106: L1: LOADN R6 1
106: GETTABLEKS R4 R0 K12 ['Len']
106: LOADN R5 1
106: FORNPREP R4 L3
107: L2: GETTABLEKS R8 R0 K1 ['Letters']
107: ADD R9 R1 R6
107: GETTABLE R7 R8 R9
108: GETTABLEKS R9 R0 K13 ['NormalPositionX']
108: GETTABLE R8 R9 R6
110: GETIMPORT R9 16 [UDim2.new]
110: LOADN R10 0
110: ADD R11 R8 R2
110: LOADN R12 0
110: LOADN R14 0
110: ADD R13 R14 R3
110: CALL R9 4 1
110: SETTABLEKS R9 R7 K17 ['Position']
106: FORNLOOP R4 L2
113: L3: RETURN R0 0
Function 6 (new):
130: JUMPXEQKS R2 K0 L0 ['Tremble']
130: JUMPXEQKS R2 K1 L0 ['Wave']
131: GETIMPORT R5 3 [print]
131: LOADK R7 K4 ['%* is an invalid type. Accepted '...]
131: MOVE R9 R2
131: NAMECALL R7 R7 K5 ['format']
131: CALL R7 2 1
131: MOVE R6 R7
131: CALL R5 1 0
132: LOADNIL R5
132: RETURN R5 1
135: L0: FASTCALL1 44 R1 L1
135: MOVE R6 R1
135: GETIMPORT R5 7 [typeof]
135: CALL R5 1 1
135: L1: JUMPXEQKS R5 K8 L2 ['Instance']
136: GETIMPORT R5 3 [print]
136: LOADK R7 K9 ['%* is not a valid Instance. Pare'...]
136: MOVE R9 R1
136: NAMECALL R7 R7 K5 ['format']
136: CALL R7 2 1
136: MOVE R6 R7
136: CALL R5 1 0
137: LOADNIL R5
137: RETURN R5 1
140: L2: FASTCALL1 63 R0 L3
140: MOVE R6 R0
140: GETIMPORT R5 11 [tostring]
140: CALL R5 1 1
140: L3: JUMPIF R5 L4
141: GETIMPORT R5 3 [print]
141: LOADK R6 K12 ['Text parameter cannot be convert'...]
141: CALL R5 1 0
142: LOADNIL R5
142: RETURN R5 1
145: L4: FASTCALL1 63 R0 L5
145: MOVE R6 R0
145: GETIMPORT R5 11 [tostring]
145: CALL R5 1 1
145: L5: MOVE R0 R5
147: JUMPXEQKS R2 K0 L6 NOT ['Tremble']
147: GETUPVAL R5 0
147: MOVE R6 R0
147: MOVE R7 R3
147: MOVE R8 R4
147: CALL R5 3 1
147: JUMPIF R5 L7
147: L6: GETUPVAL R5 1
147: MOVE R6 R0
147: MOVE R7 R3
147: MOVE R8 R4
147: CALL R5 3 1
149: L7: GETTABLEKS R6 R5 K13 ['Container']
149: GETIMPORT R7 16 [Vector2.new]
149: LOADK R8 K17 [0.5]
149: LOADK R9 K17 [0.5]
149: CALL R7 2 1
149: SETTABLEKS R7 R6 K18 ['AnchorPoint']
150: GETTABLEKS R6 R5 K13 ['Container']
150: GETIMPORT R7 20 [UDim2.new]
150: LOADK R8 K17 [0.5]
150: LOADN R9 0
150: LOADK R10 K17 [0.5]
150: LOADN R11 0
150: CALL R7 4 1
150: SETTABLEKS R7 R6 K21 ['Position']
151: GETTABLEKS R6 R5 K13 ['Container']
151: SETTABLEKS R1 R6 K22 ['Parent']
152: GETTABLEKS R6 R5 K13 ['Container']
152: LOADK R8 K23 ['%*_Container']
152: MOVE R10 R0
152: NAMECALL R8 R8 K5 ['format']
152: CALL R8 2 1
152: MOVE R7 R8
152: SETTABLEKS R7 R6 K24 ['Name']
153: GETTABLEKS R6 R5 K13 ['Container']
153: LOADN R7 1
153: SETTABLEKS R7 R6 K25 ['BackgroundTransparency']
154: GETTABLEKS R6 R5 K13 ['Container']
154: GETIMPORT R7 28 [Color3.fromRGB]
154: LOADN R8 255
154: LOADN R9 255
154: LOADN R10 255
154: CALL R7 3 1
154: SETTABLEKS R7 R6 K29 ['BackgroundColor3']
156: GETUPVAL R8 2
156: FASTCALL2 61 R5 R8 L8
156: MOVE R7 R5
156: GETIMPORT R6 31 [setmetatable]
156: CALL R6 2 0
157: L8: RETURN R5 1
Function 7 (Destroy):
161: GETTABLEKS R1 R0 K0 ['Container']
161: NAMECALL R1 R1 K1 ['Destroy']
161: CALL R1 1 0
162: RETURN R0 0
Function 8 (Step):
165: GETTABLEKS R2 R0 K1 ['Len']
165: DIVRK R1 K0 [1] R2
167: GETTABLEKS R2 R0 K2 ['Type']
167: JUMPXEQKN R2 K0 L4 NOT [1]
168: LOADN R4 1
168: GETTABLEKS R2 R0 K1 ['Len']
168: LOADN R3 1
168: FORNPREP R2 L3
169: L0: GETTABLEKS R6 R0 K3 ['Letters']
169: GETTABLE R5 R6 R4
170: GETTABLEKS R7 R0 K4 ['NormalPositionX']
170: GETTABLE R6 R7 R4
171: GETUPVAL R7 0
171: MULK R9 R4 K5 [10]
171: GETTABLEKS R11 R0 K7 ['Time']
171: MULK R10 R11 K6 [200]
171: ADD R8 R9 R10
171: CALL R7 1 1
172: GETIMPORT R8 10 [UDim2.new]
173: LOADN R9 0
173: LOADN R12 10
173: ADD R11 R12 R6
173: MULK R15 R4 K12 [0.10000000000000001]
173: GETTABLEKS R17 R0 K7 ['Time']
173: GETTABLEKS R18 R0 K13 ['Speed']
173: MUL R16 R17 R18
173: ADD R14 R15 R16
173: FASTCALL1 24 R14 L1
173: GETIMPORT R13 16 [math.sin]
173: CALL R13 1 1
173: L1: MULK R12 R13 K11 [5]
173: ADD R10 R11 R12
174: LOADN R11 0
174: MULK R15 R4 K12 [0.10000000000000001]
174: GETTABLEKS R17 R0 K7 ['Time']
174: GETTABLEKS R18 R0 K13 ['Speed']
174: MUL R16 R17 R18
174: ADD R14 R15 R16
174: FASTCALL1 9 R14 L2
174: GETIMPORT R13 18 [math.cos]
174: CALL R13 1 1
174: L2: MULK R12 R13 K11 [5]
172: CALL R8 4 1
172: SETTABLEKS R8 R5 K19 ['Position']
176: GETTABLEKS R8 R5 K20 ['UIGradient']
176: GETIMPORT R9 22 [ColorSequence.new]
176: MOVE R10 R7
176: MOVE R11 R7
176: CALL R9 2 1
176: SETTABLEKS R9 R8 K23 ['Color']
168: FORNLOOP R2 L0
179: L3: GETIMPORT R2 26 [os.clock]
179: CALL R2 0 1
179: SETTABLEKS R2 R0 K7 ['Time']
179: RETURN R0 0
181: L4: GETTABLEKS R2 R0 K1 ['Len']
181: JUMPXEQKN R2 K27 L5 NOT [0]
182: RETURN R0 0
185: L5: GETUPVAL R2 1
185: MOVE R3 R0
185: LOADN R4 0
185: CALL R2 2 0
186: GETUPVAL R2 1
186: MOVE R3 R0
186: GETTABLEKS R4 R0 K1 ['Len']
186: CALL R2 2 0
187: GETUPVAL R2 1
187: MOVE R3 R0
187: GETTABLEKS R5 R0 K1 ['Len']
187: MULK R4 R5 K28 [2]
187: CALL R2 2 0
188: GETUPVAL R2 1
188: MOVE R3 R0
188: GETTABLEKS R5 R0 K1 ['Len']
188: MULK R4 R5 K29 [3]
188: CALL R2 2 0
189: GETUPVAL R2 1
189: MOVE R3 R0
189: GETTABLEKS R5 R0 K1 ['Len']
189: MULK R4 R5 K30 [4]
189: CALL R2 2 0
191: RETURN R0 0
Function 9 (??):
2: NEWTABLE R0 4 0
3: SETTABLEKS R0 R0 K0 ['__index']
5: GETIMPORT R1 2 [game]
5: LOADK R3 K3 ['TextService']
5: NAMECALL R1 R1 K4 ['GetService']
5: CALL R1 2 1
7: DUPCLOSURE R2 K5 ['GetPastelRainbowColor']
14: DUPCLOSURE R3 K6 ['GetRandomXY']
21: DUPCLOSURE R4 K7 ['GenerateLetters']
21: CAPTURE VAL R1
59: DUPCLOSURE R5 K8 ['GenerateTrembleText']
59: CAPTURE VAL R4
78: DUPCLOSURE R6 K9 ['GenerateWaveText']
78: CAPTURE VAL R4
95: DUPCLOSURE R7 K10 ['TrembleText']
129: DUPCLOSURE R8 K11 ['new']
129: CAPTURE VAL R5
129: CAPTURE VAL R6
129: CAPTURE VAL R0
129: SETTABLEKS R8 R0 K12 ['new']
160: DUPCLOSURE R8 K13 ['Destroy']
160: SETTABLEKS R8 R0 K14 ['Destroy']
164: DUPCLOSURE R8 K15 ['Step']
164: CAPTURE VAL R2
164: CAPTURE VAL R7
164: SETTABLEKS R8 R0 K16 ['Step']
193: RETURN R0 1
]]


--[[
new bytecode:
Function 0 (??):
68: GETTABLEKS R1 R0 K0 ['Len']
69: GETTABLEKS R2 R0 K1 ['Speed']
71: GETTABLEKS R3 R0 K2 ['Letters']
72: GETTABLEKS R4 R0 K3 ['type']
72: JUMPXEQKN R4 K4 L7 NOT [1]
73: LOADN R6 1
73: MOVE R4 R1
73: LOADN R5 1
73: FORNPREP R4 L6
74: L0: GETTABLEKS R7 R0 K5 ['Time']
75: GETTABLEKS R9 R0 K2 ['Letters']
75: GETTABLE R8 R9 R6
76: GETTABLEKS R10 R0 K6 ['NormalPositionX']
76: GETTABLE R9 R10 R6
77: MULK R11 R6 K7 [10]
77: MULK R12 R7 K8 [200]
77: ADD R10 R11 R12
78: GETIMPORT R11 11 [Color3.fromRGB]
78: MULK R19 R10 K17 [0.024]
78: ADDK R18 R19 K16 [0]
78: FASTCALL1 24 R18 L1
78: GETIMPORT R17 20 [math.sin]
78: CALL R17 1 1
78: L1: MULK R16 R17 K15 [0.5]
78: ADDK R15 R16 K15 [0.5]
78: MULK R14 R15 K14 [0.59999999999999998]
78: ADDK R13 R14 K13 [0.20000000000000001]
78: MULK R12 R13 K12 [255]
78: MULK R20 R10 K17 [0.024]
78: ADDK R19 R20 K21 [2]
78: FASTCALL1 24 R19 L2
78: GETIMPORT R18 20 [math.sin]
78: CALL R18 1 1
78: L2: MULK R17 R18 K15 [0.5]
78: ADDK R16 R17 K15 [0.5]
78: MULK R15 R16 K14 [0.59999999999999998]
78: ADDK R14 R15 K13 [0.20000000000000001]
78: MULK R13 R14 K12 [255]
78: MULK R21 R10 K17 [0.024]
78: ADDK R20 R21 K22 [4]
78: FASTCALL1 24 R20 L3
78: GETIMPORT R19 20 [math.sin]
78: CALL R19 1 1
78: L3: MULK R18 R19 K15 [0.5]
78: ADDK R17 R18 K15 [0.5]
78: MULK R16 R17 K14 [0.59999999999999998]
78: ADDK R15 R16 K13 [0.20000000000000001]
78: MULK R14 R15 K12 [255]
78: CALL R11 3 1
79: GETIMPORT R12 25 [UDim2.new]
79: LOADN R13 0
79: ADDK R15 R9 K7 [10]
79: MULK R19 R6 K27 [0.10000000000000001]
79: MUL R20 R7 R2
79: ADD R18 R19 R20
79: FASTCALL1 24 R18 L4
79: GETIMPORT R17 20 [math.sin]
79: CALL R17 1 1
79: L4: MULK R16 R17 K26 [5]
79: ADD R14 R15 R16
79: LOADN R15 0
79: MULK R19 R6 K27 [0.10000000000000001]
79: MUL R20 R7 R2
79: ADD R18 R19 R20
79: FASTCALL1 9 R18 L5
79: GETIMPORT R17 29 [math.cos]
79: CALL R17 1 1
79: L5: MULK R16 R17 K26 [5]
79: CALL R12 4 1
79: SETTABLEKS R12 R8 K30 ['Position']
80: GETTABLEKS R12 R8 K31 ['UIGradient']
80: GETIMPORT R13 33 [ColorSequence.new]
80: MOVE R14 R11
80: MOVE R15 R11
80: CALL R13 2 1
80: SETTABLEKS R13 R12 K34 ['Color']
73: FORNLOOP R4 L0
82: L6: GETIMPORT R4 37 [os.clock]
82: CALL R4 0 1
82: SETTABLEKS R4 R0 K5 ['Time']
82: RETURN R0 0
83: L7: JUMPXEQKN R1 K16 L12 [0]
84: GETTABLEN R4 R3 1
85: GETTABLEKS R6 R4 K38 ['AbsoluteSize']
85: GETTABLEKS R6 R6 K39 ['X']
85: DIVK R5 R6 K22 [4]
86: GETTABLEKS R6 R0 K6 ['NormalPositionX']
87: GETTABLEKS R8 R4 K38 ['AbsoluteSize']
87: GETTABLEKS R8 R8 K41 ['Y']
87: DIVK R7 R8 K40 [8]
88: GETIMPORT R8 43 [math.random]
88: SUBRK R9 K44 [-2] R5
88: ADDK R10 R5 K21 [2]
88: CALL R8 2 1
89: GETIMPORT R9 43 [math.random]
89: SUBRK R10 K44 [-2] R7
89: ADDK R11 R7 K21 [2]
89: CALL R9 2 1
90: LOADN R12 1
90: MULK R10 R1 K26 [5]
90: LOADN R11 1
90: FORNPREP R10 L12
91: L8: SUBK R15 R12 K4 [1]
91: MOD R14 R15 R1
91: ADDK R13 R14 K4 [1]
92: SUBK R16 R12 K4 [1]
92: DIV R15 R16 R1
92: FASTCALL1 12 R15 L9
92: GETIMPORT R14 46 [math.floor]
92: CALL R14 1 1
93: L9: GETTABLE R15 R3 R12
94: GETTABLE R16 R6 R13
95: JUMPXEQKN R14 K4 L10 NOT [1]
95: GETIMPORT R17 25 [UDim2.new]
95: LOADN R18 0
95: DIVK R20 R8 K40 [8]
95: ADD R19 R16 R20
95: LOADN R20 0
95: DIVK R21 R9 K40 [8]
95: CALL R17 4 1
95: JUMPIF R17 L11
95: L10: GETIMPORT R17 25 [UDim2.new]
95: LOADN R18 0
95: ADD R19 R16 R8
95: LOADN R20 0
95: MOVE R21 R9
95: CALL R17 4 1
95: L11: SETTABLEKS R17 R15 K30 ['Position']
90: FORNLOOP R10 L8
98: L12: RETURN R0 0
Function 1 (??):
5: JUMPXEQKS R2 K0 L0 ['Tremble']
5: JUMPXEQKS R2 K1 L0 ['Wave']
6: GETIMPORT R5 3 [error]
6: LOADK R7 K4 ['%* is an invalid type. Accepted '...]
6: MOVE R9 R2
6: NAMECALL R7 R7 K5 ['format']
6: CALL R7 2 1
6: MOVE R6 R7
6: LOADN R7 2
6: CALL R5 2 1
6: RETURN R5 1
7: L0: FASTCALL1 44 R1 L1
7: MOVE R6 R1
7: GETIMPORT R5 7 [typeof]
7: CALL R5 1 1
7: L1: JUMPXEQKS R5 K8 L2 ['Instance']
8: GETIMPORT R5 3 [error]
8: LOADK R7 K9 ['%* is not a valid Instance. Pare'...]
8: MOVE R9 R1
8: NAMECALL R7 R7 K5 ['format']
8: CALL R7 2 1
8: MOVE R6 R7
8: LOADN R7 2
8: CALL R5 2 1
8: RETURN R5 1
9: L2: FASTCALL1 63 R0 L3
9: MOVE R6 R0
9: GETIMPORT R5 11 [tostring]
9: CALL R5 1 1
9: L3: JUMPIF R5 L4
10: GETIMPORT R5 3 [error]
10: LOADK R6 K12 ['Text parameter cannot be convert'...]
10: LOADN R7 2
10: CALL R5 2 1
10: RETURN R5 1
12: L4: JUMPXEQKS R2 K1 L5 NOT ['Wave']
12: LOADN R5 1
12: JUMP L6
12: L5: LOADN R5 2
13: L6: GETIMPORT R6 14 [game]
13: LOADK R8 K15 ['TextService']
13: NAMECALL R6 R6 K16 ['GetService']
13: CALL R6 2 1
14: LOADN R7 0
15: FASTCALL1 43 R0 L7
15: MOVE R9 R0
15: GETIMPORT R8 19 [string.len]
15: CALL R8 1 1
16: L7: DUPTABLE R9 27
17: SETTABLEKS R8 R9 K20 ['Len']
18: GETIMPORT R10 29 [Instance.new]
18: LOADK R11 K30 ['Frame']
18: CALL R10 1 1
18: SETTABLEKS R10 R9 K21 ['Container']
19: GETIMPORT R10 33 [table.create]
19: MULK R11 R8 K34 [5]
19: LOADNIL R12
19: CALL R10 2 1
19: SETTABLEKS R10 R9 K22 ['Letters']
20: GETIMPORT R10 33 [table.create]
20: MOVE R11 R8
20: LOADN R12 0
20: CALL R10 2 1
20: SETTABLEKS R10 R9 K23 ['NormalPositionX']
21: GETIMPORT R10 37 [os.clock]
21: CALL R10 0 1
21: SETTABLEKS R10 R9 K24 ['Time']
22: SETTABLEKS R5 R9 K25 ['type']
23: LOADN R10 5
23: SETTABLEKS R10 R9 K26 ['Speed']
25: GETTABLEKS R10 R9 K21 ['Container']
26: GETTABLEKS R11 R9 K23 ['NormalPositionX']
27: GETIMPORT R12 40 [Vector2.zero]
28: MOVE R13 R12
29: MOVE R14 R12
30: JUMPXEQKN R5 K41 L8 NOT [2]
30: LOADN R15 5
30: JUMP L9
30: L8: LOADN R15 1
31: L9: LOADN R18 1
31: MOVE R16 R15
31: LOADN R17 1
31: FORNPREP R16 L20
32: L10: MOVE R21 R0
32: MOVE R22 R4
32: MOVE R23 R3
32: MOVE R24 R12
32: NAMECALL R19 R6 K42 ['GetTextSize']
32: CALL R19 5 1
33: GETIMPORT R20 44 [UDim2.new]
33: LOADN R21 0
33: GETTABLEKS R22 R19 K45 ['X']
33: LOADN R23 0
33: GETTABLEKS R24 R19 K46 ['Y']
33: CALL R20 4 1
33: SETTABLEKS R20 R10 K47 ['Size']
34: GETIMPORT R13 40 [Vector2.zero]
35: GETIMPORT R14 40 [Vector2.zero]
36: LOADN R22 1
36: MOVE R20 R8
36: LOADN R21 1
36: FORNPREP R20 L19
37: L11: ADDK R7 R7 K48 [1]
38: GETTABLEKS R24 R14 K45 ['X']
38: GETTABLEKS R25 R13 K45 ['X']
38: ADD R23 R24 R25
39: FASTCALL3 45 R0 R22 R22 L12
39: MOVE R25 R0
39: MOVE R26 R22
39: MOVE R27 R22
39: GETIMPORT R24 50 [string.sub]
39: CALL R24 3 1
40: L12: MOVE R27 R24
40: MOVE R28 R4
40: MOVE R29 R3
40: MOVE R30 R12
40: NAMECALL R25 R6 K42 ['GetTextSize']
40: CALL R25 5 1
41: GETIMPORT R26 29 [Instance.new]
41: LOADK R27 K51 ['TextLabel']
41: CALL R26 1 1
42: SETTABLEKS R24 R26 K52 ['Text']
43: FASTCALL1 63 R22 L13
43: MOVE R28 R22
43: GETIMPORT R27 11 [tostring]
43: CALL R27 1 1
43: L13: SETTABLEKS R27 R26 K53 ['Name']
44: SETTABLEKS R10 R26 K54 ['Parent']
45: SETTABLEKS R4 R26 K55 ['TextSize']
46: LOADN R27 1
46: SETTABLEKS R27 R26 K56 ['BackgroundTransparency']
47: GETIMPORT R27 44 [UDim2.new]
47: LOADN R28 0
47: GETTABLEKS R29 R25 K45 ['X']
47: LOADN R30 1
47: LOADN R31 0
47: CALL R27 4 1
47: SETTABLEKS R27 R26 K47 ['Size']
48: GETIMPORT R27 44 [UDim2.new]
48: LOADN R28 0
48: MOVE R29 R23
48: LOADN R30 0
48: LOADN R31 0
48: CALL R27 4 1
48: SETTABLEKS R27 R26 K57 ['Position']
49: SETTABLEKS R3 R26 K58 ['Font']
50: GETIMPORT R27 61 [Color3.fromRGB]
50: LOADN R28 255
50: LOADN R29 255
50: LOADN R30 255
50: CALL R27 3 1
50: SETTABLEKS R27 R26 K62 ['TextColor3']
51: JUMPXEQKN R18 K48 L14 NOT [1]
52: SETTABLE R23 R11 R22
55: L14: JUMPXEQKN R5 K48 L15 NOT [1]
56: GETIMPORT R27 29 [Instance.new]
56: LOADK R28 K63 ['UIGradient']
56: CALL R27 1 1
57: SETTABLEKS R26 R27 K54 ['Parent']
57: JUMP L18
60: L15: JUMPIFNOTLE R8 R7 L16
60: LOADK R27 K64 [0.65000000000000002]
60: JUMP L17
60: L16: GETTABLEKS R27 R26 K65 ['TextTransparency']
60: L17: SETTABLEKS R27 R26 K65 ['TextTransparency']
62: L18: MOVE R13 R25
63: GETIMPORT R27 66 [Vector2.new]
63: GETTABLEKS R28 R26 K57 ['Position']
63: GETTABLEKS R28 R28 K45 ['X']
63: GETTABLEKS R28 R28 K67 ['Offset']
63: LOADN R29 0
63: CALL R27 2 1
63: MOVE R14 R27
64: GETTABLEKS R27 R9 K22 ['Letters']
64: SUBK R30 R18 K48 [1]
64: MUL R29 R30 R8
64: ADD R28 R29 R22
64: SETTABLE R26 R27 R28
36: FORNLOOP R20 L11
31: L19: FORNLOOP R16 L10
67: L20: DUPCLOSURE R16 K68 []
67: SETTABLEKS R16 R9 K69 ['Step']
100: GETTABLEKS R16 R9 K21 ['Container']
101: GETIMPORT R17 66 [Vector2.new]
101: LOADK R18 K70 [0.5]
101: LOADK R19 K70 [0.5]
101: CALL R17 2 1
101: SETTABLEKS R17 R16 K71 ['AnchorPoint']
102: GETIMPORT R17 44 [UDim2.new]
102: LOADK R18 K70 [0.5]
102: LOADN R19 0
102: LOADK R20 K70 [0.5]
102: LOADN R21 0
102: CALL R17 4 1
102: SETTABLEKS R17 R16 K57 ['Position']
103: SETTABLEKS R1 R16 K54 ['Parent']
104: LOADK R18 K72 ['%*_Container']
104: MOVE R20 R0
104: NAMECALL R18 R18 K5 ['format']
104: CALL R18 2 1
104: MOVE R17 R18
104: SETTABLEKS R17 R16 K53 ['Name']
105: LOADN R17 1
105: SETTABLEKS R17 R16 K56 ['BackgroundTransparency']
106: GETIMPORT R17 61 [Color3.fromRGB]
106: LOADN R18 255
106: LOADN R19 255
106: LOADN R20 255
106: CALL R17 3 1
106: SETTABLEKS R17 R16 K73 ['BackgroundColor3']
107: RETURN R9 1
Function 2 (??):
4: DUPCLOSURE R0 K0 []
109: DUPTABLE R1 2
110: SETTABLEKS R0 R1 K1 ['new']
110: RETURN R1 1
]]
