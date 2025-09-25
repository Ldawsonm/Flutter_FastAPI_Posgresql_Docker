import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models.dart';
import 'details_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
    const SearchScreen({super.key});
    @override
    ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
    final _controller = TextEditingController();
    final _scrollController = ScrollController();
    @override
    void initState() {
        super.initState();
        _scrollController.addListener(() {
            if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
                ref.read(searchProvider.notifier).loadMore();
            }
        });
    }

    @override
    void dispose() {
        _controller.dispose();
        _scrollController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final state = ref.watch(searchProvider);
        return Scaffold(
            appBar: AppBar(title: const Text('Food Search')),
            body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    children: [
                        Row(children: [
                            Expanded(
                                child: TextField(
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                        labelText: 'Search foods',
                                        border: OutlineInputBorder(),
                                    ),
                                    onSubmitted: (q) => ref.read(searchProvider.notifier).search(q),
                                ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                                onPressed: () => ref.read(searchProvider.notifier).search(_controller.text),
                                child: const Text('Search'),
                            ),
                        ]),
                        const SizedBox(height: 12),
                        if (state.error != null)
                            Text(state.error!, style: const TextStyle(color: Colors.red)),
                        Expanded(
                            child: ListView.separated(
                                controller: _scrollController,
                                itemCount: state.results.length + (state.loading ? 1 : 0),
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                    if (index >= state.results.length) {
                                        return const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Center(child: CircularProgressIndicator()),
                                        );
                                    }
                                    final FoodItem item = state.results[index];
                                    return ListTile(
                                        title: Text(item.description),
                                        subtitle: Text(item.brandOwner ?? item.dataType ?? ''),
                                        trailing: const Icon(Icons.chevron_right),
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => DetailsScreen(fdcId: item.fdcId, title: item.description),
                                            ),
                                        ),
                                    );
                                },
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
