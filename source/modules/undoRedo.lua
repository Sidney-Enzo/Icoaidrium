local undoRedo = {}
undoRedo.redoData = {}
undoRedo.undoData = {}

function undoRedo:newRedoObject(_call, ...)
    table.insert(self.redoData, {
        args = { ... },
        call = _call
    })
end

function undoRedo:newUndoObject(_call, ...)
    table.insert(self.undoData, {
        args = { ... },
        call = _call
    })
end

function undoRedo:undo()
    if #self.undoData > 0 then
        print("Undo:", #self.undoData)
        self.undoData[#self.undoData].call(unpack(self.undoData[#self.undoData].args))
        table.remove(self.undoData, #self.undoData) 
    end
end

function undoRedo:redo()
    if #self.redoData > 0 then
        print("Redo:", #self.redoData)
        self.redoData[#self.redoData].call(unpack(self.redoData[#self.redoData].args))
        table.remove(self.redoData, #self.redoData) 
    end
end

return undoRedo
