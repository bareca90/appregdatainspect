import 'package:appregdatainspect/core/constants/app_colors.dart';
import 'package:appregdatainspect/core/providers/references_provider.dart';
import 'package:appregdatainspect/models/reference_model.dart';
import 'package:appregdatainspect/screens/references/inspection_form_screen.dart';
import 'package:appregdatainspect/screens/references/widgets/reference_info_row.dart';
import 'package:appregdatainspect/screens/references/widgets/reference_progress_info.dart';
import 'package:appregdatainspect/screens/references/widgets/references_status_indicator.dart';
import 'package:appregdatainspect/screens/references/widgets/sunc_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReferenceCard extends StatelessWidget {
  final Reference reference;

  const ReferenceCard({super.key, required this.reference});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: reference.isComplete
                // ignore: deprecated_member_use
                ? Colors.green.withOpacity(0.3)
                // ignore: deprecated_member_use
                : AppColors.primaryRed.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            final updatedReference = await Navigator.push<Reference>(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    InspectionFormScreen(reference: reference),
              ),
            );

            if (updatedReference != null && context.mounted) {
              final provider = Provider.of<ReferencesProvider>(
                context,
                listen: false,
              );
              provider.updateReference(updatedReference);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Referencia: ${reference.reference}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ReferenceStatusIndicator(isComplete: reference.isComplete),
                  ],
                ),
                const SizedBox(height: 12),
                ReferenceInfoRow(icon: Icons.business, text: reference.client),
                const SizedBox(height: 8),
                ReferenceInfoRow(
                  icon: Icons.confirmation_number,
                  text: reference.containerNumber,
                ),
                const SizedBox(height: 8),
                ReferenceInfoRow(
                  icon: Icons.place,
                  text: reference.loadingArea,
                ),
                const SizedBox(height: 12),
                ReferenceProgressInfo(reference: reference),
                const SizedBox(height: 8),
                SyncStatusIndicator(isSynced: reference.isSynced),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
