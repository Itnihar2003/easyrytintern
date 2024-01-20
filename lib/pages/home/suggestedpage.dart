import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todoaiapp/pages/home/cookingai.dart';

class suggesiondetail extends StatefulWidget {
  final List text1;
  const suggesiondetail({super.key, required this.text1});

  @override
  State<suggesiondetail> createState() => _suggesiondetailState();
}

class _suggesiondetailState extends State<suggesiondetail> {
  List text = [
    "All",
    "Work Tools",
    "Daily Tools",
    "Comments/Guidelines",
    "Language/Translation",
    "Article/Story",
    "Deep Thinking",
  ];

  List images = [
    // "assets/testing background.png",
    "assets/Marketing Strategy Blueprint.png",
    "assets/Resume Enhancement Studio.png",
    "assets/Cover Letter Composer.png",
    "assets/Speechcraft Navigator.png",
    "assets/Content Summarization Tool.png",
    "assets/Mail Mastery Assistant.png",
    "assets/Weekly Planner Generator.png",
    "assets/Stand-Up Comedy Companion.png",
    "assets/Holiday Wishes Generator.png",
    "assets/Dream Interpretation Wizard.png",
    "assets/Fun Suggestions Hub.png",
    "assets/Song Recommendations Maven.png",
    "assets/Shopping Advice Advisor.png",
    "assets/imp.png",
    "assets/Travel Guide Companion.png",
    "assets/Instagram Captions Guru.png",
    "assets/Tweet Generator.png",
    "assets/YouTube Script Creator.png"
  ];
  List colors = [
    Colors.amber,
    const Color.fromARGB(255, 149, 199, 240),
    const Color.fromARGB(255, 177, 128, 111),
    const Color.fromARGB(255, 149, 174, 186),
    Colors.cyan,
    Colors.deepOrange,
    Colors.green,
    Colors.lightBlue,
    Colors.lime,
    Colors.red,
    Colors.purple,
    Colors.pink,
    Colors.amberAccent,
    Colors.yellow,
    Colors.redAccent,
    Colors.red,
    Colors.purple,
    Colors.yellow,
  ];
  List tittle = [
    "Marketing Strategy Blueprint:",
    "Resume Enhancement Studio:",
    "Cover Letter Composer:",
    "Speechcraft Navigator:",
    "Content Summarization Tool:",
    "Mail Mastery Assistant:",
    "Weekly Planner Generator:",
    "Stand-Up Comedy Companion:",
    "Holiday Wishes Generator:",
    "Dream Interpretation Wizard:",
    "Fun Suggestions Hub:",
    "Song Recommendations Maven:",
    "Shopping Advice Advisor:",
    "Improvise Recipes Companion :",
    "Travel Guide Companion:",
    "Instagram Captions Guru:",
    "Tweet Generator:",
    "YouTube Script Creator:"
  ];
  List content = [
    "   Develop comprehensive advertising plans with notes on target audience analysis, brand positioning, and effective communication strategies, ensuring a strategic and impactful marketing approach.",
    "   Elevate your professional profile with notes offering insights into optimizing content, formatting, and showcasing achievements, resulting in a polished and compelling resume.",
    "Create compelling cover letters with the help of notes that guide you through personalization, showcasing skills, and aligning your qualifications with the job requirements.",
    "Master public speaking engagements with notes providing key points, impactful language, and effective structure for engaging and memorable speeches.",
    "Streamline information with the content summary generator, offering notes on condensing key details, maintaining clarity, and presenting a concise overview.",
    "   Optimize your email communication with AI-generated notes suggesting language, tone, and structure, ensuring your messages are clear, professional, and effective.",
    "Stay organized and focused with the weekly generator, providing notes on prioritizing tasks, setting goals, and managing your schedule for enhanced productivity.",
    "Generate hilarious punchlines, witty observations, and comedic notes to fine-tune your stand-up routine and keep the laughs rolling.",
    "Spread joy and warmth with personalized holiday wishes and greetings, as the app crafts heartfelt notes tailored to the occasion.",
    "   Unravel the mysteries of your dreams with insightful notes to help you understand and interpret the symbolism behind your nightly adventures.",
    "Keep the good times rolling with creative and enjoyable suggestions for activities, games, and leisure pursuits.",
    "   Elevate your music playlist with personalized notes for song recommendations that match your mood and preferences.",
    "   Get expert shopping advice and make informed decisions with notes on product reviews, trends, and comparisons.",
    "   Become a kitchen maestro with improvisational notes to enhance and experiment with your culinary creations.",
    "Plan your next adventure effortlessly with personalized travel notes for destinations, attractions, and insider tips.",
    "   Boost your social media presence with catchy and engaging captions tailored to your photos and posts.",
    "    Craft captivating tweets effortlessly with notes for quick-witted and attention-grabbing content.",
    "Develop engaging and entertaining video scripts with notes and suggestions for creating compelling content on YouTube.",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Tools",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: text.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 232, 230, 230),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          text[index],
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Featured",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 245,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ai2(),
                            ));
                      },
                      child: Container(
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                  width: 130,
                                  child: Image.asset(images[index])),
                            ),
                            Positioned(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                tittle[index],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                            Positioned(
                                top: 60,
                                left: 1,
                                right: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                    content[index],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  )),
                                ))
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: colors[index],
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  );
                },
              ),
              // child: GridView.custom(
              //   gridDelegate: SliverWovenGridDelegate.count(
              //     crossAxisCount: 2,
              //     mainAxisSpacing: 2,
              //     crossAxisSpacing: 2,
              //     pattern: [
              //       WovenGridTile(1),
              //       WovenGridTile(
              //         6 / 8,
              //         crossAxisRatio: 0.9,
              //         alignment: AlignmentDirectional.centerEnd,
              //       ),
              //     ],
              //   ),
              //   childrenDelegate: SliverChildBuilderDelegate(
              //       childCount: images.length + widget.text1.length,
              //       (BuildContext context, int index) {
              //     if (index > images.length) {
              //       return InkWell(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => ai(),
              //               ));
              //         },
              //         child: Container(
              //           child: Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Stack(
              //               children: [
              //                 ListView(
              //                   children: [
              //                     Text(
              //                       widget.text1[index - images.length],
              //                       style: TextStyle(
              //                           color: Colors.black,
              //                           fontWeight: FontWeight.w500,
              //                           fontSize: 13),
              //                     ),
              //                     SizedBox(
              //                       height: 8,
              //                     ),
              //                     Text(
              //                       "taste creative cuisine at the spicy foods festival! create culinary..",
              //                       style: TextStyle(
              //                           color: Colors.black, fontSize: 8),
              //                     )
              //                   ],
              //                 ),
              //                 Positioned(
              //                     bottom: 5,
              //                     right: 0,
              //                     child: Image.asset("assets/add.png"))
              //               ],
              //             ),
              //           ),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(20),
              //             color: Colors.white,
              //             boxShadow: const [
              //               BoxShadow(
              //                 color: Color.fromRGBO(0, 0, 0, 0.09),
              //                 blurRadius: 5,
              //                 spreadRadius: 0,
              //                 offset: Offset(-4, 4),
              //               ),
              //             ],
              //           ),
              //           height: 135,
              //           width: 121.59,
              //         ),
              //       );
              //     } else if (index == 0) {
              //       return InkWell(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => ai(),
              //               ));
              //         },
              //         child: Container(
              //           child: Image.asset(
              //             "assets/12.png",
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //       );
              //     } else if (index == images.length) {
              //       return InkWell(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => ai(),
              //               ));
              //         },
              //         child: Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(20),
              //             color: Colors.white,
              //             boxShadow: const [
              //               BoxShadow(
              //                 color: Color.fromRGBO(0, 0, 0, 0.09),
              //                 blurRadius: 5,
              //                 spreadRadius: 0,
              //                 offset: Offset(-4, 4),
              //               ),
              //             ],
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: InkWell(
              //               onTap: () {
              //                 Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) => ai(),
              //                     ));
              //               },
              //               child: Stack(
              //                 children: [
              //                   ListView(
              //                     children: [
              //                       Text("work"),
              //                       Text(
              //                         "Tools",
              //                         style: TextStyle(
              //                             fontSize: 20,
              //                             fontWeight: FontWeight.bold),
              //                       ),
              //                       Text(
              //                         widget.text1[0],
              //                         style: TextStyle(
              //                           fontSize: 13,
              //                           fontWeight: FontWeight.w500,
              //                         ),
              //                       ),
              //                       Text(
              //                         "taste creative cuisine at the spicy foods festival! create culinary..",
              //                         style: TextStyle(fontSize: 8),
              //                       )
              //                     ],
              //                   ),
              //                   Positioned(
              //                       bottom: 5,
              //                       right: 1,
              //                       child: Image.asset("assets/add.png"))
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     } else if (index == images.length - 1) {
              //       return Container(
              //         color: Colors.white,
              //       );
              //     } else {
              //       return InkWell(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => ai(),
              //               ));
              //         },
              //         child: Container(
              //           child: Image.asset(
              //             images[index],
              //             fit: BoxFit.fill,
              //           ),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(20),
              //           ),
              //         ),
              //       );
              //     }
              //   }),
              // ),
            ),
          ),

          // suggesion(widget.text1)
        ],
      ),
    );
  }
}
