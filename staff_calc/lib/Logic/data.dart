import 'Models/Ward.dart';

class Data{

  static List<Ward> getWards(){
    var list = <Ward>[
      new Ward(name: "Section A", labourHours: 7,),
      new Ward(name: "Section B", labourHours: 7,),
      new Ward(name: "Section D", labourHours: 8,),
      new Ward(name: "Section E", labourHours: 8,),
      new Ward(name: "Section F", labourHours: 6,),
      new Ward(name: "Section G", labourHours: 8,),
      new Ward(name: "Section H", labourHours: 7,),
      new Ward(name: "Section J", labourHours: 8,),
      new Ward(name: "Femina", labourHours: 8,),
      new Ward(name: "Maternity", labourHours: 11,),
      new Ward(name: "NNICU", labourHours: 18,),
      new Ward(name: "MICU", labourHours: 20,),
      new Ward(name: "SICU", labourHours: 20,),
      new Ward(name: "TICU", labourHours: 20,),
      new Ward(name: "CCU", labourHours: 18,),
      new Ward(name: "A&E", labourHours: 4,),
      new Ward(name: "Theatre", labourHours: 7,),
    ];

    return list;
  }

}