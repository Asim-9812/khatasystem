



import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import '../../common/colors.dart';
import '../../utils/util_functions.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 28,
            color: Colors.white,
          ),
        ),
        title: const Text('About Us'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Center(child: Image.asset('assets/images/khata-logo-name.png',width: 300,)),
            const SizedBox(height: 20,),
            Text('Contact Us',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        fixedSize: Size.fromHeight(50),
                        elevation: 1,
                        backgroundColor: ColorManager.white
                      ),
                      onPressed: (){
                        LauncherUtils.openPhone('01-4106642');
                      }, child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                      Icon(Icons.phone,color: ColorManager.primary,),
                      const SizedBox(width: 10,),
                      Text('01-4106642',style: TextStyle(color: ColorManager.black),)
                                          ],
                                        )),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 1,
                          fixedSize: Size.fromHeight(50),
                        backgroundColor: ColorManager.white
                      ),
                      onPressed: (){
                        LauncherUtils.openPhone('9801867400');
                      }, child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                      Icon(Icons.phone,color: ColorManager.primary,),
                      const SizedBox(width: 10,),
                      Text('9801867400',style: TextStyle(color: ColorManager.black),)
                                          ],
                                        )),
                ),
              ],
            ),
            const SizedBox(height: 05,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    elevation: 1,
                    fixedSize: Size.fromHeight(50),
                    backgroundColor: ColorManager.white
                ),
                onPressed: (){
                  LauncherUtils.openMail();
                }, child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                Icon(Icons.mail,color: ColorManager.primary,),
                const SizedBox(width: 10,),
                Text('reply2searchtech@gmail.com',style: TextStyle(color: ColorManager.black),)
                              ],
                            )),
            const SizedBox(height: 20,),
            Text('App Info',style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30,),),
            Divider(),
            Card(
              child: ListTile(
                onTap: ()=>LauncherUtils.launchAppPlayStore(),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                leading: Icon(Icons.star_rate_rounded,color: ColorManager.primary,),
                title: Text('Rate this app',style: TextStyle(fontSize: 16),),
                subtitle: Text('Rate and show us support',style: TextStyle(fontSize: 12),),
              ),
            ),
            const SizedBox(height: 05,),
            Card(
              child: ListTile(
                onTap: ()async=> await shareApp(),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                leading: Icon(Icons.share,color: ColorManager.primary,),
                title: Text('Share this app',style: TextStyle(fontSize: 16),),
                subtitle: Text('Share with others',style: TextStyle(fontSize: 12),),
              ),
            ),
            const SizedBox(height: 05,),
            Card(
              child: ListTile(
                onTap: ()=>LauncherUtils.launchAppPlayStore(),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                leading:Image.asset('assets/images/new-logo.png',width: 25,height: 25,),
                title: Text('Version 1.1.1',style: TextStyle(fontSize: 16),),
                subtitle: Text('Tap to check for updates',style: TextStyle(fontSize: 12),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> shareApp() async {
    // Set the app link and the message to be shared
    final String appLink = 'https://play.google.com/store/apps/details?id=com.searchtech.khatasystem&hl=en';
    final String message = 'Check out our app: \n $appLink';

    // Share the app link and message using the share dialog
    await FlutterShare.share(title: 'Khata System', text: message);
  }

}
