import 'package:appregdatainspect/core/constants/app_colors.dart';
import 'package:appregdatainspect/models/reference_model.dart';
import 'package:appregdatainspect/screens/references/widgets/reference_card.dart';
import 'package:flutter/material.dart';

class ReferenceSearchDelegate extends SearchDelegate<int> {
  final List<Reference> references;

  ReferenceSearchDelegate(this.references);

  @override
  String get searchFieldLabel => 'Buscar por número de referencia';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, 0);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredReferences = query.isEmpty
        ? references
        : references.where((ref) {
            final refId = ref.reference.toString();
            return refId.contains(query);
          }).toList();

    if (filteredReferences.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 50, color: AppColors.darkGray),
            SizedBox(height: 16),
            Text(
              'No se encontraron referencias',
              style: TextStyle(fontSize: 18, color: AppColors.darkGray),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredReferences.length,
      itemBuilder: (context, index) {
        final reference = filteredReferences[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ReferenceCard(reference: reference),
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.white70),
        border: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(color: Colors.white),
      ),
    );
  }
}
