import 'dart:io';
import 'dart:convert';

void main() async {
  var server = await HttpServer.bind('localhost', 8083);
  var buildPath = 'build/web';
  
  print('Server running on http://localhost:8083');
  
  await for (var request in server) {
    var path = request.uri.path;
    
    // Remove leading slash
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    
    // Default to index.html for root path
    if (path.isEmpty) {
      path = 'index.html';
    }
    
    var file = File('$buildPath/$path');
    
    // Check if file exists
    if (await file.exists()) {
      // Determine content type based on file extension
      var contentType = _getContentType(path);
      request.response.headers.contentType = contentType;
      await file.openRead().pipe(request.response);
    } else {
      // Try index.html for directory paths
      var indexFile = File('$buildPath/index.html');
      if (await indexFile.exists()) {
        request.response.headers.contentType = ContentType.html;
        await indexFile.openRead().pipe(request.response);
      } else {
        request.response.statusCode = HttpStatus.notFound;
        request.response.write('File not found: $path');
        await request.response.close();
      }
    }
  }
}

ContentType _getContentType(String path) {
  if (path.endsWith('.html')) {
    return ContentType.html;
  } else if (path.endsWith('.css')) {
    return ContentType('text', 'css');
  } else if (path.endsWith('.js')) {
    return ContentType('application', 'javascript');
  } else if (path.endsWith('.png')) {
    return ContentType('image', 'png');
  } else if (path.endsWith('.jpg') || path.endsWith('.jpeg')) {
    return ContentType('image', 'jpeg');
  } else if (path.endsWith('.ico')) {
    return ContentType('image', 'x-icon');
  } else {
    return ContentType.binary;
  }
}