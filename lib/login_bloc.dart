import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';

class LoginBloc extends BlocBase{
  int _currentPage = 0;

  StreamController<int> _currentPageStreamController = new StreamController<int>();

  int get currentPage=> _currentPage;

  Stream<int> get currentPageStream=> _currentPageStreamController.stream;

  set currentPage(int value){
    _currentPage = value;
    _currentPageStreamController.sink.add(value);

  }

  @override
  void dispose(){
    _currentPageStreamController.close();
    super.dispose();
  }
}