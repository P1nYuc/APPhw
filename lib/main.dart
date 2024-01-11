import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:login/login_bloc.dart';
// import 'package:google_language_fonts/google_language_fonts.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BlocProvider(
      blocs: [Bloc((i) => LoginBloc())],
      dependencies: [],
      child: MaterialApp(
      home: LoginManagement(),
      )
    );
  }
}

class LoginManagement extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    LoginBloc loginBloc = BlocProvider.getBloc<LoginBloc>();
    return StreamBuilder(
        stream: loginBloc.currentPageStream,
        builder: (context,snap){
          return IndexedStack(
            index: loginBloc.currentPage,
            children: <Widget>[
              MyLoginPage(),
              MainPage(),
            ],
          );
        }
    );
  }
}

class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    LoginBloc loginBloc = BlocProvider.getBloc<LoginBloc>();
    return Scaffold(
      appBar: AppBar(title: Text('主頁'),),
      body: Center(child: TextButton(
          onPressed: (){
            loginBloc.currentPage = 0;
          },
          child: Text('按我回首頁',style: TextStyle(fontSize: 40),)
        ),
      ),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {

  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late LoginBloc _loginBloc;
  bool _isObscure = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loginBloc=BlocProvider.getBloc<LoginBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.grey, Colors.grey[900]!],
          )
        ),
        child: Center( child:
        Form (
          key: _formKey,
          child:ListView(
            children: <Widget>[
            _buildtitle(),
            Container(
              margin: EdgeInsets.only(top: 20,left: 50,right: 50),
              child: TextFormField(
                validator: (String? value) {
                  if (value == null || !isWordAndDigit(value)) {
                    return '請輸入文字或數字';
                  }
                  return null;
                },
                controller: _accountController,
                style: TextStyle(fontSize: 40,color: Colors.white60),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white30,
                  border: InputBorder.none,
                  hintText: 'account',
                  hintStyle: TextStyle(color: Colors.white60)
                ),
                onChanged: (value){print('onChanged: $value');},
                // onSubmitted: (value){print('onSubmitted: $value');},
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 20,left: 50,right: 50),
              child: TextFormField(

                validator: (String? value) {
                  if (value==null || value.length<6) {
                    return '密碼要超過六個字';
                  }
                  return null;
                },
                controller: _passwordController,
                style: TextStyle(fontSize: 40,color: Colors.white60),
                obscureText: _isObscure,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white30,
                    border: InputBorder.none,
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white60),
                    suffixIcon: IconButton(
                        icon: Icon(
                            _isObscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        })),


                // onChanged: (value){print('onChanged: $value');},
                // onSubmitted: (value){print('onSubmitted: $value');},
              ),
            ),

            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(top: 30,left: 50),
              child: GestureDetector(
                onTap: (){
                  print('送出');
                  // print('account: ${_accountController.text}\n');
                  // print('password: ${_passwordController.text}\n');
                  if(_formKey.currentState?.validate()==true){
                    _loginBloc.currentPage = 1;
                  };
                },
                child: Text('送出',style: TextStyle(fontSize: 50,color: Colors.white),),
              ),
            )
            ],
          ),
        ),
        ),
      ),
    );
  }
  bool isWordAndDigit(String value){
    return RegExp(
      r"[ZA-ZZa-z0-9_]+$").hasMatch(value);
  }

  Widget _buildtitle(){
    return Container(
        margin: EdgeInsets.only(top: 150),
        child:
        Center( child:Text(
          '登入',
          style: TextStyle(fontSize: 80,color: Colors.white),

        ))
    );
  }
}
