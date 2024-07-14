import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final TextEditingController emailText = TextEditingController();
final TextEditingController passwordText = TextEditingController();
final TextEditingController check_passwordText = TextEditingController();
final TextEditingController usernameText = TextEditingController();


class SignUp extends StatefulWidget{
  const SignUp({super.key});
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp>{
  String _CheckInputText = '';

  Future<void> MovePage(context) async {

    final auth = FirebaseAuth.instance;

    if(emailText.text.isEmpty){
      setState(() {
        _CheckInputText = '이메일을 입력 해 주세요.';
      });
    } else if(usernameText.text.isEmpty){
      setState(() {
        _CheckInputText = '사용자 이름을 입력 해 주세요.';
      });
    } else if(passwordText.text.isEmpty){
      setState(() {
        _CheckInputText = '비밀번호를 입력 해 주세요.';
      });
    } else if(check_passwordText.text != passwordText.text){
      print('passowrd matched!');
      _CheckInputText = '비밀번호가 맞지 않습니다.';
    } else {
      final RegExp regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if(!regExp.hasMatch(emailText.text)){
        setState(() {
          _CheckInputText = 'NOT EMAIL!';
        });
      } else {
        setState(() {
          _CheckInputText = '';
        });
      }
      await Firebase.initializeApp();
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailText.text, password: passwordText.text);
        String userid = userCredential.user!.uid;
        final db = FirebaseFirestore.instance;
        DateTime now = DateTime.now();
        int timeStamp = now.millisecondsSinceEpoch;
        print(timeStamp);

        await db.collection('users').doc(emailText.text).set({
          'email' : emailText.text,
          'UID' : userid,
          'username' : usernameText.text,
          'user_profile' : '',
          'userStatus' : true,
          'administrator' : false,
          'creatingTime' :timeStamp
        });
      } catch (e){
        print(e);
      }
    }
  }

  // Navigator.of(context).push(
  //               MaterialPageRoute(
  //                 builder: (context) => Login(),
  //               ),
  //             );

  @override
  Widget build(BuildContext context) {
    print('Login!');
    var screenSize = MediaQuery.of(context).size.width;
    double screenWidth = screenSize > 600 ? 20.0:40.0;

    return MaterialApp(
      home: Scaffold(
        body: Center( //가운데 정렬
            child: Container( //기본 레이아웃 지정
              width: 400,//가로길이 400으로 지정
              padding: EdgeInsets.all(screenWidth),
              child: Column( //레이아웃 세로로 지정
                mainAxisAlignment: MainAxisAlignment.center, //이자식을 가운데 정렬
                children: [ //자식 생성
                  // Container( //일반 레이아웃 지정
                  //   margin: const EdgeInsets.only(bottom: 50), //일반 레이아웃 하단 여백 100지정
                  //   child: Image.asset( //이미지 추가
                  //     'assets/venoblack.png', //이미지 추가 (로고)
                  //     width: 130, //이미지 가로 150지정
                  //     height: 130, //이미지 세로 150지정
                  //   ),
                  // ),
                  TextFormField(
                    controller: emailText,//텍스트 인풋 위젯 추가
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration( //텍스트 인풋 위쳇 디자인 시작
                      border: OutlineInputBorder( //텍스트 인풋 위젯 바깥 테두리 설정
                          borderRadius: BorderRadius.circular(0.0), //택스트 인풋 라운드 0.0(없음)지정
                          borderSide: const BorderSide( //덱스트 인풋 위젯 내부 테두리 설정
                              width: 200, //가로 200지정
                              color: Colors.grey //색상 회색 지정
                          )
                      ),
                      focusedBorder: OutlineInputBorder( //텍스트 인풋 위젯 클릭 시 바깥 테두리 설정
                          borderRadius: BorderRadius.circular(0.0), //텍스트 인풋 위젯 클릭 시 라운드 0.0(없음)지정
                          borderSide: const BorderSide( //텍스트 인풋 위젯 클릭 시 내부 테두리 설정
                              width: 0, //가로 0지정
                              color: Colors.grey //색상 회색 지정
                          )
                      ),
                      hintText: '이메일', //힌트 '아이디'지정
                      // suffixIcon: const Icon(Icons.cancel) //오른쪽 아이콘 설정
                    ),
                  ),
                  TextFormField(
                    controller: usernameText,
                    decoration: InputDecoration(
                        hintText: '이름',
                        // suffixIcon: const Icon(Icons.remove_red_eye),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(
                                width: 200,
                                color: Colors.grey
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(
                                width: 0,
                                color: Colors.grey
                            )
                        )
                    ),
                  ),
                  TextFormField(
                    controller: passwordText,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: '비밀번호',
                        // suffixIcon: const Icon(Icons.remove_red_eye),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(
                                width: 200,
                                color: Colors.grey
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(
                                width: 0,
                                color: Colors.grey
                            )
                        )
                    ),
                  ),
                  TextFormField(
                    controller: check_passwordText,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: '비밀번호 확인',
                        // suffixIcon: const Icon(Icons.remove_red_eye),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(
                                width: 200,
                                color: Colors.grey
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(
                                width: 0,
                                color: Colors.grey
                            )
                        )
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                        _CheckInputText,
                        style: const TextStyle(
                          color: Colors.red,
                        )
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 10000,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            textStyle: const TextStyle(
                                fontSize: 18,
                                fontFamily: "noto-sans",
                                fontWeight: FontWeight.w400
                            )
                        ),
                        onPressed: () => MovePage(context),
                        child: const Text('회원가입')
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}




// Future<void> login_check(BuildContext context) async {
//
// }