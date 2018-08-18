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

struct SpyService {
  static func getNearbyThreats(completion: ([Threat]) -> ()) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
      sleep(1)
      let bundlePath = NSBundle.mainBundle().bundlePath + "/ThreatData"
      let enumerator = NSFileManager.defaultManager().enumeratorAtPath(bundlePath)

      var threats = [Threat]()

      while let element = enumerator?.nextObject() as? String {
        var isDir: ObjCBool = false
        let path = bundlePath + "/\(element)"
        if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir) {
          if isDir {
            let contents = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)

            var imagePaths = [String]()
            for image in contents {
              let fullPath = path + "/\(image)"
              imagePaths.append(fullPath)
            }
            let nameComponents = element.componentsSeparatedByString(" ")

            let threat = Threat(firstName: nameComponents[0], lastName: nameComponents[1], imagePaths: imagePaths)
            threats.append(threat)
          }
        }
      }

      dispatch_async(dispatch_get_main_queue()) {
        completion(threats)
      }
    }
  }
}
