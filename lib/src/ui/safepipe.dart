import 'package:angular/core.dart';
import 'package:angular/security.dart';
import 'package:angular/angular.dart';

@Pipe('safehtml')
class SafePipeHtml extends PipeTransform {
  DomSanitizationService _sanitizer;

  SafePipeHtml(this._sanitizer);

  SafeHtml transform(String value) {
    return this._sanitizer.bypassSecurityTrustHtml(value);
  }
}
