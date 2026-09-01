-- 中文模式下，首个候选为英文单词时，空格上屏并追加一个空格
-- 在 engine/processors 中，于 selector 之前增加：- lua_processor@*space_english_spacer

local F = {}

function F.func(key, env)
    local engine = env.engine
    local context = engine.context

    -- 只处理中文模式下按下的空格键
    if key:release() or key:repr() ~= "space" then
        return 2
    end
    local ascii_mode = context:get_option("ascii_mode")
    if ascii_mode and ascii_mode ~= 0 then
        return 2
    end
    if not context:has_menu() then
        return 2
    end

    local cand = context:get_selected_candidate()
    if not cand then
        return 2
    end

    -- 判断是否为英文单词（支持大小写、连字符、撇号）
    if not cand.text:match("^[%a][%a'-]*$") then
        return 2
    end

    engine:commit_text(cand.text .. " ")
    context:clear()
    return 1
end

return F
