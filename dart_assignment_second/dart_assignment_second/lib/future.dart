Future<String> makeTea() async {
  print('Making tea');
  await Future.delayed(Duration(seconds: 3));
  return 'Your tea is ready';
}

void main() async {
  print('One cup of tea');
  var tea = await makeTea();
  print(tea);
  print('Thanks');
}
