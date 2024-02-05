import 'package:flutter/material.dart';

import 'package:todoaiapp/pages/home/cookingai.dart';

class suggesiondetail extends StatefulWidget {
  final List suggestedtext;
  final List suggestedcontent;
  const suggesiondetail({
    super.key,
    required this.suggestedtext,
    required this.suggestedcontent,
  });

  @override
  State<suggesiondetail> createState() => _suggesiondetailState();
}

class _suggesiondetailState extends State<suggesiondetail> {
  List images = [
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
    "assets/YouTube Script Creator.png",
    "assets/Restaurant Reviews Companion.png",
    "assets/Technology Insight Hub.png",
    "assets/Life Guide Advisor.png",
    "assets/English Enhancement Studio.png",
    "assets/Language Recognition Navigator.png",
    "assets/Chinese-English Translation Wizard.png",
    "assets/Poetry Crafting Studio.png",
    "assets/Article Extension Navigator.png",
    "assets/Writing Materials Collection.png",
    "assets/Writing Advisory Hub.png",
    "assets/Writing Support System.png",
    "assets/Storytelling Keywords Generator.png",
    "assets/SEO-Optimized Article Wizard.png",
    "assets/Book Summaries Companion.png",
    "assets/Philosophical Pondering Aid.png",
    "assets/Fallacy Detection System.png",
    "assets/Debate Perspective Generator.png",
    "assets/Theme Deconstruction Companion.png",
    "assets/Think Tank Assistant.png",
    "assets/Question Query Companion.png"
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
                  mainAxisExtent: 150,
                ),
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ai2(
                                givendata: widget.suggestedtext[index],
                                givencontent: widget.suggestedcontent[index],
                              ),
                            ));
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 25,
                                height: 23,
                                child: Image.asset(
                                  images[index],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.suggestedtext[index],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.suggestedcontent[index],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.18),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: Offset(-2, 2),
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // suggesion(widget.text1)
        ],
      ),
    );
  }
}
