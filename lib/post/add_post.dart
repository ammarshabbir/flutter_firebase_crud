import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/app_constants.dart';
import 'package:flutter_firebase/utils/utils_function.dart';
import 'package:flutter_firebase/widgets/round_button.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  final postController = TextEditingController();
  bool loader = false;
  final _formKey = GlobalKey<FormState>();

  DatabaseReference ref = FirebaseDatabase.instance.ref('post');

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    postController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "fild cannot be empty";
                    }
                  },
                  maxLines: 4,
                  controller: postController,
                  decoration:InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "What's in your mind?"
                  ),
                ),
              ],
            ),),

            SizedBox(height: 20,),
            RoundButton(
              title: AppConstants.post,
              loader: loader,
              onTap: () async{
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                if (_formKey.currentState!.validate() == true) {
                  setState(() {
                    loader = true;
                  });



                await  ref.child(id).set(
                      {
                        'title':postController.text,
                        'id':id
                      }).then((value){
                        Utils().flutterToast('Post added');
                        Navigator.pop(context);
                  setState(() {
                    loader = false;
                  });
                  }).onError((err,stackTrack){
                  Utils().flutterToast(err.toString());
                  setState(() {
                    loader = false;
                  });
                  });

                }
              },
            ),

          ],
        ),
      ),
    );
  }
}
