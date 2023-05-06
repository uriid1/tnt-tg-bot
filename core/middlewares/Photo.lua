local function Photo(filename)
    if type(filename) ~= 'string' then
        return nil
    end

    local fd = io.open(filename, 'rb')
    
    if fd == nil then
        return nil
    end

    local data = fd:read('*all'); fd:close()

    return {
        data = data;
        filename = filename;
    }
end

return Photo