import 'dart:async';
import 'package:angular/security.dart';

import 'package:angular/angular.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';

import 'package:angular_components/angular_components.dart';

import 'package:angular_forms/angular_forms.dart';

import 'package:dartboxes/src/boxes/box.dart';
import 'package:dartboxes/src/boxes/settings.dart';

import 'safepipe.dart';

import 'boxsettings.dart';

@Component(
  selector: 'box',
  styleUrls: ['box_component.css'],
  templateUrl: 'box_component.html',
  directives: [
    MaterialCheckboxComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
    formDirectives,
    materialNumberInputDirectives,
  ],
  pipes: [SafePipeHtml],
)
class BoxComponent implements OnInit {
  Settings settings = new Settings();
  BoxSettings model = new BoxSettings();

  DomSanitizationService sanitize;

  SafeHtml boxsvg;

  BoxComponent(this.sanitize);

  @override
  Future<Null> ngOnInit() async {
    renderBox();
  }

  void renderBox() {
    SideType top = SideType.Fingers;
    switch (model.topSide) {
      case TopSide.Open:
        top = SideType.Open;
        break;
      case TopSide.Closed:
        break;
      case TopSide.Lid:
        top = SideType.Lid;
        break;
    }
    settings.burnCorrection = model.burnCorrection;
    settings.boardWidth = model.boardThickness;
    Box box = new Box(settings, model.x, model.y, model.z, [
      top,
      model.sidesExist[0] ? SideType.Fingers : SideType.Open,
      model.sidesExist[1] ? SideType.Fingers : SideType.Open,
      model.sidesExist[2] ? SideType.Fingers : SideType.Open,
      model.sidesExist[3] ? SideType.Fingers : SideType.Open,
      model.sidesExist[4] ? SideType.Fingers : SideType.Open,
    ]);
    boxsvg = sanitize.bypassSecurityTrustHtml(box.toSvg().toString());
  }

  void onSubmit() {
    print('Running onSubmit ${model}');
    renderBox();
  }
}
