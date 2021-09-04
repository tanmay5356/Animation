import 'dart:math';

import 'package:animation17/widgets/cat.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catCantroller;
  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    boxController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.65).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.easeInOut,
      ),
    );
    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
    boxController.forward();

    catCantroller = AnimationController(
      duration: Duration(microseconds: 300),
      vsync: this,
    );
    catAnimation = Tween(begin: 10.0, end: -125.0)
        .animate(CurvedAnimation(parent: catCantroller, curve: Curves.easeIn));
  }

  onTap() {
    boxController.stop();
    if (catCantroller.status == AnimationStatus.completed) {
      boxController.forward();
      catCantroller.reverse();
    } else if (catCantroller.status == AnimationStatus.dismissed) {
      boxController.stop();
      catCantroller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animation"),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 270.0,
      width: 270.0,
      color: Colors.blueGrey,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10.0,
          width: 130.0,
          color: Colors.blueGrey[500],
        ),
        builder: (context, child) {
          return Transform.rotate(
              child: child,
              alignment: Alignment.topLeft,
              angle: boxAnimation.value);
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10.0,
          width: 130.0,
          color: Colors.blueGrey[500],
        ),
        builder: (context, child) {
          return Transform.rotate(
              child: child,
              alignment: Alignment.topRight,
              angle: -boxAnimation.value);
        },
      ),
    );
  }
}
