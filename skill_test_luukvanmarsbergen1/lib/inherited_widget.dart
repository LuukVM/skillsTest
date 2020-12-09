import 'package:flutter/material.dart';
import 'package:test_imports/models/user_model.dart';

class InheritedDataGetter extends InheritedWidget {
  final UserModel user;

  InheritedDataGetter({@required this.user ,Widget child}) : super(child: child);

   static InheritedDataGetter of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedDataGetter>();
  }

  @override
    bool updateShouldNotify(InheritedDataGetter old) => user != old.user;

}