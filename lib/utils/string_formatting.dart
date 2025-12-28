String formatExerciseName(String id) {
  if (id.isEmpty) return id;
  
  // Replace underscores with spaces
  final spaced = id.replaceAll('_', ' ');
  
  // Capitalize first letter of each word
  return spaced.split(' ').map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}
