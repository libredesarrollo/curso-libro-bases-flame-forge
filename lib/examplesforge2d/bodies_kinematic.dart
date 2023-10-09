import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class MyGameBodyKinematic extends Forge2DGame {
  MyGameBodyKinematic() : super(gravity: Vector2(0, 30), zoom: 5);

  @override
  FutureOr<void> onLoad() {
    camera.viewfinder.anchor = Anchor.topLeft;

    final gameSize = screenToWorld(camera.viewport.size);

    world.add(Player());
    world.add(Ground(gameSize));
    // world.add(BoxKinematic(gameSize));
    world.add(PlatformKinematic(gameSize));

    return super.onLoad();
  }
}

class BoxKinematic extends BodyComponent {
  final Vector2 gameSize;
  BoxKinematic(this.gameSize);

  @override
  Body createBody() {
    final bodyDef = BodyDef(
        position: Vector2(gameSize.x / 2, gameSize.y / 2),
        type: BodyType.kinematic);

    final shape = PolygonShape()..setAsBoxXY(20, 4);

    final fixtureDef = FixtureDef(shape);

    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..angularVelocity = -radians(180);
  }
}

class PlatformKinematic extends BodyComponent {
  final Vector2 gameSize;
  PlatformKinematic(this.gameSize);
  int fact = 20;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
        position: Vector2(gameSize.x / 2, gameSize.y / 2),
        type: BodyType.static);

    final shape = PolygonShape()..setAsBoxXY(20, 4);

    final fixtureDef = FixtureDef(shape);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    if (body.position.x > gameSize.x || body.position.x < 0) fact *= -1;
    // body.position.x += fact * dt;
    body.setTransform(
        Vector2(body.position.x + fact * dt, body.position.y + fact * dt), 0);

    super.update(dt);
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
          Vector2(0, gameSize.y * 0.9), Vector2(gameSize.x, gameSize.y * 0.9));

    BodyDef bodyDef = BodyDef(
        userData: this, position: Vector2.zero(), type: BodyType.static);

    FixtureDef fixtureDef = FixtureDef(shape, friction: 0.3, density: 1);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
