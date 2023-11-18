void main() {
  // String text = 'Makanan Indonesia Raya sangant populer';
  // String change = 'Hidup';
  // String newString = text.replaceAll('Makanan', 'Hidup');
  // print(newString);

  String value = 'My name is Emporio';
  String valueUpdate = value.replaceRange(value.length, null, ' Satria');
  // print(valueUpdate);

  Map yourMap = {
    'key1':
        '{date: 5/11/2023, image: exammple, description: 53, id: sss, time: 4:01 PM - Sun, title: Bakso255728}',
    'key2':
        "{date: 5/11/2023, description: Besok senin boy, id: 'ss', time: 6:15 PM - Sun, title: Entah aku gak tau}",
    'key3':
        ' {date: 9/11/2023, keyData: ss, description: ss, time: 9:18 PM - Thu, title: 15}'
  };

  var sortedMap = Map.fromEntries(
      yourMap.entries.toList()..sort((e1, e2) => e2.key.compareTo(e1.key)));

  print(sortedMap);
}
