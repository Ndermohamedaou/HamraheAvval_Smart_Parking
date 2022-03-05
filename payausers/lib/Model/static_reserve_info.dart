class StaticReserveInfo {
  final String staticReserveId;
  final int reserveStatus;
  final String slotNumber;
  final String buildingName;
  final List cancelDays;

  StaticReserveInfo({
    this.staticReserveId,
    this.reserveStatus,
    this.slotNumber,
    this.buildingName,
    this.cancelDays,
  });
}
