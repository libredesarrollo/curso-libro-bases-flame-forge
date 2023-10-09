import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class MyGameBodyStaticDinamic extends Forge2DGame {
  MyGameBodyStaticDinamic() : super(gravity: Vector2(0, 30), zoom: 5);

  @override
  FutureOr<void> onLoad() {
    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(Player());
    final gameSize = screenToWorld(camera.viewport.size);
    world.add(Ground(gameSize));

    // print(camera.viewport.size.toString());
    // print(screenToWorld(camera.viewport.size).toString());

    return super.onLoad();
  }
}

class Player extends BodyComponent {
  @override
  Body createBody() {
    // Shape shape = CircleShape()..radius = 3;
    Shape shape = PolygonShape()..setAsBoxXY(3, 3);

    BodyDef bodyDef =
        BodyDef(position: Vector2.all(10), type: BodyType.dynamic);

    FixtureDef fixtureDef =
        FixtureDef(shape, friction: 1, density: 1, restitution: 0);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Ground extends BodyComponent {
  final Vector2 gameSize;
  Ground(this.gameSize);

  @override
  Body createBody() {
    final shape = EdgeShape()
      ..set(
          Vector2(0, gameSize.y * 0.4), Vector2(gameSize.x, gameSize.y * 0.8));

    BodyDef bodyDef = BodyDef(
        userData: this, position: Vector2.zero(), type: BodyType.static);

    FixtureDef fixtureDef = FixtureDef(shape, friction: 0.3, density: 1);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
