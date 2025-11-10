class Person {
  final String name;
  final int age;

  Person({required this.name, required this.age});

  Person copyWith({String? name, int? age}) {
    return Person(name: name ?? this.name, age: age ?? this.age);
  }
}

void main() {
  var p1 = Person(name: 'Sam', age: 15);
  var p2 = p1.copyWith(age: 16);

  print(p1.name);
  print(p1.age);
  print(p2.age);
}
