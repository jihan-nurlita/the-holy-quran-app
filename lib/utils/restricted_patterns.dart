const restrictedPatterns = [
  r'(.)\1{2,}', // huruf berulang
  r'[aeiou]{4,}', // vokal berlebihan
  r'[bcdfghjklmnpqrstvwxyz]{4,}', // konsonan aneh
  r'(rr|tt|hh|ll)$', // akhiran emosi
];
