abstract class ITtsService {
  Future<void> speak(String text, String language);
  Future<void> stop();
}