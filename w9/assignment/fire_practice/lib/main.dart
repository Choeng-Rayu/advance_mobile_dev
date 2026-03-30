import 'dart:async';

void main() {
  final controller = StreamController<int>();

  int counter = 0;

  Timer.periodic(Duration(seconds: 1), (timer) {
    counter++;
    controller.add(counter);

    if (counter == 5) {
      timer.cancel();
      controller.close();
    }
  });

  // Listen to the stream
  controller.stream.listen(
    (newValue) => print("Received $newValue"),
    onDone: () => print("done"),
  );
}




class DownloadService {
  final StreamController<int> _controller = StreamController();
  Stream<int> get stream => _controller.stream;
  void startDownload() async {
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(Duration(microseconds: 3000));
    }
    _controller.close();
  }
}
