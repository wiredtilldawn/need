import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:need/helper/theme_provider.dart';
import '../theme/dark_theme.dart';
import '../theme/light_theme.dart';

class DeleteButton extends StatelessWidget {
  final void Function()? onTap;
  const DeleteButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(Icons.cancel, color: Colors.grey,),
    );
  }
}
