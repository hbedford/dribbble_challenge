import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/ui/screens/shots/shot_controller.dart';
import 'package:flutter/material.dart';

import 'package:dribbble_challenge/domain/entities/shot.dart';

class ShotWidget extends StatelessWidget {
  final Shot shot;
  final Size size;
  ShotWidget({@required this.shot, @required this.size});
  final controller = injection.get<ShotController>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.changeShot(shot);
        Navigator.pushNamed(context, '/shot');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: shot.image == null
                    ? Image.file(shot.file.value)
                    : Image.network(
                        shot.image,
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) =>
                                child,
                        loadingBuilder: (_, child, loadingProgress) => Center(
                          child: loadingProgress == null
                              ? child
                              : CircularProgressIndicator(),
                        ),
                        height: size.height,
                        width: size.width,
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  shot.title,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Row(
                  children: [
                    Icon(Icons.favorite),
                    Text('999'),
                    Icon(Icons.visibility),
                    Text('999')
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
