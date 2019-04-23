import 'dart:async';

import 'package:repair_server/model/menu.dart';
import 'package:repair_server/viewmodel/perform_viewmodel.dart';

class PerformBloc{

  final _menuVM = PerformViewModel();
  final menuController = StreamController<List<Menu>>();

  Stream<List<Menu>> get menuItems => menuController.stream;

  PerformBloc(){
    menuController.add(_menuVM.getMenuItems());
  }
}