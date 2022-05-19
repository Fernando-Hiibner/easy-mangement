import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:easy_management/style/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  bool passwordVisibility = false;

  @override
  void initState() {
    super.initState();
    _userController.addListener(() {
      final String text = _userController.text.toLowerCase();
      _userController.value = _userController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _passwordController.addListener(() {
      final String text = _passwordController.text.toLowerCase();
      _passwordController.value = _passwordController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? colorPallet["Dark+2"]
          : colorPallet["Light-1"],
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
                    padding: EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                    child: TextFormField(
                      controller: _userController,
                      onChanged: (_) => EasyDebounce.debounce('_userController',
                          Duration(milliseconds: 2000), () {}),
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                          labelText: "Usuário",
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                              borderRadius: const BorderRadius.only(
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
                    padding: EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                    child: TextFormField(
                      controller: _passwordController,
                      onChanged: (_) => EasyDebounce.debounce(
                          '_passwordController',
                          Duration(milliseconds: 2000),
                          () {}),
                      autofocus: true,
                      obscureText: !passwordVisibility,
                      decoration: InputDecoration(
                        labelText: "Senha",
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: colorPallet["Primaria"] ?? Colors.black,
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
                            color: Color(0xFF757575),
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
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      print("Apertou botão entrar...");
                    },
                    child: Text("Entrar"),
                    style: ElevatedButton.styleFrom(
                      primary: colorPallet["Primaria"],
                      textStyle: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorPallet["Light-1"]),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(0),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(32, 0, 32, 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Esqueceu sua Senha?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorPallet["Primaria-1"])),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(32, 0, 32, 16),
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
                          print("Apertou botão criar nova conta...");
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
    );
  }
}
