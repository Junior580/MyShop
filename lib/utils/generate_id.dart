import 'dart:math';

String generateRandomId([int length = 8]) {
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return List.generate(
      length, (index) => characters[random.nextInt(characters.length)]).join();
}
