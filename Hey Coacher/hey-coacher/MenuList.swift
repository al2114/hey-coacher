
import Foundation

class MenuItem{
  var desc: String
  var id: String
  
  init(_ desc: String, _ id: String){
    self.desc = desc
    self.id = id
  }
  
  func modifyDesc(_ newDesc: String){
    self.desc = newDesc
  }
}

class MenuList {
  var idx: Int = 0
  var count: Int = 0
  var items = [MenuItem]()
  
  
  init(_ items: [MenuItem], message: String = "", idx: Int = 0){
    self.items = items
    self.count = items.count
    self.idx = idx

    if message != "" {
      speak(message)
      entrySpeech = true
    }
    else {
      speak(currentItem)
    }
  }

  var currentItem: String {
    return items[idx].desc
  }

  var previousItem: String {
    return items[mod(idx-1,count)].desc
  }

  var nextItem: String {
    return items[mod(idx+1,count)].desc
  }

  func iterNext() {
    idx = mod(idx+1,count)
    speak(currentItem)
  }

  func iterPrevious() {
    idx = mod(idx-1,count)
    speak(currentItem)
  }
  
  func currentId() -> String {
    return items[idx].id
  }
  
  func updateItemDesc(itemId: String, newDesc: String){
    for item in items{
      if item.id == itemId {
        item.modifyDesc(newDesc)
      }
    }
  }
  
  
}
