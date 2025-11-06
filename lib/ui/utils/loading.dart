import 'dart:io';

void printLoading() {
  const total = 30;
  for (int i = 0; i <= total; i++) {
    stdout.write('\x1B[2J\x1B[0;0H');
    int filled = i;
    String bar = '█' * filled + '-' * (total - filled);

    print("                   ==============================");
    print("                   | Loading... ${i * 100 ~/ total}%      |");
    print("                   ==============================");
    print("                   [$bar]");

    sleep(Duration(milliseconds: 50));
  }

  stdout.write('\x1B[2J\x1B[0;0H');
  print("                   ==============================");
  print("                   |     Load Complete!      |");
  print("                   ==============================");
}