import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api.dart';
import '../models.dart';
import '../providers.dart';
class DetailsScreen extends ConsumerWidget {
    final int fdcId;
    final String title;
    const DetailsScreen({super.key, required this.fdcId, required this.title});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final api = ref.watch(apiProvider);
        return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: FutureBuilder<FoodItem>(
                future: api.getFood(fdcId),
                builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                        return Center(child: Text('Error: ${snap.error}'));
                    }
                    final item = snap.data!;
                    final n = item.nutrients;
                    return LayoutBuilder(
                        builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 600;
                            final table = DataTable(columns: const [
                                DataColumn(label: Text('Nutrient')),
                                DataColumn(label: Text('Amount')),
                            ], rows: [
                                _row('Calories (kcal)', n?.calories),
                                _row('Protein (g)', n?.protein),
                                _row('Carbs (g)', n?.carbs),
                                _row('Fat (g)', n?.fat),
                                _row('Fiber (g)', n?.fiber),
                            ]);
                            return SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(item.description, style: Theme.of(context).textTheme.titleLarge),
                                        if (item.brandOwner != null)
                                            Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: Text(item.brandOwner!),
                                            ),
                                            const SizedBox(height: 16),
                                            isWide ? Center(child: SizedBox(width: 500, child: table)) : table,
                                    ],
                                ),
                            );
                        },
                    );
                },
            ),
        );
    }
    DataRow _row(String name, double? value) {
        final display = value == null ? '-' : value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
        return DataRow(cells: [
            DataCell(Text(name)),
            DataCell(Text(display)),
        ]);
    }
}
