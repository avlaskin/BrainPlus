//  Copyright © 2016 Alexey Vlaskin. All rights reserved.
//

import Foundation

struct Loop {
    var start: Int = -1
    var  end : Int = -1
    init(_ start: Int, _ end: Int) {
        self.start = start
        self.end = end
    }
}

//Future should be generic - class BrainPlusVM<Element: Integer>
class BrainPlusVM {
    public var dataSize: Int
    public var dataPointer: Int = 0 {
        didSet {
            if dataPointer < 0 {
                dataPointer += dataSize
            }
            if dataPointer >= dataSize {
                dataPointer = 0
            }
        }
    }
    private var data: UnsafeMutablePointer<UInt8>
    public var loops: [Loop] = []
    public var instructionPointer: Int = 0
    deinit {
        data.deallocate(capacity: dataSize)
    }
    func setPointerCharacter(character: Character) {
        let s = String(character)
        if let f = s.utf8.first {
            data[ dataPointer ] = UInt8(f)
        }
    }
    
    func getPointerCharacter() -> Character {
        let c = Character(UnicodeScalar(data[ dataPointer ]))
        return c
    }
    
    func getPointerValue() -> UInt8 {
        return data[ dataPointer ]
    }
    
    func setPointerValue(_ value: UInt8) {
        data[ dataPointer ] = value
    }
    
    func incrememntPointer() {
        data[ dataPointer ] = data[ dataPointer ] &+ 1
    }
    
    func decrememntPointer() {
        data[ dataPointer ] = data[ dataPointer ] &- 1
    }
    
    public init(dataSize: Int = 4096) {
        self.dataSize = dataSize
        data = UnsafeMutablePointer<UInt8>.allocate(capacity: dataSize)
        for i in 0..<dataSize {
            data[i] = 0
        }
    }
    
    func description(num: Int = 10) ->String {
        let n = (num < dataSize) ? num : dataSize
        var str = ""
        for i in 0...n {
            str += "\(data[i])"
        }
        return str
    }
    
    public func resetState() {
        loops.removeAll(keepingCapacity: true)
        instructionPointer = 0
        dataPointer = 0
        for i in 0..<dataSize {
            data[i] = 0
        }
    }
}


class BrainPlusInterpreter {
    public  var maxCount: Int
    public  var maxResult: Int
    private var instructions: [InterpreterCommand]
    private var program: String
    public init(program: String, instructions: [InterpreterCommand]) {
        self.instructions = instructions
        self.program = program
        self.maxCount = 65535
        self.maxResult = 100
    }
    public func run() -> (String, Bool) {
        let vm = BrainPlusVM()
        return run(brainfvm: vm)
    }
    // the interface will be adjusted to accomodate input/output
    public func run(brainfvm: BrainPlusVM) -> (String, Bool) {
        //preprocessing of the program
        let (error, valid) = validateProgram(program: program, brainfvm: brainfvm)
        guard valid else {
            return (error, false)
        }
        
        var res = ""
        // set initial state
        brainfvm.instructionPointer = 0
        brainfvm.dataPointer = 0
        var finished = false
        var count = 0
        
        while(!finished) {
            let cindex = program.index(program.startIndex, offsetBy: brainfvm.instructionPointer)
            let c = program[ cindex ]
            for command in instructions {
                if command.character == c {
                    if let r = command.functionToApply(state: brainfvm) {
                        res += "\(r)"
                    }
                }
            }
            brainfvm.instructionPointer += 1
            if brainfvm.instructionPointer >= program.characters.count {
                finished = true
            }
            count += 1
            if count > maxCount || res.characters.count > maxResult {
                finished = true
            }
        }
        return (res, true)
    }
    // Returns error description and valid/invalid
    public func validateProgram(program: String, brainfvm: BrainPlusVM) -> (String,Bool) {
        var index = 0
        var loopStarters: [Int] = []
        for c in program.characters {
            if c == Character("[") {
                loopStarters.append( index )
            } else if c == Character("]") {
                if loopStarters.count == 0 {
                    ///we found ] without openning [
                    return ("Found closing ] without openning",false)
                }
                if let lastStart = loopStarters.last {
                    brainfvm.loops.append( Loop(lastStart, index) )
                    loopStarters.removeLast()
                }
            }
            index += 1
        }
        if loopStarters.count > 0 {
            //unbalanced open [
            return ("Found more loop opennings [ than endings",false)
        }
        return ("",true)
    }
}


protocol InterpreterCommand {
    var character: Character { get }
    func functionToApply(state: BrainPlusVM) -> String?
}

class IncreaseData: InterpreterCommand {
    var character = Character(">")
    func functionToApply(state: BrainPlusVM) -> String? {
        state.dataPointer += 1
        return nil
    }
}

class DecreaseData: InterpreterCommand {
    var character = Character("<")
     func functionToApply(state: BrainPlusVM) -> String? {
        state.dataPointer -= 1
        return nil
    }
}

class DecreasePointer: InterpreterCommand {
    var character = Character("-")
     func functionToApply(state: BrainPlusVM) -> String? {
         state.decrememntPointer()
        return nil
    }
}

class IncreasePointer: InterpreterCommand {
    var character = Character("+")
     func functionToApply(state: BrainPlusVM) -> String? {
        state.incrememntPointer()
        return nil
    }
}

class Output: InterpreterCommand {
    var character = Character(".")
    func functionToApply(state: BrainPlusVM) -> String? {
        let c = state.getPointerCharacter()
        return "\(c)"
    }
}

class Input: InterpreterCommand {
    /// need to link here a pipe of some sort
    var pipe : Pipe?
    init(pipe: Pipe) {
        self.pipe = pipe
    }
    var character = Character(",")
    func functionToApply(state: BrainPlusVM) -> String? {
        if let outpipe = self.pipe {
            let outdata = outpipe.fileHandleForReading.readData(ofLength: 1)
            if let string = String(data: outdata, encoding: .ascii) {
                if let c = string.characters.first {
                    state.setPointerCharacter(character: c)
                }
            }
        }
        return nil
    }
}

class LoopStart: InterpreterCommand {
    var character = Character("[")
    func functionToApply(state: BrainPlusVM) -> String? {
         let value = state.getPointerValue()
        // current instruction state.instructionPointer
        if value == 0 {
            // jump to the end of the loop
            for loop in state.loops {
                if loop.start == state.instructionPointer {
                    state.instructionPointer = loop.end
                    return nil
                }
            }
        }
        return nil
    }
}

class LoopEnd: InterpreterCommand {
    var character = Character("]")
    func functionToApply(state: BrainPlusVM) -> String? {
        let value = state.getPointerValue()
        // current instruction state.instructionPointer
        if value != 0 {
            // jump to the start of the loop
            for loop in state.loops {
                if loop.end == state.instructionPointer {
                    state.instructionPointer = loop.start
                    return nil
                }
            }
        }
        return nil
    }
}

