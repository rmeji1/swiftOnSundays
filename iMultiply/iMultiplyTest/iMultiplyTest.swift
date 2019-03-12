//
//  iMultiplyTest.swift
//  iMultiplyTest
//
//  Created by robert on 2/11/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

@testable import iMultiply
import XCTest

class iMultiplyTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
  
  func testQuestionOperandsWithinBounds(){
    let question = Question()
    
    XCTAssertGreaterThanOrEqual(question.left, 1)
    XCTAssertGreaterThanOrEqual(question.right, 1)
    XCTAssertLessThanOrEqual(question.left, 12)
    XCTAssertLessThanOrEqual(question.right, 12)
  }
  
  func testQuestionStringIsFormattedCorrectly(){
    let question = Question(left: 5, right: 5, operation: .multiply)
    
    XCTAssertEqual(question.string, "What is 5 multiplied by 5?")
  }

  func testAddWorks(){
    let question = Question(left: 5, right: 5, operation: .add)
    XCTAssertEqual(question.answer, 10)
  }
  
  func testStringInputWorks(){
    let question = Question(left: 5, right: 5, operation: .add)
    let game = iMultiply()
    let result = game.process("0", for: question)
    XCTAssertEqual("Wrong!", result)
  }
  
  func testAnsweringQeustionIncrementsCounter(){
    let question = Question(left: 5, right: 5, operation: .add)
    let game = iMultiply()
    _ = game.process("0", for: question)
    XCTAssertEqual(game.questionNumber, 2)
  }
  
  func testGamecompletesAt11thQuestion(){
    let game = iMultiply()
    game.answerFunction = {return "556"}
    game.start()
    
    XCTAssertEqual(game.questionNumber, 11)
    XCTAssertEqual(game.score, 0)
  }
}
