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

class ThreatsViewController: UIViewController {
  private let cellIdentifier = "ImageCell"
  private let headerIdentifier = "HeaderView"

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  private var viewModel = ThreatsViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.delegate = self
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    if !LoginService.isAuthenticated {
      presentLoginViewController()
    }
  }
}

// MARK: UICollectionViewDataSource
extension ThreatsViewController: UICollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return viewModel.numberOfThreats()
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.imagePathsForThreatAtIndex(section).count
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell

    let threatImagePaths = viewModel.imagePathsForThreatAtIndex(indexPath.section)
    let imagePath = threatImagePaths[indexPath.item]
    cell.imageView.setImageFromPath(imagePath)

    return cell
  }

  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader {
      let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath)
        as! ResultsHeaderView

      headerView.titleLabel.text = viewModel.nameForThreatAtIndex(indexPath.section)

      return headerView
    }

    assert(false, "Unexpected element kind")
  }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ThreatsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let cellWidth = (collectionView.bounds.width - CGFloat(30)) / 2.0
    return CGSize(width: cellWidth, height: cellWidth)
  }
}

// MARK: Actions
extension ThreatsViewController {
  @IBAction func logoutPressed() {
    LoginService.logout {
      self.presentLoginViewController() {
        self.viewModel.clearThreats()
      }
    }
  }
}

// MARK: Private Methods
private extension ThreatsViewController {
  func presentLoginViewController(completion: (() -> Void)? = nil) {
    let loginVC = storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
    loginVC.loginSuccess = {
      self.activityIndicator.startAnimating()
      self.dismissViewControllerAnimated(true) {
        self.viewModel.fetchThreats()
      }
    }

    presentViewController(loginVC, animated: true, completion: completion)
  }
}

// MARK: - ThreatListViewModelDelegate
extension ThreatsViewController: ThreatsViewModelDelegate {
  func threatsChanged() {
    self.collectionView?.reloadData()
    self.activityIndicator.stopAnimating()
  }
}
