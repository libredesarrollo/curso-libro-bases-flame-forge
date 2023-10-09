import 'dart:async';

// import 'package:flame/camera.dart' as camare;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class MyGameForce extends Forge2DGame with TapDetector {
  final Player _player = Player();

  final _up = Vector2(0, -30);

  MyGameForce() : super(gravity: Vector2(0, 30) /*, zoom: 5*/);

  @override
  FutureOr<void> onLoad() {
    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(_player);
    final gameSize = screenToWorld(camera.viewport.size);
    world.add(Ground(gameSize));

    // print(camera.viewport.size.toString());
    // print(screenToWorld(camera.viewport.size).toString());

    return super.onLoad();
  }

  @override
  void onTap() {
    // _player.body.applyForce(_up * 2000);
    // _player.body.applyLinearImpulse(_up * 20);
    _player.body.linearVelocity = _up * 2;

    super.onTap();
  }
}

class Player extends BodyComponent {
  @override
  Body createBody() {
    //Shape shape = CircleShape()..radius = 3;
    Shape shape = PolygonShape()..setAsBoxXY(3, 3);

    BodyDef bodyDef =
        BodyDef(position: Vector2.all(10), type: BodyType.dynamic);

    FixtureDef fixtureDef =
        FixtureDef(shape, friction: 1, density: 10, restitution: 0);

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
          Vector2(0, gameSize.y * 0.8), Vector2(gameSize.x, gameSize.y * 0.8));

    BodyDef bodyDef = BodyDef(
        userData: this, position: Vector2.zero(), type: BodyType.static);

    FixtureDef fixtureDef = FixtureDef(shape, friction: 0.3, density: 1);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
