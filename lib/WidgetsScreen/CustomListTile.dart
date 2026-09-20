import 'package:flutter/material.dart';

class Customlisttile extends StatelessWidget {
  const Customlisttile({super.key, this.leading, required this.title, required this.subtitle, this.trailing, });
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,    
      
    );
  }
}