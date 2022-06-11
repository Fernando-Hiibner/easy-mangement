import 'package:flutter/material.dart';

import 'package:easy_management/style/colors.dart';
import 'package:easy_management/database/sqlite.dart';
import 'package:easy_management/utils.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;

  final SQLiteHelper _databaseHelper = SQLiteHelper.instance;

  String validateForm() {
    /**
     * EU  - > Erro Usuário
     * EP  - > Erro Senha
     * ECP - > Erro Confirmar Senha
     * EPD - > Erro senhas diferentes
     * S   - > Sucesso
     */
    final _userText = _userController.value.text;
    final _passwordText = _passwordController.value.text;
    final _confirmPasswordText = _confirmPasswordController.value.text;
    if (_userText.isEmpty || _userText == null) {
      return "EU";
    } else if (_passwordText.isEmpty || _passwordText == null) {
      return "EP";
    } else if (_confirmPasswordText.isEmpty || _confirmPasswordText == null) {
      return "ECP";
    } else if (_passwordText != _confirmPasswordText) {
      return "EPD";
    }
    return "S";
  }

  Future<String> insertUser() async {
    try {
      final _userText = _userController.value.text;
      final _passwordText = _passwordController.value.text;

      return await _databaseHelper.insertUser(_userText, _passwordText);
    } on Exception {
      return "E";
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(49, 64, 49, 110),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!(Theme.of(context).brightness == Brightness.dark))
                    Expanded(
                      child: Image.asset(
                        'assets/images/LogoFernando.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  if (Theme.of(context).brightness == Brightness.dark)
                    Expanded(
                      child: Image.asset(
                          'assets/images/LogoFernandoFundoBranco.png',
                          fit: BoxFit.contain),
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Criar nova conta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                      child: TextFormField(
                        controller: _userController,
                        obscureText: false,
                        validator: (value) => EMUtils.textValidator(value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            labelText: "Usuário",
                            enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        colorPallet["Primaria"] ?? Colors.black,
                                    width: 1),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0)))),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !passwordVisibility,
                        validator: (value) => EMUtils.textValidator(value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0))),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      colorPallet["Primaria"] ?? Colors.black,
                                  width: 1),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0))),
                          suffixIcon: InkWell(
                            onTap: () => setState(
                              () => passwordVisibility = !passwordVisibility,
                            ),
                            child: Icon(
                              passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF757575),
                              size: 22,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !confirmPasswordVisibility,
                        validator: (value) => EMUtils.textValidator(value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Confirmar Senha",
                          enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0))),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      colorPallet["Primaria"] ?? Colors.black,
                                  width: 1),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0))),
                          suffixIcon: InkWell(
                            onTap: () => setState(
                              () => confirmPasswordVisibility =
                                  !confirmPasswordVisibility,
                            ),
                            child: Icon(
                              confirmPasswordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF757575),
                              size: 22,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                    child: ElevatedButton(
                      onPressed: () async {
                        String validacao = validateForm();
                        if (validacao == "S") {
                          String insert = await insertUser();
                          if (insert == "S") {
                            Navigator.of(context).pushNamed('/home',
                                arguments: _userController.text);
                          } else if (insert == "UE") {
                            EMUtils.mostrarSnackbar(
                                context,
                                'Usuário já cadastrado no sistema!',
                                colorPallet["Warning"]);
                          } else {
                            EMUtils.mostrarSnackbar(
                                context,
                                'Erro ao cadastrar usuário',
                                colorPallet["Danger"]);
                          }
                        } else if (validacao == "EU") {
                          EMUtils.mostrarSnackbar(context, 'Usuário Inválido!',
                              colorPallet["Danger"]);
                        } else if (validacao == "EP") {
                          EMUtils.mostrarSnackbar(context, 'Senha Inválido!',
                              colorPallet["Danger"]);
                        } else if (validacao == "ECP") {
                          EMUtils.mostrarSnackbar(
                              context,
                              'Confirmar Senha Inválido!',
                              colorPallet["Danger"]);
                        } else if (validacao == "EPD") {
                          EMUtils.mostrarSnackbar(context, 'Senhas diferentes!',
                              colorPallet["Danger"]);
                        }
                      },
                      child: const Text("Enviar"),
                      style: ElevatedButton.styleFrom(
                        primary: colorPallet["Primaria"],
                        textStyle: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorPallet["Light-1"]),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
