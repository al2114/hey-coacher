
import Foundation

struct MenuItem{
  var desc: String
  var id: String
  init(_ desc: String, _ id: String){
    self.desc = desc
    self.id = id
  }
}

class MenuList {
  var idx: Int = 0
  var count: Int = 0
  var items = [MenuItem]()
  
  
  init(_ items: [MenuItem], message: String = ""){
    self.items = items
    self.count = items.count

    if !message.isEmpty {
      speak(message)
      entrySpeech = true
      speakWait(currentItem)
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
  
  
}
