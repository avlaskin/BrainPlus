import XCTest

@testable import BrainPlusVM
@testable import BrainPlusInterpreter

func test1() -> Bool {
    let program = ">>"
    let instructionSet:[InterpreterCommand] = [IncreaseData(),DecreaseData()]
    let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if vm.dataPointer != 2 {
        return false
    }
    if !passed || res.characters.count > 0 {
        return false
    }
    return true
}

func test2() -> Bool {
    let program = "><"
    let instructionSet:[InterpreterCommand] = [IncreaseData(),DecreaseData()]
    let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if !passed || res.characters.count > 0 {
        return false
    }
    if vm.dataPointer != 0 {
        return false
    }
    return true
}

func test3() -> Bool {
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
func test4() -> Bool {
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

func test5() -> Bool {
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

func test6() -> Bool {
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

func test7() -> Bool {
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

func test8() -> Bool {
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

func test9() -> Bool {
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

func test10() -> Bool {
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

func test11() -> Bool {
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

func test13() -> Bool {
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

func test12() -> Bool {
    let instructionSet:[InterpreterCommand] = [
        IncreaseData(),
        DecreaseData(),
        DecreasePointer(),
        IncreasePointer(),
        Output(),
        LoopStart(),
        LoopEnd()]
    let alphabet = "+-<>.[]"
    var nucs: [UInt8] = []
    for c in alphabet.characters {
        let n: UInt8 = UInt8((UnicodeScalar("\(c)")! as UnicodeScalar).value)
        nucs.append(n)
    }

    let p4 =   "+[[++<+>+++]<++++>>+<[[<-[]<.<++]]<++++++++++++.-.-.>>>]"
    let g = Genome(length: 14 , geneLength: 4, uniqueNucs: nucs)
    let r = g.fillInPlace(fromString: p4)

    if !r {
        return false
    }
    
    let i = BrainPlusInterpreter(program: g.description(), instructions:instructionSet)
    let vm = BrainPlusVM()
    let (res, passed) = i.run(brainfvm: vm)
    if passed && res.count == 3 {
        return true
    }
    return false
}

func test14() -> Bool {
    let p  = "++++[+-+>+<+++]>+[+.[]<<[]]+[[.+>.->-+>+-+<.>]<]"
    let instructionSet:[InterpreterCommand] = [
        IncreaseData(),
        DecreaseData(),
        DecreasePointer(),
        IncreasePointer(),
        Output(),
        LoopStart(),
        LoopEnd()]
    let alphabet = "+-<>.[]"
    var nucs: [UInt8] = []
    for c in alphabet.characters {
        let n: UInt8 = UInt8((UnicodeScalar("\(c)")! as UnicodeScalar).value)
        nucs.append(n)
    }
    
    let g = Genome(length: 6 , geneLength: 8, uniqueNucs: nucs)
    let r = g.fillInPlace(fromString: p)

    if !r {
        return false
    }
    let vm = BrainPlusVM()
    for _ in 0..<4 {
        let i = BrainPlusInterpreter(program: g.description(), instructions:instructionSet)
        let (res, passed) = i.run(brainfvm: vm)
        if !passed || res.asciiArray.count != 1 || res.asciiArray[0] != 65 {
            return false
        }
        vm.resetState()
    }
    return true
}

class BPTests: XCTestCase {
    func testInitSetsTitle() {
        
        
        XCTAssertEqual(todo.title, "test", "Incorrect title")
    }
}
