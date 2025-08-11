class QuranPartModel {
  final int id;
  final String arabicName;
  final int progress;
  final String status;
  final int stars;
  final bool isLocked;
  final String lastReviewDate;
  final int totalAyahs;
  final int memorizedAyahs;

  QuranPartModel({
    required this.id,
    required this.arabicName,
    required this.progress,
    required this.status,
    required this.stars,
    required this.isLocked,
    required this.lastReviewDate,
    required this.totalAyahs,
    required this.memorizedAyahs,
  });
}
