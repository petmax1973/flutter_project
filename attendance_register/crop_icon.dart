import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/icon/icon.png');
  final image = img.decodeImage(file.readAsBytesSync())!;
  
  int left = image.width;
  int top = image.height;
  int right = 0;
  int bottom = 0;
  
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      if (pixel.r < 245 || pixel.g < 245 || pixel.b < 245) {
        if (x < left) left = x;
        if (y < top) top = y;
        if (x > right) right = x;
        if (y > bottom) bottom = y;
      }
    }
  }
  
  if (right >= left && bottom >= top) {
    // Rimuoviamo completamente il padding per farlo enorme
    int padding = 0; 
    left = (left - padding).clamp(0, image.width);
    top = (top - padding).clamp(0, image.height);
    right = (right + padding).clamp(0, image.width);
    bottom = (bottom + padding).clamp(0, image.height);
    
    final cropped = img.copyCrop(image, x: left, y: top, width: right - left, height: bottom - top);
    
    // Su Android Adaptive gli sfondi trasparenti o bianchi vengono gestiti dalla mask.
    // Salviamolo come png e impostiamolo per l'app.
    File('assets/icon/icon_cropped.png').writeAsBytesSync(img.encodePng(cropped));
    print('Cropped successfully!');
  } else {
    print('Could not crop.');
  }
}
