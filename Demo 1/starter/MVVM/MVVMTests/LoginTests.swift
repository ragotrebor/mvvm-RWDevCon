///*
//* Copyright (c) 2016 Razeware LLC
//*
//* Permission is hereby granted, free of charge, to any person obtaining a copy
//* of this software and associated documentation files (the "Software"), to deal
//* in the Software without restriction, including without limitation the rights
//* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//* copies of the Software, and to permit persons to whom the Software is
//* furnished to do so, subject to the following conditions:
//*
//* The above copyright notice and this permission notice shall be included in
//* all copies or substantial portions of the Software.
//*
//* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//* THE SOFTWARE.
//*/
//
//import XCTest
//@testable import MVVM
//
//class LoginTests: XCTestCase {
//
//  var validUserViewModel: UserViewModel!
//  var invalidUserViewModel: UserViewModel!
//
//  override func setUp() {
//    super.setUp()
//
//    let user = User(username: "ecerney", password: "swift")
//    validUserViewModel = UserViewModel(user: user)
//
//    invalidUserViewModel = UserViewModel()
//  }
//
//  override func tearDown() {
//
//    super.tearDown()
//  }
//
//  func testUsername() {
//    XCTAssertEqual(validUserViewModel.username, "ecerney")
//  }
//
//  func testPassword() {
//    XCTAssertEqual(validUserViewModel.password, "swift")
//  }
//
//  func testProtectedUsernameLong() {
//    XCTAssertEqual(validUserViewModel.protectedUsername, "****ney")
//  }
//
//  func testProtectedUsernameShort() {
//    validUserViewModel = UserViewModel(user: User(username: "ec", password: "swift"))
//    XCTAssertEqual(validUserViewModel.protectedUsername, "ec")
//  }
//
//  func testUpdateUsername() {
//    validUserViewModel.updateUsername("rwenderlich")
//    XCTAssertEqual(validUserViewModel.username, "rwenderlich")
//  }
//
//  func testUpdatePassword() {
//    validUserViewModel.updatePassword("vicki")
//    XCTAssertEqual(validUserViewModel.password, "vicki")
//  }
//
//  func testValidateNoUserOrPassword() {
//    let validation = invalidUserViewModel.validate()
//
//    if case .Invalid(let message) = validation {
//      XCTAssertEqual(message, "Username and password are required.")
//    } else {
//      XCTAssert(false)
//    }
//  }
//
//  func testValidateNoPassword() {
//    invalidUserViewModel = UserViewModel(user: User(username: "ecerney", password: ""))
//    let validation = invalidUserViewModel.validate()
//
//    if case .Invalid(let message) = validation {
//      XCTAssertEqual(message, "Username and password are required.")
//    } else {
//      XCTAssert(false)
//    }
//  }
//
//  func testValidateShortUsername() {
//    invalidUserViewModel = UserViewModel(user: User(username: "ec", password: "swift"))
//    let validation = invalidUserViewModel.validate()
//
//    if case .Invalid(let message) = validation {
//      XCTAssertEqual(message, "Username needs to be at least 4 characters long.")
//    } else {
//      XCTAssert(false)
//    }
//  }
//
//  func testValidateShortPassword() {
//    invalidUserViewModel = UserViewModel(user: User(username: "ecerney", password: "sw"))
//    let validation = invalidUserViewModel.validate()
//
//    if case .Invalid(let message) = validation {
//      XCTAssertEqual(message, "Password needs to be at least 5 characters long.")
//    } else {
//      XCTAssert(false)
//    }
//  }
//
//  func testValidateValidUser() {
//    let validation = validUserViewModel.validate()
//
//    if case .Valid = validation {
//      XCTAssert(true)
//    } else {
//      XCTAssert(false)
//    }
//  }
//
//  func testLoginSuccess() {
//    validUserViewModel.login { errorString in
//      XCTAssert(errorString == nil)
//    }
//  }
//
//  func testLoginFailure() {
//    invalidUserViewModel.login { errorString in
//      XCTAssertEqual(errorString, "Invalid credentials.")
//    }
//  }
//}
