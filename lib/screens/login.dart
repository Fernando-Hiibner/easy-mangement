import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:easy_management/style/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool passwordVisibility = false;

  String? textValidator(String? value) {
    return value == null || value.isEmpty
        ? "Esse campo não pode estar vazio."
        : null;
  }

  String validateForm() {
    /**
     * EU - > Erro Usuário
     * EP - > Erro Senha
     * S  - > Sucesso
     */
    final _userText = _userController.value.text;
    final _passwordText = _passwordController.value.text;
    if (_userText.isEmpty || _userText == null) {
      return "EU";
    } else if (_passwordText.isEmpty || _passwordText == null) {
      return "EP";
    }
    return "S";
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
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
                        validator: (value) => textValidator(value),
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
                        validator: (value) => textValidator(value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: !passwordVisibility,
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
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        String validacao = validateForm();
                        if (validacao == "S") {
                          Navigator.of(context).pushNamed('/home');
                        } else if (validacao == "EU") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Usuário Inválido!'),
                              backgroundColor: Color(0xFFD01F1F),
                            ),
                          );
                        } else if (validacao == "EP") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Senha Inválida!'),
                              backgroundColor: Color(0xFFD01F1F),
                            ),
                          );
                        }
                      },
                      child: const Text("Entrar"),
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
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LimitedBox(
                    maxWidth: 364,
                    child: Text.rich(
                      TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "Esqueceu sua senha?",
                            style: TextStyle(
                              color: colorPallet["Primaria-1"],
                              fontFamily: "Montserrat",
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context)
                                  .pushNamed("/forgotPassword")),
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ou',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorPallet["Dark"])),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                    child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/createAccount');
                          },
                          child: const Text("Criar nova Conta"),
                          style: ElevatedButton.styleFrom(
                            primary: colorPallet["Secundaria"],
                            textStyle: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorPallet["Light-1"]),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        )),
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
