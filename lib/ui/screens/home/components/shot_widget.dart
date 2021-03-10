import 'package:flutter/material.dart';

import 'package:dribbble_challenge/domain/entities/shot.dart';

class ShotWidget extends StatelessWidget {
  final Shot shot;
  final Size size;
  ShotWidget({@required this.shot, @required this.size});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  shot.image,
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
