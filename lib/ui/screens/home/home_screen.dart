import 'package:dribbble_challenge/infra/injections.dart';
import 'package:flutter/material.dart';

import 'components/shot_widget.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = injection.get<HomeController>();
  @override
  void initState() {
    super.initState();

    controller.loadShots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Simple Dribbble',
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadShots,
        child: LayoutBuilder(
          builder: (_, constraints) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder(
              valueListenable: controller.list,
              builder: (_, value, child) => value != null
                  ? value.isEmpty
                      ? Center(
                          child: Text(
                            'Lista vazia',
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      : ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, int index) => ShotWidget(
                            shot: value[index],
                            size: Size(constraints.maxWidth,
                                constraints.maxHeight * 0.4),
                          ),
                        )
                  : Center(
                      child: Text(
                        'Ops ocorreu algo de errado',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        child: Icon(Icons.add),
      ),
    );
  }
}
