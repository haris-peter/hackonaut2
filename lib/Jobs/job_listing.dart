import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ijob_clone_app/Jobs/job_details.dart';
import 'package:ijob_clone_app/Widgets/job_widget.dart';

class JobListWidget extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> jobStream;

  const JobListWidget({required this.jobStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: jobStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.docs.isNotEmpty == true) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                // Extract job details from the snapshot
                Map<String, dynamic> jobData = snapshot.data?.docs[index].data() as Map<String, dynamic>;

                return JobWidget(
                  jobTitle: jobData['jobTitle'],
                  jobDescription: jobData['jobDescription'],
                  jobId: jobData['jobId'],
                  uploadedBy: jobData['uploadedBy'],
                  userImage: jobData['userImage'],
                  name: jobData['name'],
                  recruitment: jobData['recruitment'],
                  email: jobData['email'],
                  location: jobData['location'],
                  
                );
              },
            );
          } else {
            return const Center(
              child: Text('There are no jobs'),
            );
          }
        }
        return Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        );
      },
    );
  }
}
