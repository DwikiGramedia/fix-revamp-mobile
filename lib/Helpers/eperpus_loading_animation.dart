// Generated, built and configurated privately for Gramedia Asri Media projects
// Any use of this content without permission will be a legal violation
// ============================================================================
// @author Samuel O R Napitupulu
// @email samuel.napitupulu@gramedia.id
// @create date 2022-04-02 04:04:33
// @modify date 2022-04-02 04:04:33
// @desc [description]
// ============================================================================
// Copyrigthed Gramedia Asri Media 2022-04-02 04:04:33

import 'package:flutter/material.dart';

class EPerpusLoadingAnimation extends StatefulWidget {
  const EPerpusLoadingAnimation({Key? key}) : super(key: key);

  @override
  State<EPerpusLoadingAnimation> createState() =>
      _EPerpusLoadingAnimationState();
}

class _EPerpusLoadingAnimationState extends State<EPerpusLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation_rotation;
  late Animation<double> animation_radius_in;
  late Animation<double> animation_radius_out;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class Dot extends StatelessWidget {
  const Dot({Key? key, required this.radius, required this.color})
      : super(key: key);

  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
