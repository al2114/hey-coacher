
import Foundation

class MenuList {
  var idx: Int = 0
  var count: Int = 0
  var menuItem = [String]()

  
  init(_ items: [String], message: String = ""){
    self.menuItem = items
    self.count = items.count

    if !message.isEmpty {
//      speak(message)
    }
  }

  var currentItem: String {
    return menuItem[idx]
  }

  var previousItem: String {
    return menuItem[mod(idx-1,count)]
  }

  var nextItem: String {
    return menuItem[mod(idx+1,count)]
  }

  func iterNext() {
    idx = mod(idx+1,count)
  }

  func iterPrevious() {
    idx = mod(idx-1,count)
  }
  
  
  
}
