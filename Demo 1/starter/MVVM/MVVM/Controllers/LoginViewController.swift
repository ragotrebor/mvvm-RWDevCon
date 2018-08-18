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

import UIKit

class LoginViewController: UIViewController {
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var codeLabel: UILabel!

  @IBOutlet weak var topVaultView: UIView!
  @IBOutlet weak var bottomVaultView: UIView!
  @IBOutlet weak var lockView: UIImageView!

  private var transitionCordinator = LockAnimator()
  // TODO: Add ViewModel property

  // TODO: Move to ViewModel
  private let minUsernameLength = 4
  private let minPasswordLength = 5
  private var user = User()

  var loginSuccess: (() -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    transitioningDelegate = transitionCordinator
  }
}

// MARK: Actions
extension LoginViewController {
  @IBAction func dismissKeyboard() {
    view.endEditing(true)
  }

  @IBAction func authenticate() {
    dismissKeyboard()

    // TODO: Use ViewModel to validate / login
    switch validate() {
    case .Valid:
      login() { errorMessage in
        if let errorMessage = errorMessage {
          self.displayErrorMessage(errorMessage)
        } else {
          self.loginSuccess?()
        }
      }
    case .Invalid(let error):
      displayErrorMessage(error)
    }
  }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(textField: UITextField) {
    if textField == usernameField {
      // TODO: Reset username text from ViewModel
      textField.text = user.username
    }
  }

  func textFieldDidEndEditing(textField: UITextField) {
    if textField == usernameField {
      // TODO: Get protected username from ViewModel
      textField.text = protectedUsername(user.username)
    }
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == usernameField {
      passwordField.becomeFirstResponder()
    } else {
      authenticate()
    }

    return true
  }

  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)

    if textField == usernameField {
      // TODO: Update ViewModel
      user.username = newString
    } else if textField == passwordField {
      // TODO: Update ViewModel
      user.password = newString
    }

    return true
  }
}

// MARK: Private Methods
private extension LoginViewController {
  func displayErrorMessage(errorMessage: String) {
    let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .Alert)
    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(okAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
}

// MARK: Things to move
extension LoginViewController {
  enum UserValidationState {
    case Valid
    case Invalid(String)
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

  func protectedUsername(username: String) -> String {
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
