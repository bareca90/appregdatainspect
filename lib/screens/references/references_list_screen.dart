import 'package:appregdatainspect/core/constants/app_colors.dart';
import 'package:appregdatainspect/core/providers/references_provider.dart';
/* import 'package:appregdatainspect/models/reference_model.dart';
import 'package:appregdatainspect/screens/references/inspection_form_screen.dart'; */
import 'package:appregdatainspect/screens/references/widgets/reference_card.dart';
import 'package:appregdatainspect/screens/references/widgets/reference_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReferencesListScreen extends StatelessWidget {
  const ReferencesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReferencesProvider>(context, listen: false);

    // Cargar datos después del frame inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadReferences();
    });

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Lista de Referencias'),
        titleTextStyle: TextStyle(
          color: Colors.white, // Texto en blanco
          fontSize: 20, // Tamaño opcional
          fontWeight: FontWeight.bold, // Peso opcional
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final references = provider.references;
              await showSearch<int>(
                context: context,
                delegate: ReferenceSearchDelegate(references),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              final provider = Provider.of<ReferencesProvider>(
                context,
                listen: false,
              );
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              try {
                // Primero sincronizar los cambios locales
                await provider.syncPendingReferences();

                // Luego actualizar toda la lista
                await provider.syncReferences();

                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Datos sincronizados correctamente'),
                  ),
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Error al sincronizar: ${e.toString()}'),
                  ),
                );
              }
            },
            tooltip: 'Sincronizar',
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<ReferencesProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.references.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.hasError && provider.references.isEmpty) {
          return _buildErrorView(context, provider);
        }

        if (provider.references.isEmpty) {
          return _buildEmptyView(context);
        }

        return _buildReferencesList(provider);
      },
    );
  }

  Widget _buildErrorView(BuildContext context, ReferencesProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 50,
            color: AppColors.primaryRed,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              provider.errorMessage,
              style: const TextStyle(color: AppColors.primaryRed, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => provider.loadReferences(),
            child: const Text('Reintentar', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.list_alt, size: 50, color: AppColors.darkGray),
          const SizedBox(height: 16),
          const Text(
            'No hay referencias disponibles',
            style: TextStyle(fontSize: 18, color: AppColors.darkGray),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Provider.of<ReferencesProvider>(
              context,
              listen: false,
            ).loadReferences(),
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildReferencesList(ReferencesProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.loadReferences(),
      color: AppColors.primaryBlue,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.references.length,
        itemBuilder: (context, index) {
          final reference = provider.references[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            //child: _ReferenceCard(reference: reference),
            child: ReferenceCard(reference: reference),
          );
        },
      ),
    );
  }
}

/* class _ReferenceCard extends StatelessWidget {
  final Reference reference;

  const _ReferenceCard({required this.reference});

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
            // Navegar a pantalla de detalle si es necesario
            final updatedReference = await Navigator.push<Reference>(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    InspectionFormScreen(reference: reference),
              ),
            );

            if (updatedReference != null) {
              // Actualizar la referencia en tu provider
              // ignore: use_build_context_synchronously
              final provider = Provider.of<ReferencesProvider>(
                // ignore: use_build_context_synchronously
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
                    _buildStatusIndicator(context),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.business, reference.client),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.confirmation_number,
                  reference.containerNumber,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.place, reference.loadingArea),
                const SizedBox(height: 12),
                _buildProgressInfo(context),
                if (!reference.isSynced) ...[
                  const SizedBox(height: 8),
                  _buildSyncStatus(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
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

  Widget _buildStatusIndicator(BuildContext context) {
    final isComplete = reference.isComplete;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isComplete
            // ignore: deprecated_member_use
            ? Colors.green.withOpacity(0.1)
            // ignore: deprecated_member_use
            : AppColors.primaryRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isComplete ? Colors.green : AppColors.primaryRed,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isComplete ? Icons.check : Icons.warning_amber_rounded,
            size: 14,
            color: isComplete ? Colors.green : AppColors.primaryRed,
          ),
          const SizedBox(width: 4),
          Text(
            isComplete ? 'Completo' : 'Pendiente',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isComplete ? Colors.green : AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressInfo(BuildContext context) {
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

  Widget _buildSyncStatus(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.sync_problem, size: 16, color: AppColors.primaryRed),
        const SizedBox(width: 8),
        Text(
          'Pendiente de sincronización',
          style: TextStyle(
            color: AppColors.primaryRed,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
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
} */
