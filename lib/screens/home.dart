import 'package:easy_management/style/colors.dart';
import 'package:easy_management/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:easy_management/database/sqlite.dart';

import '../model/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _newExpenseValueController;
  late TextEditingController _newLimitTextController;

  final SQLiteHelper _databaseHelper = SQLiteHelper.instance;
  UserModel currentUser = const UserModel(
      id: 1,
      email: "",
      password: "",
      maxlimit: 0.0,
      verificationCode: "",
      verified: true);

  final List<bool> _expansionPanelOpen = [false, false];

  DateTime _date = DateTime.now();

  TextStyle subheaderTextStyle = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _newLimitTextController = TextEditingController();
    _newExpenseValueController = TextEditingController();
    _databaseHelper.getUserByEmail('ferpinoti@gmail.com').then((value) {
      if (value.isEmpty) {
        Navigator.of(context).pushNamed('/login');
      } else {
        setState(() {
          currentUser = value.first;
        });
      }
    });
  }

  @override
  void dispose() {
    _newLimitTextController.dispose();
    _newExpenseValueController.dispose();
    super.dispose();
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: colorPallet["Primaria"],
      overlayColor: const Color(0x00000000),
      overlayOpacity: 0.4,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.edit),
            label: "Editar Limite",
            onTap: () => openUpdateLimitDialog()),
        SpeedDialChild(
            child: const Icon(Icons.add),
            label: "Adicionar Gasto",
            onTap: () => openInsertExpenseDialog())
      ],
    );
  }

  Future openInsertExpenseDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Center(
              child: Text("Adicionar Gasto"),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) => EMUtils.textValidator(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Valor",
                      hintText: "0.00",
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: colorPallet["Primaria"] ?? Colors.black,
                              width: 1),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0)))),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        _date.day.toString() +
                            "/" +
                            _date.month.toString() +
                            "/" +
                            _date.year.toString(),
                      ),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: _date,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2023),
                            ).then((date) {
                              setState(() {
                                _date = date ?? DateTime.now();
                              });
                            });
                          },
                          child: const Icon(Icons.calendar_month)),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () {}, child: const Text("Adicionar"))
            ],
          ));

  void submitInsertExpense(BuildContext context) {
    try {
      double? newExpenseValue =
          double.tryParse(_newExpenseValueController.text);

      if (newExpenseValue == null) {
        Navigator.of(context).pop();
        EMUtils.mostrarSnackbar(
            context, "Valor Inválido!", colorPallet["Danger"]);
        _newExpenseValueController.clear();
        _date = DateTime.now();
        return;
      }

      _databaseHelper
          .insertExpenses(currentUser.email, newExpenseValue, _date)
          .then((value) {
        if (value) {
          // TODO Set State da fonte de dados da lista de Expansion sla o que
          Navigator.of(context).pop();
          EMUtils.mostrarSnackbar(
              context, "Gasto inserido com sucesso!", colorPallet["Success"]);
          _newExpenseValueController.clear();
          _date = DateTime.now();
          return;
        } else {
          Navigator.of(context).pop();
          EMUtils.mostrarSnackbar(
              context, "Erro ao inserir gasto!", colorPallet["Danger"]);
          _newExpenseValueController.clear();
          _date = DateTime.now();
          return;
        }
      });
    } catch (e) {
      Navigator.of(context).pop();
      EMUtils.mostrarSnackbar(
          context, "Erro ao inserir gasto", colorPallet["Danger"]);
      _newExpenseValueController.clear();
      _date = DateTime.now();
      return;
    }
  }

  Future openUpdateLimitDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Editar Limite"),
            content: TextFormField(
              controller: _newLimitTextController,
              keyboardType: TextInputType.number,
              autofocus: true,
              validator: (value) => EMUtils.textValidator(value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (_) => submitUpdateLimit(context),
              decoration: InputDecoration(
                  labelText: "Valor",
                  hintText: currentUser.maxlimit.toStringAsFixed(2),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: colorPallet["Primaria"] ?? Colors.black,
                          width: 1),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0)))),
            ),
            actions: [
              TextButton(
                  onPressed: () => submitUpdateLimit(context),
                  child: const Text("Atualizar"))
            ],
          ));

  void submitUpdateLimit(BuildContext context) {
    try {
      double? newLimit = double.tryParse(_newLimitTextController.text);

      if (newLimit == null) {
        Navigator.of(context).pop();
        EMUtils.mostrarSnackbar(
            context, "Valor Inválido!", colorPallet["Danger"]);
        _newLimitTextController.clear();
        return;
      }

      _databaseHelper.updateMaxlimit(currentUser.email, newLimit).then((value) {
        if (value) {
          setState(() {
            currentUser = UserModel(
                id: currentUser.id,
                email: currentUser.email,
                password: currentUser.password,
                maxlimit: newLimit,
                verificationCode: currentUser.verificationCode,
                verified: currentUser.verified);
          });
          Navigator.of(context).pop();
          EMUtils.mostrarSnackbar(
              context, "Limite alterado com sucesso!", colorPallet["Success"]);
          _newLimitTextController.clear();
          return;
        } else {
          Navigator.of(context).pop();
          EMUtils.mostrarSnackbar(
              context, "Erro ao atualizar o limite", colorPallet["Danger"]);
          _newLimitTextController.clear();
          return;
        }
      });
    } catch (e) {
      Navigator.of(context).pop();
      EMUtils.mostrarSnackbar(
          context, "Erro ao atualizar o limite", colorPallet["Danger"]);
      _newLimitTextController.clear();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Easy Management"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(
                // child: Text("Não existem itens na lista"),
                children: [
              Container(
                  decoration: BoxDecoration(
                    boxShadow: kElevationToShadow[4],
                    color: colorPallet["Primaria-1"],
                  ),
                  child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Text("Limite", style: subheaderTextStyle),
                            ),
                            Center(
                              child: Text(
                                  "R\$" +
                                      currentUser.maxlimit.toStringAsFixed(2),
                                  style: subheaderTextStyle),
                            )
                          ]))),
              Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                  child: ExpansionPanelList(
                    children: [
                      ExpansionPanel(
                          headerBuilder: (context, isOpen) {
                            return const Text("Expansion");
                          },
                          body: const Text("Baozi"),
                          isExpanded: _expansionPanelOpen[0]),
                      ExpansionPanel(
                          headerBuilder: (context, isOpen) {
                            return const Text("Expansion 2");
                          },
                          body: const Text("Teste"),
                          isExpanded: _expansionPanelOpen[1])
                    ],
                    expansionCallback: (i, isOpen) => setState(() {
                      _expansionPanelOpen[i] = !isOpen;
                    }),
                  ))
            ])),
        floatingActionButton: buildSpeedDial());
  }
}
