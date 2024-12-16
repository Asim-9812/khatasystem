import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khatasystem/main.dart';
import 'package:khatasystem/features/login/presentation/user_login.dart';
import 'package:khatasystem/view/main_page.dart';



class StatusPage extends ConsumerWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return sessionBox.isEmpty ? const UserLoginView() : const MainView();
  }
}

