import 'package:easy_management/style/colors.dart';
import 'package:easy_management/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<bool> _expansionPanelOpen = [false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Easy Management"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Center(
              // child: Text("Não existem itens na lista"),
              child: ExpansionPanelList(
        children: [
          ExpansionPanel(
              headerBuilder: (context, isOpen) {
                return Text("Expansion");
              },
              body: Text("Baozi"),
              isExpanded: _expansionPanelOpen[0]),
          ExpansionPanel(
              headerBuilder: (context, isOpen) {
                return Text("Expansion 2");
              },
              body: Text("Teste"),
              isExpanded: _expansionPanelOpen[1])
        ],
        expansionCallback: (i, isOpen) => setState(() {
          _expansionPanelOpen[i] = !isOpen;
        }),
      ))),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.edit),
              label: "Editar Limite",
              onTap: () => EMUtils.mostrarSnackbar(
                  context, "Editar Limite", colorPallet["Success"])),
          SpeedDialChild(
              child: Icon(Icons.add),
              label: "Adicionar Gasto",
              onTap: () => EMUtils.mostrarSnackbar(
                  context, "Adicionar Gasto", colorPallet["Success"]))
        ],
      ),
    );
  }
}
