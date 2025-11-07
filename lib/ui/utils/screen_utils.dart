import 'dart:io';

void clearScreen() {
  if (Platform.isWindows) {
    print(Process.runSync("cls", [], runInShell: true).stdout);
  } else {
    print(Process.runSync("clear", [], runInShell: true).stdout);
  }
}

// Alternative simpler method (works on most terminals)
void clearScreenSimple() {
  print('\x1B[2J\x1B[0;0H');
}