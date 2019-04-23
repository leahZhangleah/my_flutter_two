import 'dart:async';

import 'package:repair_server/model/personalmodel.dart';
import 'package:repair_server/viewmodel/personal_view_model.dart';


class PersonalBloc{

  final _menuVM = PersonalViewMModel();
  final menuController = StreamController<List<PersonalModel>>();

  Stream<List<PersonalModel>> get menuItems => menuController.stream;

  PersonalBloc(){
    menuController.add(_menuVM.getPersonalItems());
  }
}