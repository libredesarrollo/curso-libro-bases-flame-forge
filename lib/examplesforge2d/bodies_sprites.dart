import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class BodiesSprites extends Forge2DGame {
  BodiesSprites() : super(gravity: Vector2(0, 30), zoom: 5);

  @override
  FutureOr<void> onLoad() {
    camera.viewfinder.anchor = Anchor.topLeft;

    final gameSize = screenToWorld(camera.viewport.size);

    world.add(BoxBody());
    world.add(BallBody());
    world.add(Ground(gameSize));

    return super.onLoad();
  }
}

//*** box */
class BoxBody extends BodyComponent {
  @override
  Body createBody() {
    Shape shape = PolygonShape()..setAsBoxXY(5, 5);

    BodyDef bodyDef =
        BodyDef(position: Vector2.all(10), type: BodyType.dynamic);

    FixtureDef fixtureDef =
        FixtureDef(shape, friction: 1, density: 1, restitution: 0);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    // final sprite = Sprite(game.images.fromCache('box'));
    // final sprite = await Sprite.load('box.png');
    // add(SpriteComponent(
    //     sprite: sprite, size: Vector2(10, 10), anchor: Anchor.center));

    add(BoxComponent());

    return super.onLoad();
  }
}

class BoxComponent extends SpriteComponent {
  BoxComponent() : super(anchor: Anchor.center, size: Vector2.all(10));
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('box.png');

    return super.onLoad();
  }
}
//*** box */

//*** ball */
class BallBody extends BodyComponent {
  @override
  Body createBody() {
    Shape shape = CircleShape()..radius = 5;

    BodyDef bodyDef =
        BodyDef(position: Vector2.all(10), type: BodyType.dynamic);

    FixtureDef fixtureDef =
        FixtureDef(shape, friction: 1, density: 1, restitution: 0);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    add(BallComponent());

    return super.onLoad();
  }
}

class BallComponent extends SpriteComponent {
  BallComponent() : super(anchor: Anchor.center, size: Vector2.all(10));
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('ball.png');

    return super.onLoad();
  }
}
//*** ball */

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
