import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';

class NavNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void updateIndex(int value){
    state = value;
  }

}

final navProvider = NotifierProvider<NavNotifier, int>(NavNotifier.new,);