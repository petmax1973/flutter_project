import 'dart:async';
import 'dart:html' as html;

Future<List<String>> pickFolderAndReadFiles() async {
  final completer = Completer<List<String>>();
  final html.InputElement input = html.document.createElement('input') as html.InputElement;
  input.type = 'file';
  input.multiple = true;
  // This attribute triggers native folder selection in Chrome/Edge/Firefox
  input.setAttribute('webkitdirectory', 'true');
  input.setAttribute('directory', 'true');
  
  input.onChange.listen((e) async {
    final files = input.files;
    if (files == null || files.isEmpty) {
      completer.complete([]);
      return;
    }
    
    List<String> contents = [];
    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      // Skip obvious non-xml files to save parsing time
      if (!file.name.toLowerCase().endsWith('.xml') && !file.name.toLowerCase().endsWith('.p7m')) continue;
      
      final reader = html.FileReader();
      final fileCompleter = Completer<String>();
      
      reader.onLoadEnd.listen((_) {
        fileCompleter.complete(reader.result as String);
      });
      reader.onError.listen((_) {
        fileCompleter.complete('');
      });
      
      reader.readAsText(file); // Default is utf-8, works for XML
      contents.add(await fileCompleter.future);
    }
    completer.complete(contents);
  });
  


  input.click();
  return completer.future;
}
