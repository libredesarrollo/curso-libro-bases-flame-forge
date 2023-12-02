import 'dart:async';
import 'dart:math';

import 'package:base01/utils/create_animation_by_limit.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class CustomContactFilter implements ContactFilter {
  @override
  bool shouldCollide(Fixture fixtureA, Fixture fixtureB) {
    if (fixtureA.body.userData is BoxBody &&
        fixtureB.body.userData is BoxBody) {
      return false;
    }
    if (fixtureA.body.userData is BallBody &&
        fixtureB.body.userData is BallBody) {
      return false;
    }
    return true;
  }
}

class BodiesContact extends Forge2DGame with TapDetector {
  BodiesContact() : super(gravity: Vector2(0, 30), zoom: 5);

  @override
  FutureOr<void> onLoad() {
    camera.viewfinder.anchor = Anchor.topLeft;

    final gameSize = screenToWorld(camera.viewport.size);
    world.add(Ground(gameSize));

    // world.physicsWorld.setContactFilter(CustomContactFilter());

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (Random.secure().nextBool()) {
      world.add(BoxBody(screenToWorld(info.eventPosition.global)));
    } else {
      world.add(BallBody(screenToWorld(info.eventPosition.global)));
    }

    super.onTapDown(info);
  }
}

//*** box */
class BoxBody extends _Base {
  BoxBody(super.position);

  @override
  Body createBody() {
    Shape shape = PolygonShape()..setAsBoxXY(5, 5);

    BodyDef bodyDef =
        BodyDef(position: position, type: BodyType.dynamic, userData: this);

    FixtureDef fixtureDef =
        FixtureDef(shape, friction: 1, density: 1, restitution: 0);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
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
class BallBody extends _Base {
  BallBody(super.position);
  @override
  Body createBody() {
    Shape shape = CircleShape()..radius = 5;

    BodyDef bodyDef =
        BodyDef(position: position, type: BodyType.dynamic, userData: this);

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

//*** base */

class _Base extends BodyComponent with ContactCallbacks {
  final Vector2 position;
  _Base(this.position);

  late final SpriteAnimation explotionAnimation;

  @override
  Body createBody() {
    throw UnimplementedError();
  }

  @override
  Future<void> onLoad() async {
    final spriteImage = await Flame.images.load('explotion.png');
    final spriteSheet =
        SpriteSheet(image: spriteImage, srcSize: Vector2(306, 295));

    explotionAnimation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 6, sizeX: 3, stepTime: .03, loop: false);

    return super.onLoad();
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (this is BoxBody && other is BoxBody) {
      return;
    }
    if (this is BallBody && other is BallBody) {
      return;
    }

    if (other is BallBody || other is BoxBody) {
      world.add(SpriteAnimationComponent(
          position: body.position,
          animation: explotionAnimation.clone(),
          anchor: Anchor.center,
          size: Vector2.all(50),
          removeOnFinish: true));
      removeFromParent();
    }

    super.beginContact(other, contact);
  }

  // @override
  // void endContact(Object other, Contact contact) {
  //   print("endContact");
  //   super.endContact(other, contact);
  // }
}

//*** base */

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
