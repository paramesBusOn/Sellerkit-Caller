class Responce {
  String? responceBody;
  int? resCode;

  Responce({
     this.resCode,
     this.responceBody
  });

  factory Responce.getRes(int res, String body){
    return Responce(
      resCode: res,
      responceBody: body
    );
  }
}