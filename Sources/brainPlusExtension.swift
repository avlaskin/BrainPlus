//  Copyright © 2016 Alexey Vlaskin. All rights reserved.
//

import Foundation

//I really do not want to copy paste it, generics?
//0 - 0 = 0 * 16
//1 - 16 = 1 * 16
//2 - 32
//...
//F - 240 = 15*16
class FastCellInit: InterpreterCommand {
    var character: Character
    var value: UInt8
    
    init(_ character: Character, value: UInt8) {
        self.character = character
        self.value = value
    }
    
    func functionToApply(state: BrainPlusVM) -> String? {
        state.setPointerValue(value)
        return nil
    }
}

