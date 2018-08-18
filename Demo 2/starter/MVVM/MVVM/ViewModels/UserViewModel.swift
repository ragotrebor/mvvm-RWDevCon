/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

enum UserValidationState {
  case Valid
  case Invalid(String)
}

class UserViewModel {
  private let minUsernameLength = 4
  private let minPasswordLength = 5
  private var user = User()

  var username: String {
    return user.username
  }

  var password: String {
    return user.password
  }

  var protectedUsername: String {
    let characters = username.characters

    if characters.count >= minUsernameLength {
      var displayName = [Character]()
      for (index, character) in characters.enumerate() {
        if index > characters.count - minUsernameLength {
          displayName.append(character)
        } else {
          displayName.append("*")
        }
      }
      return String(displayName)
    }

    return username
  }
}

// MARK: Public Methods
extension UserViewModel {
  func updateUsername(username: String) {
    user.username = username
  }

  func updatePassword(password: String) {
    user.password = password
  }

  func validate() -> UserValidationState {
    if user.username.isEmpty || user.password.isEmpty {
      return .Invalid("Username and password are required.")
    }

    if user.username.characters.count < minUsernameLength {
      return .Invalid("Username needs to be at least \(minUsernameLength) characters long.")
    }

    if user.password.characters.count < minPasswordLength {
      return .Invalid("Password needs to be at least \(minPasswordLength) characters long.")
    }

    return .Valid
  }

  func login(completion: (errorString: String?) -> Void) {
    LoginService.loginWithUsername(user.username, password: user.password) { success in
      if success {
        completion(errorString: nil)
      } else {
        completion(errorString: "Invalid credentials.")
      }
    }
  }
}