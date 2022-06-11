import 'package:easy_management/style/colors.dart';
import 'package:easy_management/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:easy_management/database/sqlite.dart';

import '../model/expenses_model.dart';
import '../model/user_model.dart';

class HomeScreen extends StatefulWidget {
  final String data;
  const HomeScreen({Key? key, required this.data}) : super(key: key);

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

  List<bool> _expansionPanelOpen = [];
  Map<String, bool> _periodExpansionOpen = {};
  Map<int, String> _periodExpansionOpenCurrent = {};
  List<ExpansionPanel> _expansionPanels = [];
  List<List<Widget>> _expansionPanelsChild = [];
  Future<List<ExpensesModel>> _expenses = SQLiteHelper.instance.getExpenses(0);

  DateTime _date = DateTime.now();

  TextStyle subheaderTextStyle = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _newLimitTextController = TextEditingController();
    _newExpenseValueController = TextEditingController();
    _databaseHelper.getUserByEmail(widget.data).then((value) {
      if (value.isEmpty) {
        Navigator.of(context).pushNamed('/login');
      } else {
        setState(() {
          currentUser = value.first;
          _expenses = _databaseHelper.getExpenses(currentUser.id);
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
                  controller: _newExpenseValueController,
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
              TextButton(
                  onPressed: () => submitInsertExpense(context),
                  child: const Text("Adicionar"))
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
          setState(() {
            _expenses = SQLiteHelper.instance.getExpenses(currentUser.id);
          });
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
            _expenses = SQLiteHelper.instance.getExpenses(currentUser.id);
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

  Container buildExpenseContainer(expense) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC)))),
        child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  EMUtils.formatarData(expense.date),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  expense.value.toStringAsFixed(2),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: expense.value > currentUser.maxlimit
                          ? colorPallet["Danger"]
                          : colorPallet["Success"]),
                )
              ],
            )));
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
                  child: FutureBuilder<List<ExpensesModel>>(
                    future: _expenses,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ExpensesModel>> snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(
                          child: Text("Carregando..."),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(children: [
                            const Text("Erro ao carregar dados"),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _expenses = SQLiteHelper.instance
                                        .getExpenses(currentUser.id);
                                  });
                                },
                                child: Text(
                                  "Clique para tentar novamente!",
                                  style:
                                      TextStyle(color: colorPallet["Primaria"]),
                                ))
                          ]),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: Text("Carregando..."),
                        );
                      } else if (snapshot.data!.isEmpty) {
                        const Center(
                          child: Text("Sem gastos"),
                        );
                      }

                      _expansionPanels.clear();
                      _expansionPanelOpen.clear();
                      _expansionPanelsChild.clear();
                      List<String> periodos = [];
                      for (var i = 0; i < snapshot.data!.length; i++) {
                        var expense = snapshot.data![i];
                        if (!periodos.contains(expense.period)) {
                          periodos.add(expense.period);
                          if (!_periodExpansionOpen.keys
                              .contains(expense.period)) {
                            _periodExpansionOpen[expense.period] = false;
                          }
                          _expansionPanelOpen.add(
                              _periodExpansionOpen[expense.period] ?? false);
                          _periodExpansionOpenCurrent[
                              _expansionPanelOpen.length - 1] = expense.period;
                          _expansionPanelsChild.add([]);
                          _expansionPanels.add(
                            ExpansionPanel(
                                canTapOnHeader: true,
                                headerBuilder: (context, isOpen) {
                                  return Container(
                                      child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 8, 8, 8),
                                          child: Text(
                                            expense.period,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          )));
                                },
                                body: Column(children: [
                                  ListView(
                                    shrinkWrap: true,
                                    children: _expansionPanelsChild[
                                        _expansionPanelsChild.length - 1],
                                  )
                                ]),
                                isExpanded: _expansionPanelOpen[
                                    _expansionPanelOpen.length - 1]),
                          );
                        }

                        _expansionPanelsChild.last
                            .add(buildExpenseContainer(expense));
                      }

                      return ExpansionPanelList(
                        children: _expansionPanels,
                        expansionCallback: (i, isOpen) => setState(() {
                          _expansionPanelOpen[i] = !isOpen;
                          _periodExpansionOpen[
                              _periodExpansionOpenCurrent[i] ?? ""] = !isOpen;
                        }),
                      );
                    },
                  ))
            ])),
        floatingActionButton: buildSpeedDial());
  }
}
