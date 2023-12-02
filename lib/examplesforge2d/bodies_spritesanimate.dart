import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class BodiesSpritesAnimate extends Forge2DGame with TapDetector {
  BodiesSpritesAnimate() : super(gravity: Vector2.zero(), zoom: 10);

  @override
  FutureOr<void> onLoad() {
    world.addAll(createBoundaries(this));

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownInfo info) {
    final position = screenToWorld(info.eventPosition.global);
    world.add(PlayerBody(position, PlayerComponent(position: position)));

    super.onTapDown(info);
  }

  List<Wall> createBoundaries(Forge2DGame game, {double? strokeWidth}) {
    final visibleRect = game.camera.visibleWorldRect;
    final topLeft = visibleRect.topLeft.toVector2();
    final topRight = visibleRect.topRight.toVector2();
    final bottomLeft = visibleRect.bottomLeft.toVector2();
    final bottomRight = visibleRect.bottomRight.toVector2();

    return [
      Wall(topLeft, topRight, strokeWidth: strokeWidth),
      Wall(topRight, bottomRight, strokeWidth: strokeWidth),
      Wall(bottomLeft, bottomRight, strokeWidth: strokeWidth),
      Wall(topLeft, bottomLeft, strokeWidth: strokeWidth),
    ];
  }
}

/*******WALL */

class Wall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;
  final double strokeWidth;

  Wall(this.start, this.end, {double? strokeWidth})
      : strokeWidth = strokeWidth ?? 1;

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);

    final bodyDef = BodyDef(userData: this, position: Vector2.zero());

    paint.strokeWidth = strokeWidth;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/*******PLAYER */

class PlayerBody extends BodyComponent {
  final Vector2 position;
  final Vector2 size;

  PlayerBody(this.position, PositionComponent component)
      : size = component.size {
    renderBody = false;
    add(component);
  }

  @override
  Body createBody() {
    Shape shape = CircleShape()..radius = size.x / 4;

    final velocity = (Vector2.random() - Vector2.random()) * 200;

    BodyDef bodyDef = BodyDef(
      position: position,
      type: BodyType.dynamic,
      linearVelocity: velocity,
      angle: velocity.angleTo(Vector2(1, 0)),
    );

    FixtureDef fixtureDef =
        FixtureDef(shape, friction: .2, density: 1, restitution: 0.8);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class PlayerComponent extends SpriteAnimationComponent {
  PlayerComponent({required position})
      : super(anchor: Anchor.center, size: Vector2.all(10));
  @override
  FutureOr<void> onLoad() async {
    final chopper = await Flame.images.load('chopper.png');

    final sequence = SpriteAnimationData.sequenced(
        amount: 4, stepTime: .15, textureSize: Vector2.all(48));

    animation = SpriteAnimation.fromFrameData(chopper, sequence);

    size = Vector2.all(10);
    anchor = Anchor.center;

    return super.onLoad();
  }
}
