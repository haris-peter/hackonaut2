import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Jobs/job_listing.dart';
import 'package:ijob_clone_app/Search/search_job.dart';
import 'package:ijob_clone_app/Services/global_variables.dart';
import 'package:ijob_clone_app/Widgets/bottom_nav_bar.dart';
import 'package:ijob_clone_app/Widgets/job_widget.dart';
import 'package:ijob_clone_app/theme/colors.dart';

import '../Persistent/persistent.dart';


class JobScreen extends StatefulWidget {
  final String userID;

  const JobScreen({ required this.userID});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  

  String? jobCategoryFilter;
  String? imageUrl = '';
  bool _isLoading = false;
  bool _isSameUser = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void getUserData() async
  {
    try{
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();
      if(userDoc == null)
      {
        return;
      }
      else
      {
        setState(() {
          name = userDoc.get('name');
          
          
          imageUrl = userDoc.get('userImage');
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
      }
    }catch(error){} finally
    {
      _isLoading = false;
    }
  }
  
  _showTaskCategoriesDialog({required Size size})
  {
    showDialog(
      context: context,
      builder: (ctx)
      {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: const Text(
            'Project Category',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),

          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Persistent.jobCategoryList.length,
              itemBuilder: (ctx, index)
              {
                return InkWell(
                  onTap: (){
                    setState(() {
                      
                      jobCategoryFilter = Persistent.jobCategoryList[index];
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null ;
                    print(
                      'jogCategoryList[index], ${Persistent.jobCategoryList[index]}'
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_right_alt_outlined,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Persistent.jobCategoryList[index],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: ()
              {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text('Close',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: (){
                setState(() {
                  jobCategoryFilter = null;
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text('Cancel Filter', style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    Persistent persistentObject = Persistent();
    persistentObject.getMyData();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> jobStream() {
    // Replace 'jobs' with the name of your collection
    return FirebaseFirestore.instance.collection('jobs').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
       color: Colors.white
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        
        body:SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar(context),
            _header(context),
            Container(
                  height: size.height * 0.7, // Adjust the height as needed
                  child: JobListWidget(jobStream: FirebaseFirestore.instance.collection('jobs').snapshots()),
                ),
          ],
        ),
      ),
        ),
      ),
        ),
    );
  }
  Widget _appBar(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                                  imageUrl == null
                                      ?
                                  'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                                      :
                                  imageUrl!,
                                  
                                ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: Colors.black,),
            onPressed: () {_showTaskCategoriesDialog(size: size);},
          )
        ],
      ),
    );
  }
    Widget _header(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              name == null
              ?
              'Name here'
              :
              name!,
              style: TextStyle(
                fontSize: 15,
                color: KColors.subtitle,
                fontWeight: FontWeight.w500,
              )),
          SizedBox(
            height: 6,
          ),
          Text("Reccomended Project",
              style: TextStyle(
                  fontSize: 20,
                  color: KColors.title,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
         
        ],
      ),
    );
  }
  


  
}
