import 'package:dribbble_challenge/infra/injections.dart';
import 'package:dribbble_challenge/ui/screens/shots/shot_controller.dart';
import 'package:flutter/material.dart';
import 'components/textfield_widget.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:dribbble_challenge/domain/entities/shot.dart';

class NewShotScreen extends StatelessWidget {
  final controller = injection.get<ShotController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Novo Shot'),
      ),
      body: LayoutBuilder(
        builder: (_, constraints) => Padding(
          padding: EdgeInsets.only(
              top: constraints.maxHeight * 0.05,
              left: constraints.maxWidth * 0.05,
              right: constraints.maxWidth * 0.05),
          child: ListView(
            children: [
              Container(
                  height: constraints.maxHeight * 0.25,
                  child: ValueListenableBuilder(
                    valueListenable: controller.shot.value.file,
                    builder: (_, value, child) => InkWell(
                      onTap: () => controller.getImage(),
                      child: value == null
                          ? DottedBorder(
                              dashPattern: [8, 4],
                              borderType: BorderType.RRect,
                              radius: Radius.circular(30),
                              padding: EdgeInsets.all(6),
                              child: Center(
                                child: Text('Adicionar Imagem'),
                              ))
                          : Image.file(value),
                    ),
                  )),
              Container(
                  height: constraints.maxHeight * 0.15,
                  margin: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.02),
                  child: LayoutBuilder(
                    builder: (_, constraint) => Container(
                      margin: EdgeInsets.only(top: constraint.maxHeight * 0.1),
                      child: ListView.builder(
                          itemCount: 2,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, int index) => OtherShotWidget(
                                size: Size(constraint.maxWidth * 0.2,
                                    constraint.maxHeight * 0.9),
                              )),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Titulo'),
                            ValueListenableBuilder(
                              valueListenable: controller.shot.value.textError,
                              builder: (_, value, child) => TextFieldWidget(
                                controller: controller.shot.value.titleEdit,
                                textError: value,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Descrição'),
                          TextFieldWidget(
                            controller: controller.shot.value.descriptionEdit,
                          )
                        ],
                      )
                    ],
                  )),
              Container(
                  height: constraints.maxHeight * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => controller.sendShot(context),
                        child: Text('Publicar'.toUpperCase()),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class OtherShotWidget extends StatelessWidget {
  final Shot shot;
  final Size size;
  OtherShotWidget({this.shot, @required this.size});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        dashPattern: [8, 4],
        borderType: BorderType.RRect,
        radius: Radius.circular(10),
        padding: EdgeInsets.all(6),
        child: Container(
          height: size.height,
          width: size.width,
          child: Icon(Icons.image),
        ),
      ),
    );
  }
}
