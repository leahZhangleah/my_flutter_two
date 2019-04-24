import 'package:flutter/material.dart';
import 'package:repair_server/model/personalmodel.dart';
import 'knowledge_model.dart';
class KnowledgePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("知识讲堂"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: 4,
          itemBuilder: (context,index){
            KnowledgeModel knowledgeModel = getKnowledgeList()[index];
            return ListTile(
              leading: knowledgeModel.leadingIcon,
              title: Text(knowledgeModel.text),
            );
          }),
    );
  }

  List<KnowledgeModel> getKnowledgeList(){
    return <KnowledgeModel>[
      KnowledgeModel(
        leadingIcon: Image.asset("assets/images/公司制度.png"),
        text: "公司制度",
      ),
      KnowledgeModel(
        leadingIcon: Image.asset("assets/images/草足手册.png"),
        text: "软件操作手册",
      ),
      KnowledgeModel(
        leadingIcon: Image.asset("assets/images/结算说明.png"),
        text: "结算说明",
      ),
      KnowledgeModel(
        leadingIcon: Image.asset("assets/images/维修技能.png"),
        text: "维修技能",
      ),
    ];
  }

}