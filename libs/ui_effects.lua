local Mouse = game.Players.LocalPlayer:GetMouse()

local effects; effects = {
	mouse = nil,

	ts = game:GetService("TweenService"),
	rs = game:GetService("RunService"),

	button_click = Instance.new("ImageLabel"),
	mouse_enter = Instance.new("ImageLabel"),

	init = function()
		effects.mouse = game:GetService("Players").LocalPlayer:GetMouse()

		effects.button_click.AnchorPoint = Vector2.new(0.5, 0.5)
		effects.button_click.Name = "effect"
		effects.button_click.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		effects.button_click.BackgroundTransparency = 1.000
		effects.button_click.Size = UDim2.new(0, 20, 0, 20)
		effects.button_click.Image = "rbxassetid://3570695787"
		effects.button_click.ImageColor3 = Color3.fromRGB(28, 28, 28)
		effects.button_click.ImageTransparency = 0.250
		effects.button_click.ScaleType = Enum.ScaleType.Slice
		effects.button_click.SliceCenter = Rect.new(100, 100, 100, 100)
		effects.button_click.SliceScale = 1.0

		local grad = Instance.new("UIGradient")

		effects.mouse_enter.Name = "effect"
		effects.mouse_enter.BackgroundColor3 = Color3.fromRGB(116, 116, 116)
		effects.mouse_enter.BackgroundTransparency = 1.000
		effects.mouse_enter.BorderColor3 = Color3.fromRGB(255, 255, 255)
		effects.mouse_enter.BorderSizePixel = 0
		effects.mouse_enter.Size = UDim2.new(1, 0, 1, 0)
		effects.mouse_enter.Image = "rbxassetid://3570695787"
		effects.mouse_enter.ImageColor3 = Color3.fromRGB(255, 255, 255)
		effects.mouse_enter.ImageTransparency = 1
		effects.mouse_enter.ScaleType = Enum.ScaleType.Slice
		effects.mouse_enter.SliceCenter = Rect.new(100, 100, 100, 100)
		effects.mouse_enter.SliceScale = 0.120

		grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(50, 50, 50)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(116, 116, 116))}
		grad.Name = "grad"
		grad.Parent = effects.mouse_enter
		grad.Rotation = 180

	end,

	button = function(button)
		local p = button.Parent

		button.MouseButton1Down:Connect(function(x, y)
			local new_effect = effects.button_click:Clone()

			local pos = (Vector2.new(effects.mouse.X, effects.mouse.Y) - p.AbsolutePosition)
			new_effect.Position = UDim2.new(0, pos.X, 0, pos.Y)
			new_effect.Parent = p

			local x = new_effect.Size.X
			local y = new_effect.Size.Y
			local tween = effects.ts:Create(
				new_effect,
				TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					Size = UDim2.new(x.Scale * 5, x.Offset * 5, y.Scale * 5, y.Offset * 5),
					ImageTransparency = 1;
				}
			)

			tween.Completed:Connect(function()
				new_effect:Destroy()
			end)

			tween:Play()
		end)

		local mouse_hover  = false

		button.MouseLeave:Connect(function()
			mouse_hover = false
		end)

		button.MouseEnter:Connect(function()
			mouse_hover = true

			local effect_clone = effects.mouse_enter:Clone()

			effect_clone.Parent = p

			effects.ts:Create(
				effect_clone,
				TweenInfo.new(0.75, Enum.EasingStyle.Linear),
				{
					ImageTransparency = 0.750
				}
			):Play()

			local right = Vector2.new(-1.5, 0)
			local left = Vector2.new(1.5, 0)

			local current = true
			while mouse_hover do
				current = not current

				local tween = effects.ts:Create(
					effect_clone.grad,
					TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{
						Offset = ((current and right) or left);
					}
				)

				tween:Play()
				tween.Completed:wait()

				effect_clone.grad.Rotation = ((current and 180) or 0)
				effect_clone.grad.Offset = ((current and left) or right)

				local tween = effects.ts:Create(
					effect_clone.grad,
					TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{
						Offset = ((current and right) or left);
					}
				)

				tween:Play()
				tween.Completed:wait()
			end

			local tween = effects.ts:Create(
				effect_clone,
				TweenInfo.new(0.75, Enum.EasingStyle.Linear),
				{
					ImageTransparency = 1
				}
			)

			tween:Play()
			tween.Completed:Connect(function()
				effect_clone:Destroy()
			end)
		end)
	end,
}
effects.init()

return effects
