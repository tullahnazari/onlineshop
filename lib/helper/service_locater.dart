import 'package:get_it/get_it.dart';
import 'package:halalbazaar/helper/calls_messaging_service.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}
