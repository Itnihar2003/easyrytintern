import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todoaiapp/pages/home/cookingai.dart';

class suggesiondetail extends StatefulWidget {

  const suggesiondetail({super.key, });

  @override
  State<suggesiondetail> createState() => _suggesiondetailState();
}

class _suggesiondetailState extends State<suggesiondetail> {
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
    "YouTube Script Creator:",
    "Restaurant Reviews Companion:",
    "Technology Insight Hub:",
    "Life Guide Advisor:",
    "English Enhancement Studio:",
    "Language Recognition Navigator:",
    "Identify languages easily: notes on patterns, dialects, nuances.",
    "Chinese-English Translation Wizard:",
    "Poetry Crafting Studio:",
    "Article Extension Navigator:",
    "Writing Materials Collection:",
    "Writing Advisory Hub :",
    "Writing Support System",
    "Storytelling Keywords Generator:",
    "SEO-Optimized Article Wizard:",
    "Book Summaries Companion:",
    "Philosophical Pondering Aid:",
    "Fallacy Detection System:",
    "Debate Perspective Generator:",
    "Theme Deconstruction Companion:",
    "Think Tank Assistant:",
    "Question Query Companion:"
  ];
  List content = [
    "Create impactful ad plans, targeting effectively. ",
    "Optimize content, format, showcase achievements—elevate profile. ",
    "Craft personalized, skill-focused cover letters. ",
    "Master public speaking: key points, impact.",
    " Condense details, maintain clarity—summarize effectively. ",
    "Refine email communication: language, tone, structure. ",
    "Prioritize tasks, set goals—boost productivity weekly. ",
    "Craft hilarious punchlines, witty observations—laughter guaranteed. ",
    "Spread joy, warmth—personalized holiday wishes crafted. ",
    "Understand dream symbolism—unravel nightly mysteries. ",
    "Roll good times with creative leisure. ",
    "Elevate playlist: personalized notes, mood-matching recommendations.",
    "Make informed shopping decisions—expert reviews, trends, comparisons.",
    "Kitchen maestro: enhance, experiment with culinary improvisation.",
    "Effortless adventure planning: personalized travel notes, insider tips.",
    "Elevate social media: catchy, engaging photo captions.",
    "Create tweets: quick-witted, attention-grabbing content.",
    "Create YouTube scripts: engage, entertain, compel.",
    "Craft engaging restaurant reviews: ambiance, cuisine, experience.",
    "Cutting-edge tech reviews: features, performance, user experience.",
    "Navigate life's complexities: personalized notes, holistic guidance.",
    "Expand English writing: grammar, vocabulary, structure refinement.",
    "Identify languages easily: notes on patterns, dialects, nuances.",
    "Translate Chinese to English seamlessly: context, culture.",
    "Craft expressive poems: refine rhythm, imagery, devices.",
    "Continue articles seamlessly: content, tone, structure continuity.",
    "Curate diverse writing materials: genres, styles, themes.",
    "Gain expert writing advice: technique, style, storytelling.",
    "Assist at every writing stage: brainstorming, drafting, polishing.",
    "Spark creativity: curated keywords inspire enriched narrative.",
    "Optimize online presence with SEO articles.",
    "Summarize books: key themes, characters, plot.",
    "Deepen philosophy: key concepts, theories, perspectives notes.",
    "Hone argumentative skills: fallacy finder notes, logical errors.",
    " Craft compelling debate points: diverse viewpoints, enriched arguments.",
    "Explore themes deeply: symbolism, motifs, underlying messages.",
    "Innovate with think tank's collaborative notes.",
    "Hone questioning skills: craft thoughtful, probing questions."
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
                              builder: (context) => ai2(),
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
                                tittle[index],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                content[index],
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
