abstract class ITtsService {
  Future<void> initialize();
  Future<void> speak(String text, String language);
  Future<void> stop();
}