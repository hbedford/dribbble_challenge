import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:dribbble_challenge/ui/screens/shots/shot_controller.dart';

class ShotScreen extends StatelessWidget {
  final controller = GetIt.I.get<ShotController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.shot.value.title),
        centerTitle: true,
      ),
      body: LayoutBuilder(
          builder: (_, constraints) => Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: constraints.maxHeight * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.favorite),
                                  Text('999'),
                                  Icon(Icons.remove_red_eye),
                                  Text('999')
                                ],
                              ),
                              Text('Postado em 01 de janeiro de 2021')
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Shot title',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        Text('Shot description'),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              height: constraints.maxHeight * 0.4,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child:
                                    Image.network(controller.shot.value.image),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Flexible(
                          flex: 1,
                          child: controller.shot.value.attachments.length == 0
                              ? Center(
                                  child: Text('Nenhuma sub-imagem encontrada'))
                              : ListView.builder(
                                  itemCount:
                                      controller.shot.value.attachments.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, int index) =>
                                      Container(
                                          margin: EdgeInsets.only(
                                            left: constraints.maxWidth * 0.05,
                                          ),
                                          width: constraints.maxWidth * 0.3,
                                          height: constraints.maxWidth * 0.05,
                                          child: Card(
                                            color: Colors.white,
                                            child: Center(
                                                child: Image.network(controller
                                                    .shot
                                                    .value
                                                    .othersImages[index])),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          )),
                                )),
                      Expanded(
                        flex: 2,
                        child: Container(),
                      )
                    ],
                  )),
                ],
              )),
    );
  }
}
