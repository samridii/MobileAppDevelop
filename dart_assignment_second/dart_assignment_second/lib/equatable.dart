class Person {
  final String name;
  final int age;

  Person(this.name, this.age);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person && other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}

void main() {
  var p1 = Person('Sam', 15);
  var p2 = Person('Sam', 15);

  print(p1 == p2);
}
