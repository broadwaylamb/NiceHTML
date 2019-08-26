extension Optional {
  var count: Int { self.map { _ in 1 } ?? 0 }
}
