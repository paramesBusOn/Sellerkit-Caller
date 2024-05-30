// Define a custom listener interface
typedef CustomListenerCallback = void Function(String data);

class CustomListener {
  // Define a list to hold registered listeners
  final List<CustomListenerCallback> _listeners = [];

  // Method to register a listener
  void addListener(CustomListenerCallback listener) {
    _listeners.add(listener);
  }

  // Method to unregister a listener
  void removeListener(CustomListenerCallback listener) {
    _listeners.remove(listener);
  }

  // Method to notify all registered listeners
  void notifyListeners(String data) {
    for (final listener in _listeners) {
      listener(data);
    }
  }
}

// Usage:
void main() {
  final customListener = CustomListener();

  // Register a listener
  final listener = (String data) {
    print('Listener received data: $data');
  };
  customListener.addListener(listener);

  // Notify listeners
  customListener.notifyListeners('Hello, listeners!');

  // Unregister the listener
  customListener.removeListener(listener);
}
