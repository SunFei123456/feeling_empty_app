class BottleEvent {
  final int bottleId;
  final bool? isResonated;
  final int? resonates;
  final bool? isFavorited;
  final int? favorites;

  BottleEvent({
    required this.bottleId,
    this.isResonated,
    this.resonates,
    this.isFavorited,
    this.favorites,
  });
} 