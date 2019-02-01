/// Checks if [one] map is equals with [second]
bool isMapsEqual(Map<Object, Object> one, Map<Object, Object> second) {
  if (one.runtimeType == second.runtimeType && one.length == second.length) {
    final oKeys = one.keys.toList();
    final sKeys = second.keys.toList();
    final oValues = one.values.toList();
    final sValues = second.values.toList();

    for (var i = 0; i < one.length; i++) {
      if (oKeys[i] != sKeys[i] || oValues[i] != sValues[i]) {
        return false;
      }
    }
    return true;
  }
  return false;
}
