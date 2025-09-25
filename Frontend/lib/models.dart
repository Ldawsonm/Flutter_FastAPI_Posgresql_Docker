class Nutrients {
    final double? calories;
    final double? protein;
    final double? carbs;
    final double? fat;
    final double? fiber;

    Nutrients({this.calories, this.protein, this.carbs, this.fat, this.fiber});

    factory Nutrients.fromJson(Map<String, dynamic> json) => Nutrients(
            calories: (json['calories'] as num?)?.toDouble(),
            protein: (json['protein'] as num?)?.toDouble(),
            carbs: (json['carbs'] as num?)?.toDouble(),
            fat: (json['fat'] as num?)?.toDouble(),
            fiber: (json['fiber'] as num?)?.toDouble(),
        );
}

class FoodItem {
    final int fdcId;
    final String description;
    final String? brandOwner;
    final String? dataType;
    final Nutrients? nutrients;

    FoodItem({
        required this.fdcId,
        required this.description,
        this.brandOwner,
        this.dataType,
        this.nutrients,
    });

    factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
            fdcId: json['fdcId'] as int,
            description: json['description'] as String? ?? '',
            brandOwner: json['brandOwner'] as String?,
            dataType: json['dataType'] as String?,
            nutrients:
                json['nutrients'] != null ? Nutrients.fromJson(json['nutrients']) : null,
        );

}

class SearchResponse {
    final List<FoodItem> items;
    final int page;
    final int pageSize;
    final int totalHits;
    final int totalPages;

    SearchResponse({
        required this.items,
        required this.page,
        required this.pageSize,
        required this.totalHits,
        required this.totalPages,
    });

    factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
            items: (json['items'] as List<dynamic>)
                .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
                .toList(),
            page: json['page'] as int,
            pageSize: json['page_size'] as int,
            totalHits: json['total_hits'] as int,
            totalPages: json['total_pages'] as int,
        );
}
