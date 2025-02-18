import 'package:flutter/material.dart';

class ChooseButtonWidget extends StatelessWidget {
  final bool isSelect;
  const ChooseButtonWidget({super.key, this.isSelect = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: isSelect ? const Color(0XFF4D970C) : Colors.transparent,
        border: isSelect
            ? null
            : Border.all(
                width: 1.5,
                color: const Color(0XFFD1D1D3),
              ),
      ),
    );
  }
}
