class AlgorithmTypes {
  String imageUrl;
  String name;
  String noOfAlgorithms;

  AlgorithmTypes(this.imageUrl, this.name, this.noOfAlgorithms);

  @override
  String toString() {
    return this.name + "\t\t" + this.noOfAlgorithms + "\t\t" + this.imageUrl;
  }
}
