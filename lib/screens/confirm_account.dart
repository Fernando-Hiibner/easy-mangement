import 'package:flutter/material.dart';

import 'package:easy_management/style/colors.dart';

class ConfirmAccountScreen extends StatefulWidget {
  const ConfirmAccountScreen({Key? key}) : super(key: key);

  @override
  _ConfirmAccountScreenState createState() => _ConfirmAccountScreenState();
}

class _ConfirmAccountScreenState extends State<ConfirmAccountScreen> {
  final TextEditingController _verificationCodeControlelr =
      TextEditingController();

  @override
  void dispose() {
    _verificationCodeControlelr.dispose();
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
                children: [
                  LimitedBox(
                    maxWidth: 364,
                    child: Text.rich(
                      TextSpan(children: <TextSpan>[
                        TextSpan(
                            text:
                                "Por favor verificar o código de verificação de 6 dígitos que foi enviado para o email ",
                            style: TextStyle(
                              color: colorPallet["Dark+2"],
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            )),
                        TextSpan(
                            text: "user@user.com",
                            style: TextStyle(
                              color: colorPallet["Dark+2"],
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              decoration: TextDecoration.underline,
                            ))
                      ]),
                      textAlign: TextAlign.center,
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
                        controller: _verificationCodeControlelr,
                        //  onChanged: (_) => EasyDebounce.debounce('_userController',
                        //     Duration(milliseconds: 2000), () {}),
                        obscureText: false,
                        decoration: InputDecoration(
                            labelText: "Código de Verificação",
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
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/home');
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
