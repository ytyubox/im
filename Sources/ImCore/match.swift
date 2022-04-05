func match(_ s: String,_ target: String) -> Bool {
    let s = s.map{$0}
    let target = target.map{$0}
    var p1 = 0, p2 = 0
    while true {
        if p1 == s.count {
            return p2 == target.count
        }
        if p2 == target.count {return true}
        if s[p1].uppercased() == target[p2].uppercased() {
            p1 += 1
            p2 += 1
        } else {
            p1 += 1
        }
    }
}
