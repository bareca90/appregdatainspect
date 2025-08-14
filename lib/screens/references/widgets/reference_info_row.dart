import 'package:appregdatainspect/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ReferenceInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ReferenceInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ignore: deprecated_member_use
        Icon(icon, size: 18, color: AppColors.darkGray.withOpacity(0.7)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text.trim(),
            style: const TextStyle(fontSize: 15),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
