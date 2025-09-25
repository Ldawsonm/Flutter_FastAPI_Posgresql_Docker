import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api.dart';
import 'models.dart';
// Configure your backend URL here or via a runtime env mechanism you prefer.
final baseUrlProvider = Provider<String>((ref) => const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:8000',
    ));

final apiProvider = Provider<ApiClient>((ref) => ApiClient(ref.watch(baseUrlProvider)));

class SearchState {
    final String query;
    final int page;
    final bool loading;
    final String? error;
    final List<FoodItem> results;
    final bool hasMore;

    SearchState({
        this.query = '',
        this.page = 1,
        this.loading = false,
        this.error,
        this.results = const [],
        this.hasMore = false,
    });

    SearchState copyWith({
        String? query,
        int? page,
        bool? loading,
        String? error,
        List<FoodItem>? results,
        bool? hasMore,
    }) =>
        SearchState(
            query: query ?? this.query,
            page: page ?? this.page,
            loading: loading ?? this.loading,
            error: error,
            results: results ?? this.results,
            hasMore: hasMore ?? this.hasMore,
        );
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref)
{
return SearchNotifier(ref);
});

class SearchNotifier extends StateNotifier<SearchState> {
    final Ref ref;
    SearchNotifier(this.ref) : super(SearchState());
    Future<void> search(String query) async {
        state = state.copyWith(loading: true, error: null, query: query, page: 1, results: []);
        try {
            final api = ref.read(apiProvider);
            final resp = await api.searchFoods(query, page: 1, pageSize: 20);
            state = state.copyWith(
                loading: false,
                results: resp.items,
                page: resp.page,
                hasMore: resp.page < resp.totalPages,
            );
        } catch (e) {
            state = state.copyWith(loading: false, error: e.toString());
        }
    }
    Future<void> loadMore() async {
        if (!state.hasMore || state.loading) return;
            state = state.copyWith(loading: true, error: null);
        try {
            final nextPage = state.page + 1;
            final api = ref.read(apiProvider);
            final resp = await api.searchFoods(state.query, page: nextPage, pageSize: 20);
            state = state.copyWith(
                loading: false,
                results: [...state.results, ...resp.items],
                page: resp.page,
                hasMore: resp.page < resp.totalPages,
            );
        } catch (e) {
            state = state.copyWith(loading: false, error: e.toString());
        }
    }
}
