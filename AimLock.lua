--Settings--
local AimLock = {
  Enable = false,
  Filter = "soldier_model",
  TeamCheck = true,
  fov = 60,
  showfov = true,
  drawfov = 40,
  turnSpeed = 0.5
}

local function Log(tbl)
print("[Monkey Aim Debug]: " .. tbl)
end

function AimLock:Update() 

  while AimLock.Enable do
    local pressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    log(pressed)
    if pressed then
      local currentActor = nil
      local maxDist = AimLock.fov
      local cam = workspace.CurrentCamera
      for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name == AimLock.Filter and (not AimLock.TeamCheck or model:GetChildren("friendly_model") ~= nil) then
          local ssHeadPoint = cam:WorldToScreenPoint(model.PrimaryPart.Position)
          local distance = (Vector2.new(model.PrimaryPart.Position.X, model.PrimaryPart.Position.Y) - UserInputService:GetMouseLocation())
          log(model)
          if distance < maxDist then
            currentActor = model
            maxDist = distance
            log("new dist " .. distance .. " max " .. maxDist)
          end
          
          
        end
      end

      local camera = cam
      local targetPosition = currentActor.PrimaryPart.Position
      local turnTime = AimLock.turnSpeed
      print(targetPosition)
      local startTime = tick()
      while tick() - startTime < turnTime do
        local elapsedTime = tick() - startTime
        local lerpedValue = elapsedTime / turnTime
        local currentLookVector = camera.CFrame.LookVector
        local targetLookVector = (targetPosition - camera.CFrame.Position).Unit
        local newLookVector = Vector3.lerp(currentLookVector, targetLookVector, lerpedValue)
        log("Camera Moving")
        log("currentLookVector: " .. currentLookVector .. " targetLookVector: " .. targetLookVector .. " newLookVector: " .. newLookVector
        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, camera.CFrame.Position + newLookVector)
        log("CFrame Called")
        --wait()
      end
    end
  end

end
return AimLock
