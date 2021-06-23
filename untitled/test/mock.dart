import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/database.dart';

class MockDatabase extends Mock implements Database {}
class MockAuth extends Mock implements AuthBase {}
class MockNavigatorObservers extends Mock implements NavigatorObserver{}

