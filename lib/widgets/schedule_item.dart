import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';

class ScheduleItem extends StatelessWidget {
  final String type;
  final String time;
  final Color color;
  final String location;
  final String? notes;

  const ScheduleItem({
    super.key,
    required this.type,
    required this.time,
    required this.color,
    required this.location,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            type,
            style: AppTextStyles.listSubheading.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (time.isNotEmpty) ...[
            SizedBox(height: AppSpacing.xs),
            Text(
              time,
              style: AppTextStyles.listSubheading.copyWith(
                color: color,
              ),
            ),
          ],
          if (location.isNotEmpty) ...[
            SizedBox(height: AppSpacing.xs),
            Text(
              location,
              style: AppTextStyles.listSubheading.copyWith(
                fontSize: 10,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (notes?.isNotEmpty == true) ...[
            SizedBox(height: AppSpacing.xs),
            Text(
              notes!,
              style: AppTextStyles.listSubheading.copyWith(
                fontSize: 10,
                color: color,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
} 