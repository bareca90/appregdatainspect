import 'package:appregdatainspect/core/constants/app_colors.dart';
import 'package:appregdatainspect/models/reference_model.dart';
import 'package:flutter/material.dart';

class ReferenceProgressInfo extends StatelessWidget {
  final Reference reference;

  const ReferenceProgressInfo({super.key, required this.reference});

  @override
  Widget build(BuildContext context) {
    final completedSteps = _calculateCompletedSteps();
    final totalSteps = 3;
    final progress = completedSteps / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.timeline,
              size: 16,
              // ignore: deprecated_member_use
              color: AppColors.darkGray.withOpacity(0.7),
            ),
            const SizedBox(width: 8),
            Text(
              'Progreso: $completedSteps/$totalSteps pasos',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.lightGray,
          color: progress == 1 ? Colors.green : AppColors.primaryBlue,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  int _calculateCompletedSteps() {
    int steps = 0;

    // Paso 1: Liberación
    if (reference.releaseStartDate != null &&
        reference.releaseStartTime != null &&
        reference.releaseFinishDate != null &&
        reference.releaseFinishTime != null &&
        reference.releaseTemperature != null) {
      steps++;
    }

    // Paso 2: Muestreo
    if (reference.sampleStartDate != null &&
        reference.sampleStartTime != null &&
        reference.sampleFinishDate != null &&
        reference.sampleFinishTime != null &&
        reference.sampleTemperature != null) {
      steps++;
    }

    // Paso 3: Sellado
    if (reference.stampedDate != null &&
        reference.stampedTime != null &&
        reference.stampedTemperature != null) {
      steps++;
    }

    return steps;
  }
}
