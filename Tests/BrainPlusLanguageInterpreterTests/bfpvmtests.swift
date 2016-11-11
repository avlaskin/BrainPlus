@testable import BrainPlusLanguageInterpreter

import XCTest
import Foundation

/*


public func test3() -> Bool {
    let program = ">>++"
    let instructionSet:[InterpreterCommand] = [IncreaseData(),DecreaseData(),DecreaseData(),DecreasePointer(),IncreasePointer()]
    let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if !passed || res.characters.count > 0 {
        return false
    }
    if vm.dataPointer != 2 {
        return false
    }
    if vm.getPointerValue() != 2 {
        print("Error : expected 2 == \(vm.getPointerValue())")
        print("\(vm.description())")
        return false
    }
    return true
}
public func test4() -> Bool {
    let program = ">>+-"
    let instructionSet:[InterpreterCommand] = [IncreaseData(),DecreaseData(),DecreasePointer(),IncreasePointer()]
    let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if !passed || res.characters.count > 0 {
        return false
    }
    if vm.dataPointer != 2 {
        return false
    }
    if vm.getPointerValue() != 0 {
        print("Error : expected 2 == \(vm.getPointerValue())")
        print("\(vm.description())")
        return false
    }
    return true
}

public func test5() -> Bool {
    let program = ">>+--"
    let instructionSet:[InterpreterCommand] = [IncreaseData(),DecreaseData(),DecreasePointer(),IncreasePointer()]
    let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if !passed || res.characters.count > 0 {
        return false
    }
    if vm.dataPointer != 2 {
        return false
    }
    if vm.getPointerValue() != 255 {
        print("Error : expected 255 == \(vm.getPointerValue())")
        print("\(vm.description())")
        return false
    }
    return true
}

public func test6() -> Bool {
    let program = ">>+--."
    let instructionSet:[InterpreterCommand] = [
        IncreaseData(),
        DecreaseData(),
        DecreasePointer(),
        IncreasePointer(),
        Output()]
    let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if !passed {
        return false
    }
    if res.characters.count != 1 {
        return false
    }
    if vm.dataPointer != 2 {
        return false
    }
    if vm.getPointerValue() != 255 {
        print("Error : expected 255 == \(vm.getPointerValue())")
        print("\(vm.description())")
        return false
    }
    return true
}

public func test7() -> Bool {
    //This should be the test for input, but I will skip it for now
    let program = ">>+--."
    let instructionSet:[InterpreterCommand] = [
        IncreaseData(),
        DecreaseData(),
        DecreasePointer(),
        IncreasePointer(),
        Output()]
    let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if !passed {
        return false
    }
    if res.characters.count != 1 {
        return false
    }
    if vm.dataPointer != 2 {
        return false
    }
    if vm.getPointerValue() != 255 {
        print("Error : expected 255 == \(vm.getPointerValue())")
        print("\(vm.description())")
        return false
    }
    return true
}

public func test8() -> Bool {
    //This tests invalid brackets
    let program = ">>+--["
    let instructionSet:[InterpreterCommand] = [
        IncreaseData(),
        DecreaseData(),
        DecreasePointer(),
        IncreasePointer(),
        Output()]
    let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if passed {
        return false
    }
    if res.characters.count > 0 {
        print("Error: \(res)")
    } else {
        return false
    }
    // it should fail
    return true
}

public func test9() -> Bool {
    //This tests invalid brackets
    let program = "+++++++++[.-]"
    let instructionSet:[InterpreterCommand] = [
        IncreaseData(),
        DecreaseData(),
        DecreasePointer(),
        IncreasePointer(),
        Output(),
        LoopStart(),
        LoopEnd()]
    let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if !passed {
        return false
    }
    if res.characters.count < 9 {
        return false
    }
    return true
}

public func test10() -> Bool {
    //This tests should show hello world
    let expectedResult = "Hello world!"
    let program = "--[>--->->->++>-<<<<<-------]>--.>---------.>--..+++.>----.>+++++++++.<<.+++.------.<-.>>+."
    let instructionSet:[InterpreterCommand] = [
        IncreaseData(),
        DecreaseData(),
        DecreasePointer(),
        IncreasePointer(),
        Output(),
        LoopStart(),
        LoopEnd()]
    let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if !passed {
        return false
    }
    if res != expectedResult {
        return false
    }
    // it should fail
    return true
}

public func test11() -> Bool {
    //This tests should show hello world
    let expectedResult = "Hello World!\n"
    let program = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."
    let instructionSet:[InterpreterCommand] = [
        IncreaseData(),
        DecreaseData(),
        DecreasePointer(),
        IncreasePointer(),
        Output(),
        LoopStart(),
        LoopEnd()]
    let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if !passed {
        return false
    }
    if res != expectedResult {
        return false
    }
    return true
}

public func test12() -> Bool {
    let expectedResult = "Hello World!\n"
    //This is a slightly more complex variant that often triggers interpreter bugs
    let program = ">++++++++[-<+++++++++>]<.>>+>-[+]++>++>+++[>[->+++<<+++>]<<]>-----.>->+++..+++.>-.<<+[>[+>+]>>]<--------------.>>.+++.------.--------.>+.>+."
    let instructionSet:[InterpreterCommand] = [
        IncreaseData(),
        DecreaseData(),
        DecreasePointer(),
        IncreasePointer(),
        Output(),
        LoopStart(),
        LoopEnd()]
    let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if !passed {
        return false
    }
    if res != expectedResult {
        return false
    }
    // it should fail
    return true
}
*/
class BPTests: XCTestCase {
    func testBrainPlusInterpreterFirst() {
        var result = false
        let program = ">>"
        let instructionSet:[InterpreterCommand] = [IncreaseData(),DecreaseData()]
        let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
        let vm = BrainPlusVM()
        let (res, passed) = i.run(brainfvm: vm)
        if vm.dataPointer != 2 {
            result = false
        } else
        if !passed || res.characters.count > 0 {
            result = false
        } else
        if passed && res.characters.count == 0 {
            result = true
        }
        XCTAssertTrue(result, "Test move pointer failed #1")
    }
    
    func testBrainPlusInterpreterSecond() {
        var result = false
        let program = ">>++"
        let instructionSet:[InterpreterCommand] = [IncreaseData(),DecreaseData(),DecreaseData(),DecreasePointer(),IncreasePointer()]
        let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
        let vm = BrainPlusVM()
        let (res, passed) = i.run(brainfvm: vm)
        if !passed || res.characters.count > 0 {
            result = false
        } else
        if vm.dataPointer != 2 {
            result = false
        } else
        if vm.getPointerValue() != 2 {
            print("Error : expected 2 == \(vm.getPointerValue())")
            print("\(vm.description())")
            result = false
        } else {
            result = true
        }
        XCTAssertTrue(result, "Test move pointer failed #2")
    }
}
