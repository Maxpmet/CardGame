
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)


    self:checkForUpdate()
end

function MainScene:checkForUpdate()
    local writablePath = cc.Director:getInstance():getWritablePath()
    local storagePath = writablePath.."version"

	local am = cc.AssetsManagerEx:create( "", storagePath )
    am:retain()

    if am:getLocalManifest():isLoaded() then
        print("load local manifest")
        local function onUpdateEvent( event )
            local eventCode = event:getEventCode()
            print("eventCode  ",eventCode)
            if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
                print("No local manifest file found, skip assets update.")
            elseif  eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
                local assetId = event:getAssetId()
                local percent = event:getPercent()
                local strInfo = ""

                if assetId == cc.AssetsManagerExStatic.VERSION_ID then
                    strInfo = string.format("Version file: %d%%", percent)
                elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
                    strInfo = string.format("Manifest file: %d%%", percent)
                else
                    strInfo = string.format("%d%%", percent)
                end
                print(strInfo)
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
                   eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
                print("Fail to download manifest file, update skipped.")
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE or 
                   eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
                print("Update finished.")
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
                print("Asset ", event:getAssetId(), ", ", event:getMessage())
            end
        end
        local listener = cc.EventListenerAssetsManagerEx:create(am,onUpdateEvent)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)
        
        am:update()
    end
end

return MainScene
