//  Copyright © 2016 Alexey Vlaskin. All rights reserved.

@testable import BrainPlusLanguageInterpreter

import XCTest
import Foundation

class BPTests: XCTestCase {
    
    func testBrainPlusInterpreter1() {
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
    
    func testBrainPlusInterpreter2() {
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
    
    func testBrainPlusInterpreter3() {
        let program = ">>++"
        let instructionSet:[InterpreterCommand] = [IncreaseData(),DecreaseData(),DecreaseData(),DecreasePointer(),IncreasePointer()]
        let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
        let vm = BrainPlusVM()
        let (res, passed) = i.run(brainfvm: vm)
        XCTAssertTrue(passed || res.characters.count == 0, "Test move and increase pointer failed $3")
        XCTAssertTrue(vm.dataPointer == 2,"Test move and increase pointer failed")
        XCTAssertTrue(vm.getPointerValue() == 2, "Error : expected 2")
    }
    
    func testBrainPlusInterpreter4() {
        let program = ">>+-"
        let instructionSet:[InterpreterCommand] = [IncreaseData(),DecreaseData(),DecreasePointer(),IncreasePointer()]
        let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
        let vm = BrainPlusVM()
        let (res, passed) = i.run(brainfvm: vm)
        XCTAssertTrue(passed || res.characters.count == 0, "Test move and increase/decrease pointer failed #4")
        XCTAssertTrue(vm.dataPointer == 2,"Test move pointer failed #4")
        XCTAssertTrue(vm.getPointerValue() == 0, "Error : expected 0 #4")
    }
    
    func testBrainPlusInterpreter5() {
        let program = ">>+--"
        let instructionSet:[InterpreterCommand] = [IncreaseData(),DecreaseData(),DecreasePointer(),IncreasePointer()]
        let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
        let vm = BrainPlusVM()
        let (res, passed) = i.run(brainfvm: vm)
        XCTAssertTrue(passed || res.characters.count == 0, "Test move and increase/decrease pointer failed #5")
        XCTAssertTrue(vm.dataPointer == 2,"Test move pointer failed #5")
        XCTAssertTrue(vm.getPointerValue() == 255, "Overflow Error : expected 255 #5")
    }
    
    func testBrainPlusInterpreter6() {
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
        XCTAssertTrue(passed || res.characters.count == 1, "Test failed #6")
        XCTAssertTrue(vm.dataPointer == 2,"Test move pointer failed #6")
        XCTAssertTrue(vm.getPointerValue() == 255, "Overflow Error : expected 255 #6")
    }
    
    func testBrainPlusInterpreter7() {
        //This should be the test for input, but I will skip it for now
        let program = ">>+--."
        let instructionSet:[InterpreterCommand] = [
            IncreaseData(),
            DecreaseData(),
            DecreasePointer(),
            IncreasePointer(),
            //Input(),
            Output()]
        let i = BrainPlusInterpreter(program: program, instructions:instructionSet)
        let vm = BrainPlusVM()
        let (res, passed) = i.run(brainfvm: vm)
        XCTAssertTrue(passed || res.characters.count == 1, "Test failed #7")
        XCTAssertTrue(vm.dataPointer == 2,"Test move pointer failed #7")
        XCTAssertTrue(vm.getPointerValue() == 255, "Overflow Error : expected 255 #7")
    }
    
    func testBrainPlusInterpreter8() {
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
        XCTAssertFalse(passed, "Test failed #8")
        // Res should have an error description
        XCTAssertTrue(res.characters.count > 0, "Test failed #8")
    }

    func testBrainPlusInterpreter9() {
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
        XCTAssertTrue(passed || res.characters.count > 8, "Test failed #9")
    }
    
    func testBrainPlusInterpreter10() {
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
        XCTAssertTrue(passed, "Test program failed #10")
        XCTAssertEqual(res, expectedResult, "Test program Hello World - failed #10")
    }
    
    func testBrainPlusInterpreter11() {
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
        XCTAssertTrue(passed, "Test program failed #11")
        XCTAssertEqual(res, expectedResult, "Test program Hello World - failed #11")
    }
    
    func testBrainPlusInterpreter12() {
        //This is a slightly more complex variant that often triggers interpreter bugs
        let expectedResult = "Hello World!\n"
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
        XCTAssertTrue(passed, "Test program failed #12")
        XCTAssertEqual(res, expectedResult, "Test program Hello World - failed #12")
    }
}
