import 'package:easy_management/screens/create_account.dart';
import 'package:easy_management/screens/confirm_account.dart';
import 'package:easy_management/screens/forgot_password.dart';
import 'package:easy_management/screens/home.dart';
import 'package:flutter/material.dart';

// Views
import '../screens/login.dart';

class RoutesConroller {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Se precisar passar args depois
    // final args = settings.arguments;

    switch (settings.name) {
      // case '/':
      //   return MaterialPageRoute(builder: (_) => Home());
      //   break;
      // case '/exemplo':
      //   if (args is String) {
      //     return MaterialPageRoute(builder: (_) => Exemplo(data: args))
      //   }
      //   return _errorRoute();
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/forgotPassword':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/createAccount':
        return MaterialPageRoute(builder: (_) => const CreateAccountScreen());
      case '/confirmAccount':
        return MaterialPageRoute(builder: (_) => const ConfirmAccountScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Error!"),
        ),
        body: const Center(
          child: Text("Error!"),
        ),
      );
    });
  }
}
