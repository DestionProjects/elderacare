class CrcCalculator {
  static int calculateCRC(List<int> data) {
    int crc = 0;
    for (int byte in data) {
      crc = (crc + byte) & 0xFF;
    }
    return crc;
  }
}
