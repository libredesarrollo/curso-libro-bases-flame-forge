// import 'dart:async';

import 'package:base01/examplesforge2d/bodies_contact.dart';
import 'package:base01/examplesforge2d/bodies_kinematic.dart';
import 'package:base01/examplesforge2d/bodies_sprites.dart';
import 'package:base01/examplesforge2d/bodies_static_dinamic.dart';
import 'package:base01/examplesforge2d/bodies_spritesanimate.dart';
// import 'package:base01/examplesforge2d/forces.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

// import 'package:flame/components.dart';
// import 'package:flame_forge2d/flame_forge2d.dart';

void main() {
  // runApp(GameWidget(game: MyGameForce()));
  // runApp(GameWidget(game: MyGameBodyKinematic()));
  // runApp(GameWidget(game: BodiesSprites()));
  // runApp(GameWidget(game: BodiesSpritesAnimate()));
  runApp(GameWidget(game: BodiesContact()));
  // runApp(GameWidget(game: MyGame()));
}

// class MyGame extends Forge2DGame {
//   @override
//   onLoad() {
//     camera.viewfinder.anchor = Anchor.topLeft;

//     // cameraWorld.add()

//     // addAll([cameraComponent, cameraWorld]);

//     return super.onLoad();
//   }
// }
