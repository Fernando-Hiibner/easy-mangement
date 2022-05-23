import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:easy_management/style/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _verificationCodeControlelr =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;

  @override
  void dispose() {
    _verificationCodeControlelr.dispose();
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
                  LimitedBox(
                    maxWidth: 364,
                    child: Text(
                        'Um email foi enviado para us**@****.*** com o código de verificação',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        )),
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
                  LimitedBox(
                    maxWidth: 364,
                    child: Text.rich(
                      TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "Re-enviar código",
                            style: TextStyle(
                              color: colorPallet["Primaria-1"],
                              fontFamily: "Montserrat",
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => print("Re-enviar código")),
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                      onPressed: () {
                        Navigator.of(context).pushNamed('/confirmAccount');
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
